// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:weltweit/base_injection.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/platform_page_route.dart';
import 'package:weltweit/core/routing/undefined_route_screen.dart';
import 'package:weltweit/core/services/local/cache_consumer.dart';
import 'package:weltweit/core/services/local/storage_keys.dart';
import 'package:weltweit/features/core/routing/routes_user.dart';
import 'package:weltweit/features/screens/auth/login/login_screen.dart';
import 'package:weltweit/features/screens/auth/otp/otp_screen.dart';
import 'package:weltweit/features/screens/auth/register/register_screen.dart';
import 'package:weltweit/features/screens/auth/user_type/user_type.dart';
import 'package:weltweit/features/screens/layout/layout_page.dart';
import 'package:weltweit/features/screens/layout_guest/layout_page_guest.dart';
import 'package:weltweit/features/screens/my_addresses/my_addresses_page.dart';
import 'package:weltweit/features/screens/notifications/notification_page.dart';
import 'package:weltweit/features/screens/offers/offers_page.dart';
import 'package:weltweit/features/screens/on_boarding/on_boarding_screen.dart';
import 'package:weltweit/features/screens/order_details/order_details.dart';
import 'package:weltweit/features/screens/orders/orders_page.dart';
import 'package:weltweit/features/screens/profile/profile_update_page.dart';
import 'package:weltweit/features/screens/reservation/reservation_page.dart';
import 'package:weltweit/features/screens/search/search_page.dart';
import 'package:weltweit/features/screens/service_provider/service_provider_page.dart';
import 'package:weltweit/features/screens/service_providers/service_providers_page.dart';
import 'package:weltweit/features/screens/services/services_page.dart';
import 'package:weltweit/features/screens/splash/splash_screen.dart';
import 'package:weltweit/features/screens/welcome/welcome_screen.dart';

class RouteServicesGenerator {
  static Route generateServicesBaseRoute(RouteSettings settings) {
    Map? arguments = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case RoutesServices.servicesLayoutScreen:
        return platformPageRoute(Theme(data: servicesTheme, child:  LayoutPage(currentPage: arguments!['currentPage']??0)));
      case RoutesServices.servicesLayoutScreenGuest:
        return platformPageRoute(Theme(data: servicesTheme, child: const LayoutPageGuest(currentPage: 0)));
      case RoutesServices.servicesOffers:
        return platformPageRoute(Theme(data: servicesTheme, child: const OffersPage()));
      case RoutesServices.servicesServices:
        return platformPageRoute(Theme(data: servicesTheme, child: const ServicesPage()));
      case RoutesServices.servicesNotifications:
        return platformPageRoute(Theme(data: servicesTheme, child: const NotificationPage()));
      case RoutesServices.servicesMyAddresses:
        return platformPageRoute(Theme(data: servicesTheme, child: const MyAddressesPage()));
      case RoutesServices.servicesOrders:
        return platformPageRoute(Theme(data: servicesTheme, child: const OrdersPage(canGoBack: true)));
      case RoutesServices.servicesReservationPage:
        return platformPageRoute(Theme(data: servicesTheme, child: ReservationPage(providersModel: arguments!['providersModel'])));
      case RoutesServices.servicesSearch:
        return platformPageRoute(Theme(data: servicesTheme, child: const SearchPage()));
      case RoutesServices.servicesOrderDetails:
        if (arguments!["orderModel"] == null) throw Exception("orderModel is null");
        return platformPageRoute(Theme(
          data: servicesTheme,
          child: OrderDetails(orderModel: arguments["orderModel"]),
        ));
      case RoutesServices.servicesProfileEdit:
        return platformPageRoute(Theme(data: servicesTheme, child: const ProfileUpdatePage()));
      case RoutesServices.servicesProviders:
        return platformPageRoute(Theme(data: servicesTheme, child: ServiceProvidersPage(service: arguments!["service"])));
      case RoutesServices.servicesProvider:
        return platformPageRoute(Theme(data: servicesTheme, child: ServiceProviderPage(provider: arguments!["provider"])));
      case RoutesServices.servicesSplashScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: SplashScreen()));
      case RoutesServices.servicesOtpScreen:
        return platformPageRoute(Theme(
          data: servicesTheme,
          child: OTPScreen(
            email: arguments?['email'],
            code: arguments?['code'],
            checkOTPType: arguments?['checkOTPType'],
            typeIsProvider: arguments?['typeIsProvider'],
          ),
        ));

      case RoutesServices.servicesRegisterScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: RegisterScreen(typeIsProvider: arguments?['typeIsProvider'])));

      case RoutesServices.servicesWelcomeScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: WelcomeScreen()));

      case RoutesServices.servicesUserTypeScreen:
        {
          AppPrefs prefs = getIt();
          bool showForIos = prefs.get(PrefKeys.iosStatus, defaultValue: true);
          if (!Platform.isIOS) showForIos = true;
          if (showForIos)
            return platformPageRoute(Theme(data: servicesTheme, child: UserTypeScreen()));
          else
            return platformPageRoute(Theme(data: servicesTheme, child: RegisterScreen(typeIsProvider: false)));
        }

      case RoutesServices.servicesOnBoardingScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: OnBoardingScreen()));

      case RoutesServices.servicesLoginScreen:
        return platformPageRoute(Theme(
            data: servicesTheme,
            child: LoginScreen(
              typeIsProvider: arguments?['typeIsProvider'],
            )));

      default:
        return platformPageRoute(Theme(data: servicesTheme, child: UndefinedRouteScreen(settings.name)));
    }
  }
}
