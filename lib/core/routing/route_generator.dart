import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/routes.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/routing/route_generator.dart';
import 'package:weltweit/features/core/routing/route_generator_provider.dart';
import 'package:weltweit/features/screens/about/about_page.dart';
import 'package:weltweit/features/screens/chat/chat_screen.dart';
import 'package:weltweit/features/screens/contact/contact_page.dart';
import 'package:weltweit/features/screens/policy/policy_page.dart';
import 'package:weltweit/features/screens/splash/splash_screen.dart';
import 'package:weltweit/features/data/models/order/order.dart';

import '../../features/data/models/chat/chat_user.dart';
import '../../features/screens/wallet/wallet_page.dart';
import 'platform_page_route.dart';
import 'undefined_route_screen.dart';

class RouteGenerator {
  static Route generateBaseRoute(RouteSettings settings) {
    return getRout(settings);
    // default:return platformPageRoute(const UndefinedRouteScreen());
  }

  static Route getRout(RouteSettings settings) {
    log('RouteGenerator', settings.name ?? '');
    if ((settings.name ?? '').startsWith('/provider/')) {
      return RouteProviderGenerator.generateBaseRoute(settings);
    } else if ((settings.name ?? '').startsWith('/services')) {
      return RouteServicesGenerator.generateServicesBaseRoute(settings);
    } else if (settings.name == '/') {
      return platformPageRoute(Theme(data: servicesTheme, child: SplashScreen()));
    } else if (settings.name == Routes.chatScreen) {
      Map? arguments = settings.arguments as Map<String, dynamic>?;
      OrderModel orderModel = arguments!['orderModel'] as OrderModel;
      ChatUser chatUser = arguments!['chatUser'] as ChatUser;
      return platformPageRoute(Theme(data: servicesTheme, child:
      ChatScreen(orderModel: orderModel, isUser: arguments['isUser'], receiverData: chatUser,)));
    } else if (settings.name == Routes.about) {
      return platformPageRoute(const AboutPage());
    }else if (settings.name == Routes.userWalletPage) {
      return platformPageRoute(const UserWalletPage());
    } else if (settings.name == Routes.policy) {
      return platformPageRoute( PolicyPage());
    } else if (settings.name == Routes.contactUs) {
      return platformPageRoute(const ContactPage());
    } else {
      return platformPageRoute(UndefinedRouteScreen(settings.name));
    }
  }
}
