class AppURL {
  static const String kAPIKey = "";
  static const String kBaseURL =
      "http://superapp.weltweithg.com/api/service-provider/";

  ///Auth
  static const String loginURI = "login";
  static const String registerURI = "register";
  static const String logoutURI = "logout";

  static const String forgetPasswordURI = "otp";
  static const String kCheckOTPURI = "check-otp";
  static const String kResetPasswordURI = "";
  static const String kDeleteAccountURI = "";
  static const String kUpdateFCMTokenURI = "fcm_token";

  ///profile
  static const String profile = "profile";
  static const String changeStatus = "profile/change_status";
  static const String updateProfile = "profile/update";
  static const String deleteProfile = "profile/delete";
  static const String changePasswordProfile = "profile/change_password";

  //Services
  static const String services = "profile/get-services";
  static const String myServices = "profile/my-services";
  static const String updateMyServices = "profile/update-my-services";

  //Documents
  static const String getDocumentsURI = "profile/papers";
  static const String addDocumentURI = "profile/add-paper";
  static const String updateDocumentURI = "profile/update-paper";
  static const String deleteDocumentURI = "profile/delete-paper";

  //Portfolio
  static const String getPortfoliosURI = "portfolio-images";
  static const String addPortfolioURI = "portfolio-images/store";
  static const String updatePortfolioURI = "portfolio-images/update";
  static const String deletePortfolioURI = "portfolio-images/delete";

  //Settings
  static const String updateFcm = "profile/fcm_token";
  static const String updateLocation = "profile/update-location";
}
