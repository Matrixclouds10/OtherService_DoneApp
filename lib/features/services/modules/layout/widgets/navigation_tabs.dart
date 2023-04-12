import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weltweit/core/tabs/tab.dart';
import 'package:weltweit/features/services/modules/favorite/favorite_page.dart';
import 'package:weltweit/features/services/modules/home/home_page.dart';

import 'package:weltweit/features/services/modules/profile/profile_page.dart';
import 'package:weltweit/features/services/modules/wallet/wallet_page.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

class NavigationTabs {
  NavigationTabs._();

  static const home = 0;
  static const favorite = 1;
  static const search = 2;
  static const wallet = 3;
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
    name: LocaleKeys.wallet,
    image: '',
    unSelectIcon: Icons.account_balance_wallet,
    selectIcon: Icons.account_balance_wallet_outlined,
    initialRoute: WalletPage(),
    index: NavigationTabs.wallet,
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
