import 'package:weltweit/data/app_urls/domain.dart';

class AppURLProvider {
  static const String kAPIKey = "";
   static const String kBaseProviderURL = "$kBaseURL/service-provider";
   static const String kBaseURLApi =kBaseURL;
  // static const String kBaseURL = "https://propertiesapk.net/api/service-provider";
  // static const String kBaseURLApi = "https://propertiesapk.net/api";

  ///Auth
  static const String loginURI = "$kBaseProviderURL/login";
  static const String registerURI = "$kBaseProviderURL/register";
  static const String logoutURI = "$kBaseProviderURL/logout";

  static const String forgetPasswordURI = "$kBaseProviderURL/otp";
  static const String kCheckOTPURI = "$kBaseProviderURL/check-otp";
  static const String kResetPasswordURI = "";
  static const String kDeleteAccountURI = "";
  static const String kUpdateFCMTokenURI = "$kBaseProviderURL/fcm_token";

  ///profile
  static const String profile = "$kBaseProviderURL/profile";
  static const String changeStatus = "$kBaseProviderURL/profile/change_status";
  static const String updateProfile = "$kBaseProviderURL/profile/update";
  static const String deleteProfile = "$kBaseProviderURL/profile/delete";
  static const String changePasswordProfile = "$kBaseProviderURL/profile/change_password";

  //Services
  static const String services = "$kBaseProviderURL/profile/get-services";
  static const String myServices = "$kBaseProviderURL/profile/my-services";
  static const String updateMyServices = "$kBaseProviderURL/profile/update-my-services";

  //Documents
  static const String getDocumentsURI = "$kBaseProviderURL/profile/papers";
  static const String addDocumentURI = "$kBaseProviderURL/profile/add-paper";
  static const String updateDocumentURI = "$kBaseProviderURL/profile/update-paper";
  static const String deleteDocumentURI = "$kBaseProviderURL/profile/delete-paper";
  static const String getDocumentsInfoURI = "$kBaseURLApi/get-hiring-documents";

  //Portfolio
  static const String getPortfoliosURI = "$kBaseProviderURL/portfolio-images";
  static const String addPortfolioURI = "$kBaseProviderURL/portfolio-images/store";
  static const String updatePortfolioURI = "$kBaseProviderURL/portfolio-images/update";
  static const String deletePortfolioURI = "$kBaseProviderURL/portfolio-images/delete";

  //Settings
  static const String updateFcm = "$kBaseProviderURL/fcm_token";
  static const String updateLocation = "$kBaseProviderURL/profile/update-location";
  static const String getSubscriptionPackages = "$kBaseProviderURL/get-subscriptions";
  static const String getSubscriptionHistory = "$kBaseProviderURL/subscription-history";
  static const String subscribe = "$kBaseProviderURL/update-subscription";
  static const String rePaySubscribe = "$kBaseProviderURL/repay-subscription";

  //*Wallet
  static const String getWalletHistory = "$kBaseProviderURL/wallet/history";

//*Notifications
  static const String getNotifications = "$kBaseProviderURL/get-notifications";
}
