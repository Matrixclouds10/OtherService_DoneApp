class AppURL {
  static const String kAPIKey = "";
  static const String kBaseURL = "http://superapp.weltweithg.com/api/";
  // static const String kBaseURL = "https://super-app.dev01.matrix-clouds.com/api/";

  //Profile
  static const String kProfileCreateUrl = "profile";
  static const String kProfileUpdateUrl = "profile";
  static const String kProfileReadUrl = "profile";
  static const String kProfileDeleteUrl = "profile";

  //Address
  static const String addressCreateUrl = "address/store";
  static const String addressUpdateUrl = "address/update";
  static const String addressReadUrl = "address";
  static const String addressDeleteUrl = "address/delete";


  ///profile
  static const String profile = "profile";
  static const String changeStatus = "profile/change_status";
  static const String updateProfile = "profile/update";
  static const String deleteProfile = "profile/delete";
  static const String changePasswordProfile = "profile/change_password";

  //Services
  static const String services = "services/all-services";
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

  //provider
  static const String getProviders = "services/get-providers";
  static const String getProvider = "services/get-provider";
  static const String getProviderPortfolio = "services/get-provider-portfolio";
  static const String getProviderServices = "services/get-provider-serviceso";

  //Favorite
  static const String getFavorites = "fav_providers/fav_providers_list";
  static const String addFavorite = "fav_providers/new_fav_provider";

  //Order
  static const String createOrder = "services/appointment/store";
  static const String getOrders = "services/appointment/get/pending";
  static const String getOrder = "services/appointment/get-single";
}
