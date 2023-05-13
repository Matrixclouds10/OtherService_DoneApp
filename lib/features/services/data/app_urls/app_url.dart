class AppURL {
  static const String kAPIKey = "";
  static const String kBaseURL = "http://don.dev01.matrix-clouds.com/api";
  // static const String kBaseURL = "$kBaseURL/https://super-app.dev01.matrix-clouds.com/api/";

  //Profile
  static const String kProfileCreateUrl = "$kBaseURL/profile";
  static const String kProfileUpdateUrl = "$kBaseURL/profile";
  static const String kProfileReadUrl = "$kBaseURL/profile";
  static const String kProfileDeleteUrl = "$kBaseURL/profile";

  //Address
  static const String addressCreateUrl = "$kBaseURL/address/store";
  static const String addressUpdateUrl = "$kBaseURL/address/update";
  static const String addressReadUrl = "$kBaseURL/address";
  static const String addressSetDefaultUrl = "$kBaseURL/address/set-default";
  static const String addressDeleteUrl = "$kBaseURL/address/delete";


  ///profile
  static const String profile = "$kBaseURL/profile";
  static const String changeStatus = "$kBaseURL/profile/change_status";
  static const String updateProfile = "$kBaseURL/profile/update";
  static const String deleteProfile = "$kBaseURL/profile/delete";
  static const String changePasswordProfile = "$kBaseURL/profile/change_password";

  static const String profileProvider = "$kBaseURL/service-provider/profile";
  static const String changeStatusProvider = "$kBaseURL/service-provider/profile/change_status";
  static const String updateProfileProvider = "$kBaseURL/service-provider/profile/update";
  static const String deleteProfileProvider = "$kBaseURL/service-provider/profile/delete";
  static const String changePasswordProfileProvider = "$kBaseURL/service-provider/profile/change_password";
  static const String updateFcmProvider = "$kBaseURL/service-provider/fcm_token";

  //Services
  static const String services = "$kBaseURL/services/all-services";
  static const String updateMyServices = "$kBaseURL/profile/update-my-services";

  //Documents
  static const String getDocumentsURI = "$kBaseURL/profile/papers";
  static const String addDocumentURI = "$kBaseURL/profile/add-paper";
  static const String updateDocumentURI = "$kBaseURL/profile/update-paper";
  static const String deleteDocumentURI = "$kBaseURL/profile/delete-paper";

  //Portfolio
  static const String getPortfoliosURI = "$kBaseURL/portfolio-images";
  static const String addPortfolioURI = "$kBaseURL/portfolio-images/store";
  static const String updatePortfolioURI = "$kBaseURL/portfolio-images/update";
  static const String deletePortfolioURI = "$kBaseURL/portfolio-images/delete";

  //Settings
  static const String updateFcm = "$kBaseURL/profile/fcm_token";
  static const String updateLocation = "$kBaseURL/profile/update-location";

  //provider
  static const String getMostRequestedProviders = "$kBaseURL/most-requested-providers";
  static const String getProviders = "$kBaseURL/services/get-providers";
  static const String getProvider = "$kBaseURL/services/get-provider";
  static const String getProviderPortfolio = "$kBaseURL/services/get-provider-portfolio";
  static const String getProviderServices = "$kBaseURL/services/get-provider-serviceso";

  //Favorite
  static const String getFavorites = "$kBaseURL/fav_providers/fav_providers_list";
  static const String addFavorite = "$kBaseURL/fav_providers/new_fav_provider";

  //Order
  static const String createOrder = "$kBaseURL/appointment/store";
  static const String getPendingOrders = "$kBaseURL/appointment/get/pending";
  static const String getCompletedOrders = "$kBaseURL/appointment/get/completed";
  static const String getCancelledOrders = "$kBaseURL/appointment/get/cancelled";

  static const String providerGetPendingOrders = "$kBaseURL/service-provider/appointment/get/pending";
  static const String providerGetCompletedOrders = "$kBaseURL/service-provider/appointment/get/completed";
  static const String providerGetCancelledOrders = "$kBaseURL/service-provider/appointment/get/cancelled";
  static const String cancelOrder = "$kBaseURL/appointment/cancel";
  static const String getOrder = "$kBaseURL/appointment/get-single";

  //Chat
  static const String getChatMessages = "$kBaseURL/appointment/chat";
  static const String sendMessage = "$kBaseURL/appointment/chat/send-message";

  //Basic
  static const String about = "$kBaseURL/about-us";
  static const String terms = "$kBaseURL/terms";
  static const String privacy = "$kBaseURL/privacy";
  static const String contactUs = "$kBaseURL/send-contact-message";
  static const String countries = "$kBaseURL/get-countries";
  static const String country = "$kBaseURL/get-country";
  static const String banners = "$kBaseURL/get-banners";
}
