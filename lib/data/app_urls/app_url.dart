import 'domain.dart';

class AppURL {
  static const kAPIKey = "";
  // static const kBaseURL = "https://propertiesapk.net/api";
  // static const kBaseURL = "https://propertiesapk.net/api";

  ///Auth
  static const String kLoginURI = "$kBaseURL/auth/login";
  static const String kRegisterURI = "$kBaseURL/auth/register";
  static const String kLogoutURI = "$kBaseURL/auth/logout";
  static const String kForgetPasswordURI = "$kBaseURL/auth/otp";
  static const String kForgetPasswordProviderURI = "$kBaseURL/service-provider/otp";
  static const String kCheckOTPURI = "$kBaseURL/auth/check-otp";
  static const String kResetPasswordURI = "$kBaseURL/";
  static const String kDeleteAccountURI = "$kBaseURL/";
  static const String kUpdateFCMTokenURI = "$kBaseURL/fcm_token";

  ///more
  static const String kGetProfileURL = "$kBaseURL/profile";
  static const String kUpdateProfileURL = "$kBaseURL/";

  ///setting
  static const String kGetCitiesURL = "$kBaseURL/";
  static const String kGetCategoriesURL = "$kBaseURL/";
  static const String kContactUsRequestURL = "$kBaseURL/";
  static const String kGetFAGsURL = "$kBaseURL/";

  ///notifications
  static const String kGetNotificationsURI = '$kBaseURL/';

  ///offer
  static const String kGetOffersURI = '$kBaseURL/';
  static const String kGetOfferDetailsURI = '$kBaseURL/';

  static const String kLoginProviderURI = "$kBaseURL/service-provider/login";
  static const String kRegisterProviderURI = "$kBaseURL/service-provider/register";
  static const String kCheckOTPProviderURI = "$kBaseURL/service-provider/check-otp";
}
