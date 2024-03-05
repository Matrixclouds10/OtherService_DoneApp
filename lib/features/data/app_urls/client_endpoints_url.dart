class AppURL {
  static const String kAPIKey = "";
  // static const String kBaseURL = "https://doneapp.org/api";
   static const String kBaseURL = "https://doneapp.org/api";
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
  static const String deleteProfile = "$kBaseURL/delete-account";
  static const String deleteProfileProvider = "$kBaseURL/service-provider/delete-account";
  static const String changePasswordProfile = "$kBaseURL/profile/change_password";

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
  static const String updateFcm = "$kBaseURL/fcm_token";
  static const String updateLocation = "$kBaseURL/profile/update-location";

  //provider
  static const String getMostRequestedProviders = "$kBaseURL/most-requested-providers";
  static const String getProviders = "$kBaseURL/services/get-providers";
  static const String getProvider = "$kBaseURL/services/get-provider";
  static const String getProviderPortfolio = "$kBaseURL/services/get-provider-portfolio";
  static const String getProviderServices = "$kBaseURL/services/get-provider-serviceso";
  static const String getProviderRates = "$kBaseURL/services/get-provider-rates";

  //Favorite
  static const String getFavorites = "$kBaseURL/fav_providers/fav_providers_list";
  static const String addFavorite = "$kBaseURL/fav_providers/new_fav_provider";

  //Order
  static const String createOrder = "$kBaseURL/appointment/store";
  static const String getPendingOrders = "$kBaseURL/appointment/get/pending";
  static const String getCompletedOrders = "$kBaseURL/appointment/get/completed";
  static const String getCancelledOrders = "$kBaseURL/appointment/get/cancelled";
  static const String orderDone = "$kBaseURL/appointment/done";
  static const String orderRate = "$kBaseURL/appointment/rate";

  static const String providerOrderFinish = "$kBaseURL/service-provider/appointment/finish";
  static const String providerGetPendingOrders = "$kBaseURL/service-provider/appointment/get/pending";
  static const String providerGetCompletedOrders = "$kBaseURL/service-provider/appointment/get/completed";
  static const String providerGetCancelledOrders = "$kBaseURL/service-provider/appointment/get/cancelled";
  static const String providerGetOrder = "$kBaseURL/service-provider/appointment/get-single";
  static const String providerCancelOrder = "$kBaseURL/service-provider/appointment/cancel";
  static const String cancelOrder = "$kBaseURL/appointment/cancel";
  static const String getOrder = "$kBaseURL/appointment/get-single";
  static const String providerAcceptOrder = "$kBaseURL/service-provider/appointment/accept";

  //Chat
  static const String getChatMessagesClient = "$kBaseURL/appointment/chat";
  static const String getChatMessagesProvider = "$kBaseURL/service-provider/appointment/chat";
  static const String sendMessageClient = "$kBaseURL/appointment/chat/send-message";
  static const String sendMessageProvider = "$kBaseURL/service-provider/appointment/chat/send-message";

  //Basic
  static const String about = "$kBaseURL/about-us";
  static const String terms = "$kBaseURL/terms";
  static const String privacy = "$kBaseURL/privacy";
  static const String contactUs = "$kBaseURL/send-contact-message";
  static const String cities = "$kBaseURL/get-cities";
  static const String regions = "$kBaseURL/get-regions";
  static const String countries = "$kBaseURL/get-countries";
  static const String country = "$kBaseURL/get-country";
  static const String banners = "$kBaseURL/get-banners";

  //Notification
  static const String getNotifications = "$kBaseURL/get-notifications";
}
