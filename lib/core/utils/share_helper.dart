// import 'dart:async';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// import 'package:share_plus/share_plus.dart';
// import 'package:weltweit/core/utils/constants.dart';

// import '../../domain/logger.dart';

// class DynamicLinkService {

//   static Future handleDynamicLinks(BuildContext context,) async {
//     //STARTUP FORM DYNAMIC LINK LOGIC
//     log('DynamicLinkService', 'check DynamicLinkService');

//     //Get initial dynamic link if the app is started using the link
//     final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

//     _handleDeepLink(data,context);
//     // INTO FOREGROUND FORM DYNAMIC LINK LOGIC
//     _initDynamicLinks(context);

//   }
//   static Future<void> _initDynamicLinks(BuildContext context) async {
//     FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
//       _handleDeepLink(dynamicLinkData,context);
//       // Navigator.pushNamed(context, dynamicLinkData.link.path);
//     }).onError((error) {
//       // Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.kTabsScreen, (route) => false);print(error.message);
//     });
//   }

//   static void _handleDeepLink(PendingDynamicLinkData? data, BuildContext context) {
//     final Uri? deepLink = data?.link;

//     if (deepLink != null) {
//       // final queryParams = deepLink.queryParameters;
//       final bool isProductDetailsPage = deepLink.path.contains('productDetails');

//       if (kDebugMode) { print('_handleDeepLink | deepLink: $deepLink'); }
//       if (isProductDetailsPage) {_handleProduct(deepLink, context); }
//     } else {
//       if (kDebugMode) { print('_handleDeepLink deepLink = null  | deepLink: $deepLink'); }
//       // Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.kTabsScreen, (route) => false);
//     }
//   }

//   static  _handleProduct(Uri deepLink, BuildContext context) {
//     // print('_handleDeepLink | open ID : ${RouteHelper.kProductDetailsPage} with queryParameters ${deepLink.queryParameters}');
//     // print('_handleDeepLink | open ID : ${RouteHelper.kProductDetailsPage} with id ${deepLink.queryParameters['id']}');
//     // int id = int.parse(deepLink.queryParameters['id']);
//     // if (id != null&& context !=null) {
//     //   try{
//     //     // Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.kSplashScreen, (route) => false);
//     //     // Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.kTabsScreen, (route) => false);
//     //     Navigator.of(context).pushNamed(RouteHelper.kProductDetailsPage, arguments: ProductDetailsScreenArguments(id: id, name: '',));
//     //   }catch(e){
//     //     print('_handleDeepLink Error $e');
//     //
//     //   }
//     //
//     // } else {
//     //   if(id ==null)  print('_handleDeepLink id == null');
//     //   if(context ==null)  print('_handleDeepLink context == null');
//     //   // Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.kTabsScreen, (route) => false);
//     // }
//   }

// }

// class DynamicLinksBuilder{

//   static Future<void> createDynamicLink({required num  id,required ShareType shareType ,bool short = false}) async {
//     FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
//     const String uriPrefix = "https://app.kixat.com";

//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//       link: Uri.parse("https://app.kixat.com/productDetails?id=$id"),
//       uriPrefix: "https://app.kixat.com",
//       // uriPrefix: uriPrefix,
//       // link: Uri.parse('$uriPrefix/productDetails?id=$productId'),
//       androidParameters: const AndroidParameters(
//         packageName: "com.softify.kixat",
//         minimumVersion: 0,
//       ),
//       iosParameters: const IOSParameters(
//         bundleId: "com.softify.kixat",
//         appStoreId: '1604233133',
//         minimumVersion: '1.2.5',
//         // fallbackUrl: Uri.parse('$uriPrefix/productDetails?id=$productId'),

//       ),

//     );

//     Uri? url;

//     try {
//       final ShortDynamicLink shortLink =
//       await dynamicLinks.buildShortLink(parameters);
//       url = shortLink.shortUrl;
//     } catch (e) {
//       try {
//         url = await dynamicLinks.buildLink(parameters);
//       } catch (e) {}
//     }

//      String desc = '${url?.toString()}';

//     await Share.share(desc, subject: 'Product',);
//   }
// }
