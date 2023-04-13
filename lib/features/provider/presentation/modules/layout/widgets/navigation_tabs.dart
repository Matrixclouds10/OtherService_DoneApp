import 'package:flutter/material.dart';
import 'package:weltweit/core/tabs/tab.dart';
import 'package:weltweit/features/provider/presentation/modules/more/more_page.dart';
import 'package:weltweit/features/screens/profile/profile_page.dart';

import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';
import '../../home/home_page.dart';
import '../../wallet/wallet_page.dart';

class NavigationTabs {
  /// Default constructor is private because this class will be only used for
  /// static fields and you should not instantiate it.
  NavigationTabs._();

  static const home = 0;
  static const wallet = 1;
  static const profile = 2;
  static const more = 3;
}

List<NavigationTab> kTabs = <NavigationTab>[
  NavigationTab(
    name: LocaleKeys.home,
    image: Assets.imagesSvgMoreNotificationIcon,
    unSelectIcon: Icons.house,
    selectIcon: Icons.house,
    initialRoute: HomePage(),
    index: NavigationTabs.home,
  ),
  NavigationTab(
    name: LocaleKeys.wallet,
    image: '',
    unSelectIcon: Icons.wallet,
    selectIcon: Icons.wallet,
    initialRoute: WalletPage(),
    index: NavigationTabs.wallet,
  ),
  NavigationTab(
    name: LocaleKeys.profile,
    image: '',
    selectIcon: Icons.person,
    unSelectIcon: Icons.person,
    initialRoute: ProfilePage(),
    index: NavigationTabs.profile,
  ),
  NavigationTab(
    name: LocaleKeys.more,
    image: '',
    selectIcon: Icons.list,
    unSelectIcon: Icons.list,
    initialRoute: MorePage(),
    index: NavigationTabs.more,
  ),
];
