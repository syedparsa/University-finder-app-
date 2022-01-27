import 'package:dream_university_finder_app/app/Home/UserTabs.dart';
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: CupertinoTabScaffold(

        backgroundColor: primaryGreen,
        tabBar: CupertinoTabBar(
          items: [
            _buildItems(Tabitems.Settings),
            _buildItems(Tabitems.Favourites),
            _buildItems(Tabitems.Universities),
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
      ),
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
