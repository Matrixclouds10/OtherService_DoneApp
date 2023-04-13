import 'package:flutter/material.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/routing/platform_page_route.dart';
import 'package:weltweit/core/routing/undefined_route_screen.dart';
import 'package:weltweit/features/core/routing/routes.dart';
import 'package:weltweit/features/screens/about/about_page.dart';
import 'package:weltweit/features/screens/auth/client_type/user_type.dart';
import 'package:weltweit/features/screens/auth/login/login_screen.dart';
import 'package:weltweit/features/screens/auth/otp/otp_screen.dart';
import 'package:weltweit/features/screens/auth/register/register_screen.dart';
import 'package:weltweit/features/screens/contact/contact_page.dart';
import 'package:weltweit/features/services/modules/layout/layout_page.dart';
import 'package:weltweit/features/services/modules/my_addresses/my_addresses_page.dart';
import 'package:weltweit/features/services/modules/notifications/notification_page.dart';
import 'package:weltweit/features/services/modules/offers/offers_page.dart';
import 'package:weltweit/features/screens/on_boarding/on_boarding_screen.dart';
import 'package:weltweit/features/services/modules/order_details/order_details.dart';
import 'package:weltweit/features/services/modules/orders/orders_page.dart';
import 'package:weltweit/features/screens/profile/profile_update_page.dart';
import 'package:weltweit/features/services/modules/reservation/reservation_page.dart';
import 'package:weltweit/features/services/modules/search/search_page.dart';
import 'package:weltweit/features/services/modules/service_provider/service_provider_page.dart';
import 'package:weltweit/features/services/modules/service_providers/service_providers_page.dart';
import 'package:weltweit/features/services/modules/services/services_page.dart';
import 'package:weltweit/features/screens/splash/splash_screen.dart';
import 'package:weltweit/features/screens/welcome/welcome_screen.dart';

class RouteServicesGenerator {
  static Route generateServicesBaseRoute(RouteSettings settings) {
    Map? arguments = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case RoutesServices.servicesLayoutScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: const LayoutPage(currentPage: 0)));
      case RoutesServices.servicesOffers:
        return platformPageRoute(Theme(data: servicesTheme, child: const OffersPage()));
      case RoutesServices.servicesServices:
        return platformPageRoute(Theme(data: servicesTheme, child: const ServicesPage()));
      case RoutesServices.servicesNotifications:
        return platformPageRoute(Theme(data: servicesTheme, child: const NotificationPage()));
      case RoutesServices.servicesMyAddresses:
        return platformPageRoute(Theme(data: servicesTheme, child: const MyAddressesPage()));
      case RoutesServices.servicesOrders:
        return platformPageRoute(Theme(data: servicesTheme, child: const OrdersPage()));
      case RoutesServices.servicesAboutUs:
        return platformPageRoute(Theme(data: servicesTheme, child: const AboutPage()));
      case RoutesServices.servicesReservationPage:
        return platformPageRoute(Theme(data: servicesTheme, child: ReservationPage(providersModel: arguments!['providersModel'])));
      case RoutesServices.servicesContactUs:
        return platformPageRoute(Theme(data: servicesTheme, child: const ContactPage()));
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
            phone: arguments?['phone'],
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
        return platformPageRoute(Theme(data: servicesTheme, child: UserTypeScreen()));

      case RoutesServices.servicesOnBoardingScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: OnBoardingScreen()));

      case RoutesServices.servicesLoginScreen:
        return platformPageRoute(Theme(data: servicesTheme, child: LoginScreen()));

      default:
        return platformPageRoute(Theme(data: servicesTheme, child: const UndefinedRouteScreen()));
    }
  }
}
