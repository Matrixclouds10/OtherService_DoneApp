import 'package:weltweit/core/extensions/num_extensions.dart';
import 'package:weltweit/core/resources/text_styles.dart';
import 'package:weltweit/core/resources/theme/theme.dart';
import 'package:weltweit/core/tabs/tab.dart';
import 'package:weltweit/presentation/component/component.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final ValueChanged<int> _onTap;
  final int _currentIndex;
  final List<NavigationTab> _tabs;

  const BottomNavigationBarWidget({
    Key? key,
    required ValueChanged<int> onTap,
    required int currentIndex,
    required List<NavigationTab> tabs,
  })  : _onTap = onTap,
        _currentIndex = currentIndex,
        _tabs = tabs,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedFontSize: 12.sp,
      selectedItemColor: servicesTheme.primaryColor,
      // type: BottomNavigationBarType.shifting,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).cardColor,
      showUnselectedLabels: true,
      showSelectedLabels: true,

      selectedLabelStyle: const TextStyle().descriptionStyle().activeColor(),
      unselectedLabelStyle: const TextStyle().descriptionStyle(),
      onTap: (index) {
        if (index != 2) {
          _onTap(index);
        } else {
          return;
        }
      },

      currentIndex: _currentIndex,
      items: [..._generateTags(context)],
    );
  }

  _generateTags(BuildContext context) {
    return _tabs.map((tab) => _buildItem(context, tab)).toList();
  }

  _buildItem(BuildContext context, NavigationTab tab) {
    if (tab.index == 2) {
      return BottomNavigationBarItem(icon: Container(), label: "");
    }
    return BottomNavigationBarItem(
      label: tr(tab.name),
      icon: TapEffect(
        onClick: () => _onTap(tab.index),
        child: Icon(
            _currentIndex == tab.index ? tab.selectIcon : tab.unSelectIcon,
            color: _currentIndex == tab.index
                ? servicesTheme.primaryColor
                : Theme.of(context).hintColor),
        // child: SvgPicture.asset(tab.image,
        //     height: 28.r, width: 28.r, color: servicesTheme.primaryColor),
      ),
    );
  }
}
