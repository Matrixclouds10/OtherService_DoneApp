import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weltweit/core/tabs/tab.dart';
import 'package:weltweit/features/screens/provider_more/more_page.dart';
import 'package:weltweit/features/screens/provider_profile/profile_page.dart';
import 'package:weltweit/generated/assets.dart';
import 'package:weltweit/generated/locale_keys.g.dart';

import '../../provider_home/home_page.dart';
import '../../provider_wallet/wallet_page.dart';

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
    unSelectIcon: FontAwesomeIcons.house,
    selectIcon: FontAwesomeIcons.house,
    initialRoute: HomePage(),
    index: NavigationTabs.home,
  ),
  NavigationTab(
    name: LocaleKeys.wallet,
    image: '',
    unSelectIcon: FontAwesomeIcons.wallet,
    selectIcon: FontAwesomeIcons.wallet,
    initialRoute: WalletPage(),
    index: NavigationTabs.wallet,
  ),
  NavigationTab(
    name: LocaleKeys.profile,
    image: '',
    selectIcon: FontAwesomeIcons.userLarge,
    unSelectIcon: FontAwesomeIcons.userLarge,
    initialRoute: ProfilePage(),
    index: NavigationTabs.profile,
  ),
  NavigationTab(
    name: LocaleKeys.more,
    image: '',
    selectIcon: FontAwesomeIcons.listUl,
    unSelectIcon: FontAwesomeIcons.listUl,
    initialRoute: MorePage(),
    index: NavigationTabs.more,
  ),
];
