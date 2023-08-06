import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/features/core/app_converters.dart';
import 'package:weltweit/features/core/base/base_states.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/data/models/documents/document.dart';
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
                        if (false)
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addDocument(context, docType: null),
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
                    itemCount: DocumentType.values.length,
                    itemBuilder: (context, index) {
                      List<Document>? documents = state.data?.where((element) {
                        String currentType = DocumentType.values[index].name;
                        if (currentType == 'others_2' || currentType == 'others_3') {
                          currentType = 'others';
                        }
                        return element.type == currentType;
                      }).toList();
                      bool showAddButton = documents == null || documents.isEmpty;

                      Document? document = documents == null
                          ? null
                          : documents.isNotEmpty
                              ? documents[0]
                              : null;

                      //* In case of other_2 and other_2 check for second other file and third other file
                      if (DocumentType.values[index] == DocumentType.others_2) {
                        if (documents != null && documents.length > 1) {
                          document = documents[1];
                        } else {
                          document = null;
                        }
                      }
                      if (DocumentType.values[index] == DocumentType.others_3) {
                        if (documents != null && documents.length > 2) {
                          document = documents[2];
                        } else {
                          document = null;
                        }
                      }

                      if (showAddButton || document == null) {
                        return Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration().customColor(AppColorLight().kPrimaryColor.withOpacity(0.2)).radius(radius: 8),
                              child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  addDocument(context, docType: DocumentType.values[index]);
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              child: Container(
                                decoration: BoxDecoration().chip(color: primaryColor.withOpacity(0.6)).radius(radius: 8.r),
                                padding: EdgeInsets.zero,
                                child: CustomText(AppConverters.documentTypeToString(DocumentType.values[index]), ph: 8, pv: 2, size: 12, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }
                      return SingleDocumentItem(document: document);
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

  void addDocument(BuildContext context, {required DocumentType? docType}) async {
    DocumentType? type = docType;
    File? file;
    if (type == null) {
      List<String> list = DocumentType.values.map((e) => AppConverters.documentTypeToString(e)).toList();
      //remove duplicates
      list = list.toSet().toList();
      String? result = await AppDialogs().select<String>(context: context, list: list);
      if (result == null) return;
      type = AppConverters.stringToDocumentType(result);
    }
    // ignore: use_build_context_synchronously
    file = await AppDialogs().pickImage(context);

    if (file == null) return;

    if (type == DocumentType.others_2 || type == DocumentType.others_3) {
      type = DocumentType.others;
    }

    DocumentParams params = DocumentParams(documentType: type, image: file);

    bool status = await AppDialogs().question(
      context,
      title: LocaleKeys.notification.tr(),
      message: LocaleKeys.areYouSureToAdd.tr(),
    );

    if (status && context.mounted) BlocProvider.of<DocumentsCubit>(context).addDocument(params);
  }
}
