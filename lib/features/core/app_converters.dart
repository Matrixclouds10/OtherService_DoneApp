import 'package:easy_localization/easy_localization.dart';
import 'package:weltweit/features/domain/usecase/provider_document/document_add_usecase.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class AppConverters {
  static String documentTypeToString(DocumentType documentType) {
    switch (documentType) {
      case DocumentType.national_id:
        return LocaleKeys.nationalId.tr();
      case DocumentType.work_certificate:
        return LocaleKeys.workCertificate.tr();
      case DocumentType.corona_certificate:
        return LocaleKeys.coronaCertificate.tr();
      case DocumentType.passport:
        return LocaleKeys.passport.tr();
      case DocumentType.others:
        return LocaleKeys.other.tr();
    }
  }

  static DocumentType stringToDocumentType(String documentType) {
    if (documentType == LocaleKeys.nationalId.tr()) {
      return DocumentType.national_id;
    } else if (documentType == LocaleKeys.workCertificate.tr()) {
      return DocumentType.work_certificate;
    } else if (documentType == LocaleKeys.coronaCertificate.tr()) {
      return DocumentType.corona_certificate;
    } else if (documentType == LocaleKeys.passport.tr()) {
      return DocumentType.passport;
    } else if (documentType == LocaleKeys.other.tr()) {
      return DocumentType.others;
    } else {
      return DocumentType.others;
    }
  }
}
