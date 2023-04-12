import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'logger.dart';
import 'alerts.dart';

class ContactHelper {
  static void launchMap({num? lat = 47.6, num? long = -122.3}) async {
    var uri = Uri.parse("google.navigation:q=$lat,$long&mode=d");
    Uri appleUrl = Uri.parse('https://maps.apple.com/?sll=$lat,$long');
    Uri googleUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$long');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (await canLaunchUrl(appleUrl)) {
      await launchUrl(appleUrl);
    } else if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl);
      // if (await canLaunchUrl(uri)) {
    } else {
      throw 'Could not launch ${uri.toString()}';
    }
  }

  static launchURL(String toMailId) async {
    var url = 'mailto:$toMailId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static launchCall(String phone) async {
    // launch('tel:+91 88888888888');
    log('ContactHelper', 'launchCall');
    var url = "tel://$phone";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static launchSMS(String phone) async {
    log('ContactHelper', 'launchSMS');
    //launch('sms:+91888888888?body=Hi Welcome to Proto Coders Point');
    var url = 'sms:$phone';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static openWhatsApp1(BuildContext context, String whatApp) async {
    log('ContactHelper', 'openWhatsApp');
    var whatsappURlAndroid = "whatsapp://send?phone=$whatApp&text=hello";
    var whatAppURLIos = "https://wa.me/$whatApp?text=${Uri.parse("hello")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatAppURLIos))) {
        await launchUrl(Uri.parse(whatAppURLIos));
      } else {
        Alerts.showSnackBar("whatsapp no installed");
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse((whatsappURlAndroid)));
      } else {
        Alerts.showSnackBar("whatsapp no installed");
      }
    }
  }

  static openWhatsApp(BuildContext context, String whatApp) async {
    String whatsAppUrl = "";
    log('ContactHelper', 'openWhatsApp');
    String description = "";

    if (Platform.isIOS) {
      whatsAppUrl = 'whatsapp://wa.me/$whatApp/?text=${Uri.parse(description)}';
    } else {
      whatsAppUrl = 'https://wa.me/+$whatApp?text=${Uri.parse(description)}';
    }

    if (await canLaunchUrl(Uri.parse(whatsAppUrl))) {
      await launchUrl(Uri.parse((whatsAppUrl)));
    } else {
      Alerts.showSnackBar("Install WhatsApp First Please");
    }
  }
}
