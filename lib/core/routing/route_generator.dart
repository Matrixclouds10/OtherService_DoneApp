import 'package:flutter/material.dart';
import 'package:weltweit/core/utils/logger.dart';
import 'package:weltweit/features/services/core/routing/route_generator.dart';

import 'platform_page_route.dart';
import 'undefined_route_screen.dart';

class RouteGenerator {
  static Route generateBaseRoute(RouteSettings settings) {
    return getRout(settings);
    // default:return platformPageRoute(const UndefinedRouteScreen());
  }

  static Route getRout(RouteSettings settings) {
    log('RouteGenerator', settings.name ?? '');
    if ((settings.name ?? '').startsWith('/services')) {
      return RouteServicesGenerator.generateServicesBaseRoute(settings);
    } else {
      return platformPageRoute(const UndefinedRouteScreen());
    }
  }
}
