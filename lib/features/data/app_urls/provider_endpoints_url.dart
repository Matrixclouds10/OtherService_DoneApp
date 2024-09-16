class AppURLProvider {
  static const String kAPIKey = "";
   static const String kBaseURL = "https://dev05.matrix-clouds.com/Done/public/api/service-provider";
   static const String kBaseURLApi = "https://dev05.matrix-clouds.com/Done/public/api";
  // static const String kBaseURL = "https://doneapp.org/api/service-provider";
  // static const String kBaseURLApi = "https://doneapp.org/api";

  ///Auth
  static const String loginURI = "$kBaseURL/login";
  static const String registerURI = "$kBaseURL/register";
  static const String logoutURI = "$kBaseURL/logout";

  static const String forgetPasswordURI = "$kBaseURL/otp";
  static const String kCheckOTPURI = "$kBaseURL/check-otp";
  static const String kResetPasswordURI = "";
  static const String kDeleteAccountURI = "";
  static const String kUpdateFCMTokenURI = "$kBaseURL/fcm_token";

  ///profile
  static const String profile = "$kBaseURL/profile";
  static const String changeStatus = "$kBaseURL/profile/change_status";
  static const String updateProfile = "$kBaseURL/profile/update";
  static const String deleteProfile = "$kBaseURL/profile/delete";
  static const String changePasswordProfile = "$kBaseURL/profile/change_password";

  //Services
  static const String services = "$kBaseURL/profile/get-services";
  static const String myServices = "$kBaseURL/profile/my-services";
  static const String updateMyServices = "$kBaseURL/profile/update-my-services";

  //Documents
  static const String getDocumentsURI = "$kBaseURL/profile/papers";
  static const String addDocumentURI = "$kBaseURL/profile/add-paper";
  static const String updateDocumentURI = "$kBaseURL/profile/update-paper";
  static const String deleteDocumentURI = "$kBaseURL/profile/delete-paper";
  static const String getDocumentsInfoURI = "$kBaseURLApi/get-hiring-documents";

  //Portfolio
  static const String getPortfoliosURI = "$kBaseURL/portfolio-images";
  static const String addPortfolioURI = "$kBaseURL/portfolio-images/store";
  static const String updatePortfolioURI = "$kBaseURL/portfolio-images/update";
  static const String deletePortfolioURI = "$kBaseURL/portfolio-images/delete";

  //Settings
  static const String updateFcm = "$kBaseURL/fcm_token";
  static const String updateLocation = "$kBaseURL/profile/update-location";
  static const String getSubscriptionPackages = "$kBaseURL/get-subscriptions";
  static const String getSubscriptionHistory = "$kBaseURL/subscription-history";
  static const String subscribe = "$kBaseURL/update-subscription";
  static const String rePaySubscribe = "$kBaseURL/repay-subscription";

  //*Wallet
  static const String getWalletHistory = "$kBaseURL/wallet/history";
  static const String convertPoints = "$kBaseURL/changePoints";

//*Notifications
  static const String getNotifications = "$kBaseURL/get-notifications";
}
