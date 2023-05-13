import 'package:flutter/foundation.dart';

import '../../data/app_urls/app_url.dart';

class Constants {
  static const String empty = "";
  static const int connectTimeout = kDebugMode ? 10000 : 120000;

  static const String kGoogleMapKey = 'AIzaSyDni6NI_DWPFL2snl8Dqnn2K5fqXpNbC4w';
  // static const String  kGoogleMapKey= 'AIzaSyDNSpdaE88kKP67ne51BWtpyQsdZJIeV5E';
  // static const String  kGoogleMapKey= 'AIzaSyBvjoIOOX8uJteEXBRDoYmt_lK2a4tpwok';

  static const String kTerms = '${AppURL.kBaseURL}setting/setting-view/terms';
  static const String kAboutUs =
      '${AppURL.kBaseURL}setting/setting-view/about_us';
  static const String kPayment =
      '${AppURL.kBaseURL}orders/payment?order_id=6&payment_type=cash';

  static String getPaymentMethodLink(
          {required int requestId, required String type}) =>
      '${AppURL.kBaseURL}orders/payment?order_id=$requestId&payment_type=$type';
}

double convertToDouble(var d) => d / 1;

String convertListToString(List<String?> list) => list.join(',');

enum ShareType { event, group }

enum ChatOptions { report, block }

enum EventOptions { report, addToFavourites, cancelAttendance }

enum GroupOptions { report, leaving }
