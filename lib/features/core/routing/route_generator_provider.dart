import 'package:flutter/material.dart';
import 'package:weltweit/core/routing/platform_page_route.dart';
import 'package:weltweit/core/routing/undefined_route_screen.dart';
import 'package:weltweit/features/screens/provider_docs/document_page.dart';
import 'package:weltweit/features/screens/provider_docs/hiring_document_page.dart';
import 'package:weltweit/features/screens/provider_layout/layout_page.dart';
import 'package:weltweit/features/screens/provider_my_addresses/my_addresses_page.dart';
import 'package:weltweit/features/screens/provider_notifications/notification_page.dart';
import 'package:weltweit/features/screens/provider_offers/offers_page.dart';
import 'package:weltweit/features/screens/provider_order_details/order_details.dart';
import 'package:weltweit/features/screens/provider_orders/orders_page.dart';
import 'package:weltweit/features/screens/provider_profile/profile_update_page.dart';
import 'package:weltweit/features/screens/provider_reservation/reservation_page.dart';
import 'package:weltweit/features/screens/provider_service_providers/service_providers_page.dart';
import 'package:weltweit/features/screens/provider_services/services_page.dart';
import 'package:weltweit/features/screens/provider_subscribe/payment_webview.dart';
import 'package:weltweit/features/screens/provider_subscribe/subscribe_page.dart';

import 'routes_provider.dart';

class RouteProviderGenerator {
  static Route generateBaseRoute(RouteSettings settings) {
    Map? arguments = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case RoutesProvider.providerLayoutScreen:
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

      case RoutesProvider.providerReservationPage:
        return platformPageRoute(const ReservationPage());
      case RoutesProvider.providerDocuments:
        return platformPageRoute(const DocumentPage());
      case RoutesProvider.providerHiringDocuments:
        return platformPageRoute(const HiringDocumentPage());
      case RoutesProvider.providerOrderDetails:
        return platformPageRoute(OrderDetails(orderModel: arguments!["order"]));
      case RoutesProvider.providerProviders:
        return platformPageRoute(ServiceProvidersPage(service: arguments!["serviceName"]));
      case RoutesProvider.paymentWebview:
        return platformPageRoute(PaymentWebview(packageId: arguments!['id'], url: arguments['url']));
      case RoutesProvider.providerSubscribe:
        return platformPageRoute(SubscribePage());
      case RoutesProvider.providerProfileUpdateScreen:
        return platformPageRoute(ProfileUpdatePage());
      default:
        return platformPageRoute(UndefinedRouteScreen(settings.name));
      // default:return platformPageRoute(const UndefinedRouteScreen());
    }
  }
}
