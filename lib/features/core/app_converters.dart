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
      case DocumentType.others_2:
        return LocaleKeys.other.tr();
      case DocumentType.others_3:
        return LocaleKeys.other.tr();
      case DocumentType.national_id_back:
        return LocaleKeys.nationalIdBack.tr();
      case DocumentType.ciminal_certificate:
        return LocaleKeys.ciminalCertificate.tr();
      case DocumentType.personal_image:
        return LocaleKeys.personalImage.tr();
      case DocumentType.tax_card:
        return LocaleKeys.taxCard.tr();
      case DocumentType.commercial_register:
        return LocaleKeys.commercialRegister.tr();
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
    } else if (documentType == LocaleKeys.nationalIdBack.tr()) {
      return DocumentType.national_id_back;
    } else if (documentType == LocaleKeys.ciminalCertificate.tr()) {
      return DocumentType.ciminal_certificate;
    } else if (documentType == LocaleKeys.personalImage.tr()) {
      return DocumentType.personal_image;
    } else if (documentType == LocaleKeys.taxCard.tr()) {
      return DocumentType.tax_card;
    } else if (documentType == LocaleKeys.commercialRegister.tr()) {
      return DocumentType.commercial_register;
    } else {
      return DocumentType.others;
    }
  }
}
