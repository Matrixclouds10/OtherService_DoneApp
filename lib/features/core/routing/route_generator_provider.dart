import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weltweit/core/routing/navigation_services.dart';
import 'package:weltweit/core/routing/platform_page_route.dart';
import 'package:weltweit/core/routing/undefined_route_screen.dart';
import 'package:weltweit/features/provider/logic/profile/profile_cubit.dart';
import 'package:weltweit/features/provider/presentation/modules/docs/document_page.dart';
import 'package:weltweit/features/provider/presentation/modules/layout/layout_page.dart';
import 'package:weltweit/features/provider/presentation/modules/my_addresses/my_addresses_page.dart';
import 'package:weltweit/features/provider/presentation/modules/notifications/notification_page.dart';
import 'package:weltweit/features/provider/presentation/modules/offers/offers_page.dart';
import 'package:weltweit/features/provider/presentation/modules/order_details/order_details.dart';
import 'package:weltweit/features/provider/presentation/modules/orders/orders_page.dart';
import 'package:weltweit/features/provider/presentation/modules/profile/profile_update_page.dart';
import 'package:weltweit/features/provider/presentation/modules/reservation/reservation_page.dart';
import 'package:weltweit/features/provider/presentation/modules/search/search_page.dart';
import 'package:weltweit/features/provider/presentation/modules/service_provider/service_provider_page.dart';
import 'package:weltweit/features/provider/presentation/modules/service_providers/service_providers_page.dart';
import 'package:weltweit/features/provider/presentation/modules/services/services_page.dart';
import 'package:weltweit/features/provider/presentation/modules/subscribe/subscribe.dart';
import 'package:weltweit/features/screens/about/about_page.dart';
import 'package:weltweit/features/screens/contact/contact_page.dart';

import 'routes_provider.dart';

class RouteProviderGenerator {
  static Route generateBaseRoute(RouteSettings settings) {
    Map? arguments = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case RoutesProvider.providerLayoutScreen:
        NavigationService.navigationKey.currentContext!.read<ProfileProviderCubit>().getProfile();
        return platformPageRoute(const LayoutPage(currentPage: 0));
      case RoutesProvider.providerOffers:
        return platformPageRoute(const OffersPage());
      case RoutesProvider.providerServices:
        return platformPageRoute(const ServicesPage());
      case RoutesProvider.providerNotifications:
        return platformPageRoute(const NotificationPage());
      case RoutesProvider.providerMyAddresses:
        return platformPageRoute(const MyAddressesPage());
      case RoutesProvider.providerOrders:
        return platformPageRoute(const OrdersPage());
      case RoutesProvider.providerAboutUs:
        return platformPageRoute(const AboutPage());
      case RoutesProvider.providerReservationPage:
        return platformPageRoute(const ReservationPage());
      case RoutesProvider.providerContactUs:
        return platformPageRoute(const ContactPage());
      case RoutesProvider.providerSearch:
        return platformPageRoute(const SearchPage());
      case RoutesProvider.providerDocuments:
        return platformPageRoute(const DocumentPage());
      case RoutesProvider.providerOrderDetails:
        return platformPageRoute(OrderDetails(orderStatus: arguments!["orderStatus"]));
      case RoutesProvider.providerProviders:
        return platformPageRoute(ServiceProvidersPage(service: arguments!["serviceName"]));
      case RoutesProvider.providerProvider:
        return platformPageRoute(ServiceProviderPage(provderName: arguments!["provderName"]));
      case RoutesProvider.providerSubscribe:
        return platformPageRoute(SubscribePage());
      case RoutesProvider.providerProfileUpdateScreen:
        return platformPageRoute(ProfileUpdatePage());
      default:
        return platformPageRoute( UndefinedRouteScreen(settings.name));
      // default:return platformPageRoute(const UndefinedRouteScreen());
    }
  }
}