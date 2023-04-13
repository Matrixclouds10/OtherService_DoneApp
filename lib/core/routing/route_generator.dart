import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/core/routing/route_generator.dart';
import 'package:weltweit/features/core/routing/route_generator_provider.dart';
import 'package:weltweit/features/screens/splash/splash_screen.dart';

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
    } else {
      return platformPageRoute(UndefinedRouteScreen(settings.name));
    }
  }
}
