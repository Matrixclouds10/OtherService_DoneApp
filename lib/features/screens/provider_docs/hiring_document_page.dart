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
import 'package:weltweit/features/widgets/app_text_tile.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/features/logic/provider_documents/documents_cubit.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/component.dart';

class HiringDocumentPage extends StatelessWidget {
  const HiringDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DocumentsCubit()..getHiringDocuments(),
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
    return BlocBuilder<DocumentsCubit, DocumentsState>(
      builder: (context, state) {
        Locale currentLocale = context.locale;
        switch (state.getHitingDocsState) {
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
                      title: LocaleKeys.requiredDocuments.tr(),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Image.asset(Assets.imagesLogo, width: double.infinity, height: 90),
                  const SizedBox(height: 24),
                  CustomText(
                    LocaleKeys.requiredDocumentsDesc.tr(),
                    bold: true,
                  ).header(),
                  if (state.getHitingDocsState == BaseState.loaded)
                    Container(
                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: const BoxDecoration(color: Colors.white).radius(radius: 12),
                      child: Column(
                        children: [
                          ...state.hiringDocuments.map((e) {
                            String title = currentLocale.languageCode == 'en' ? e.titleEn ?? '' : e.titleAr ?? '';
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              child: AppTextTile(
                                title: CustomText(title, size: 16, pv: 0, align: TextAlign.start),
                                isTitleExpanded: true,
                                leading: Icon(Icons.circle, size: 12),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
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
