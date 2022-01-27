import 'package:dream_university_finder_app/app/Home/tab_items.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CuppertinoScaffold extends StatelessWidget {
  const CuppertinoScaffold(
      {Key? key,
      required this.currentTab,
      required this.onSelect,
      required this.widgetBuilders,
      required this.navigatorkeys})
      : super(key: key);

  final Tabitems currentTab;
  final ValueChanged<Tabitems> onSelect;
  final Map<Tabitems, WidgetBuilder> widgetBuilders;
  final Map<Tabitems, GlobalKey<NavigatorState>> navigatorkeys;

  @override
  Widget build(BuildContext context) {
    return

          CupertinoTabScaffold(


            backgroundColor: primaryGreen,
            tabBar: CupertinoTabBar(
              items: [
                _buildItems(Tabitems.account),
                _buildItems(Tabitems.Host),
                _buildItems(Tabitems.campus),
                _buildItems(Tabitems.courses),
              ],
              onTap: (index) => onSelect(Tabitems.values[index]),
            ),
            tabBuilder: (context, index) {
              final item = Tabitems.values[index];
              return CupertinoTabView(

                navigatorKey: navigatorkeys[item],
                builder: (context) => widgetBuilders[item]!(context),
              );
            },
          );


  }

  BottomNavigationBarItem _buildItems(Tabitems? tabitems) {
    final itemData = TabItemData.allTabs[tabitems];
    final color =
        currentTab == tabitems ? const Color(0xff123456) : Colors.grey;
    return BottomNavigationBarItem(
      icon: Icon(
        itemData!.icon,
        color: color,
      ),
      label: itemData.title!,
    );
  }
}
