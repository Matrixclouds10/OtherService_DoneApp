import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/features/core/app_converters.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_add_usecase.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/features/widgets/app_snackbar.dart';
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/features/logic/provider_documents/documents_cubit.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/features/screens/provider_docs/single_document_item.dart';
import 'package:weltweit/presentation/component/component.dart';

class DocumentPage extends StatelessWidget {
  const DocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentsCubit()..getDocuments(),
      child: Container(
        color: Colors.white,
        child: SafeArea(
            child: Scaffold(
          backgroundColor: AppColorLight().kScaffoldBackgroundColor,
          body: documentsBody(),
        )),
      ),
    );
  }

  Widget documentsBody() {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
      listenWhen: (previous, current) => previous.addState != current.addState,
      listener: (context, state) {
        if (state.addState == BaseState.loaded) {
          AppSnackbar.show(
            context: context,
            message: LocaleKeys.addedSuccessfully.tr(),
            type: SnackbarType.success,
          );
          BlocProvider.of<DocumentsCubit>(context).getDocuments(loading: false);
        }
      },
      builder: (context, state) {
        log('documentsBody', 'state: $state');
        switch (state.state) {
          case BaseState.initial:
            break;
          case BaseState.loading:
            return Center(child: CustomLoadingSpinner());
          case BaseState.loaded:
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    child: CustomAppBar(
                      title: LocaleKeys.myFiles.tr(),
                      color: Colors.white,
                      actions: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            addDocument(context);
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    key: GlobalKey(),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 020),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: state.data!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == state.data!.length) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration().customColor(AppColorLight().kPrimaryColor.withOpacity(0.2)).radius(radius: 8),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              addDocument(context);
                            },
                          ),
                        );
                      }

                      return SingleDocumentItem(document: state.data![index]);
                    },
                  ),
                  ...[
                    LocaleKeys.makeSureToUploadAllFiles.tr(),
                    LocaleKeys.copyOfId.tr(),
                    LocaleKeys.copyOfWorkLicense.tr(),
                    LocaleKeys.copyOfPassport.tr(),
                    LocaleKeys.anyOthers.tr(),
                  ]
                      .map((e) => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: AppTextTile(
                              title: CustomText(e, size: 16, pv: 0, align: TextAlign.start),
                              isTitleExpanded: true,
                              leading: Icon(Icons.circle, size: 12),
                            ),
                          ))
                      .toList(),
                  SizedBox(height: 20),
                ],
              ),
            );
          case BaseState.error:
            break;
        }
        return Container();
      },
    );
  }

  void addDocument(BuildContext context) async {
    DocumentType? type;
    File? file;
    List<String> list = DocumentType.values.map((e) => AppConverters.documentTypeToString(e)).toList();
    String? result = await AppDialogs().select<String>(context: context, list: list);
    if (result == null) return;
    type = AppConverters.stringToDocumentType(result);

    // ignore: use_build_context_synchronously
    file = await AppDialogs().pickImage(context);

    if (file == null) return;
    DocumentParams params = DocumentParams(documentType: type, image: file);
    if (context.mounted) BlocProvider.of<DocumentsCubit>(context).addDocument(params);
  }
}
