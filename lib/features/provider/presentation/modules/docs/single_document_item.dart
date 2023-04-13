import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/resources.dart';
import 'package:weltweit/features/provider/data/models/response/documents/document.dart';
import 'package:weltweit/features/widgets/app_dialogs.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import 'package:weltweit/features/provider/logic/documents/documents_cubit.dart';
import 'package:weltweit/features/core/widgets/custom_text.dart';
import 'package:weltweit/presentation/component/component.dart';

class SingleDocumentItem extends StatelessWidget {
  final Document document;

  const SingleDocumentItem({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    if (document.image == null) return Container();
    return Container(
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          CustomImage(
            imageUrl: document.image,
            canEdit: false,
            width: double.infinity,
            height: double.infinity,
            border: Border.all(color: Colors.transparent, width: 1),
            radius: 8,
            fit: BoxFit.fill,
          ),
          if (convertToProperDocumentType(document.type).isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration().chip(color: primaryColor.withOpacity(0.6)).radius(radius: 8.r),
                padding: EdgeInsets.zero,
                child: CustomText(convertToProperDocumentType(document.type), ph: 8, pv: 2, size: 12, color: Colors.white),
              ),
            ),

          //delete action
          Positioned(
            top: 0,
            left: 0,
            child: GestureDetector(
                onTap: () async {
                  if (document.deleting) return;
                  bool status = await AppDialogs().confirmDelete(context);
                  if (status) {
                    if (document.id != null) {
                      if (context.mounted) {
                        context.read<DocumentsCubit>().delete(document);
                      }
                    }
                  }
                },
                child: document.deleting
                    ? Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                        ))
                    : Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.all(4),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration().chip(color: Colors.black.withOpacity(0.3)).radius(radius: 100.r),
                        child: Center(
                          child: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 10,
                          ),
                        ),
                      )),
          ),
        ],
      ),
    );
  }

  String convertToProperDocumentType(String? type) {
    if (type == null) return '';
    if (type == 'work_certificate') return LocaleKeys.workCertificate;
    if (type == 'passport') return LocaleKeys.passport;
    if (type == 'national_id') return LocaleKeys.nationalId;
    if (type == 'corona_certificate') return LocaleKeys.coronaCertificate;
    if (type == 'others') return type;
    return '';
  }
}
