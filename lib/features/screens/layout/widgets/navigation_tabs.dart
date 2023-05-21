import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/tabs/tab.dart';
import 'package:weltweit/features/screens/favorite/favorite_page.dart';
import 'package:weltweit/features/screens/home/home_page.dart';
import 'package:weltweit/features/screens/orders/orders_page.dart';

import 'package:weltweit/features/screens/profile/profile_page.dart';
import 'package:weltweit/features/screens/wallet/wallet_page.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class NavigationTabs {
  NavigationTabs._();

  static const home = 0;
  static const favorite = 1;
  static const search = 2;
  static const orders = 3;
  static const profile = 4;
}

List<NavigationTab> kTabs = <NavigationTab>[
  const NavigationTab(
    name: LocaleKeys.home,
    image: Assets.svgMoreNotificationIcon,
    unSelectIcon: CupertinoIcons.house_fill,
    selectIcon: CupertinoIcons.house,
    initialRoute: HomePage(),
    index: NavigationTabs.home,
  ),
  const NavigationTab(
    name: LocaleKeys.favorite,
    image: '',
    selectIcon: CupertinoIcons.heart,
    unSelectIcon: CupertinoIcons.heart_fill,
    initialRoute: FavoritePage(),
    index: NavigationTabs.favorite,
  ),
  const NavigationTab(
    name: LocaleKeys.searchHint,
    image: '',
    selectIcon: CupertinoIcons.search,
    unSelectIcon: CupertinoIcons.search,
    initialRoute: FavoritePage(),
    index: NavigationTabs.search,
  ),
  const NavigationTab(
    name: LocaleKeys.orders,
    image: '',
    unSelectIcon: Icons.list,
    selectIcon: Icons.list_alt_outlined,
    initialRoute: OrdersPage(canGoBack: false),
    index: NavigationTabs.orders,
  ),
  const NavigationTab(
    name: LocaleKeys.profile,
    image: '',
    selectIcon: Icons.person,
    unSelectIcon: Icons.person_outline_rounded,
    initialRoute: ProfilePage(),
    index: NavigationTabs.profile,
  ),
];
