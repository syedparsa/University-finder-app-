import 'package:dream_university_finder_app/app/Home/Campuses/CampusesPage.dart';
import 'package:dream_university_finder_app/app/Home/Dashboard/dash_board_page.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/Hosts.dart';
import 'package:dream_university_finder_app/app/Home/UserTabs.dart';
import 'package:dream_university_finder_app/app/Home/User_home_Scaffold.dart';
import 'package:dream_university_finder_app/app/Home/accounts/Account_Page.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Tabitems _currenTab = Tabitems.Settings;

  final Map<Tabitems, GlobalKey<NavigatorState>> navigatorkeys = {
    Tabitems.Settings: GlobalKey<NavigatorState>(),
    Tabitems.Favourites: GlobalKey<NavigatorState>(),
    Tabitems.Universities: GlobalKey<NavigatorState>(),
  };

  void _select(Tabitems tabitems) {
    if (tabitems == _currenTab) {
      navigatorkeys[tabitems]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currenTab = tabitems);
    }
  }

  Map<Tabitems, WidgetBuilder> get widgetBuilders {
    return {
      Tabitems.Settings: (_) => const AccountPage(),
      Tabitems.Favourites: (_) => HostsPage(),
      Tabitems.Universities: (_) => DashboardPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorkeys[_currenTab]!.currentState!.maybePop(),
      child: CuppertinoScaffold(
        currentTab: _currenTab,
        onSelect: _select,
        widgetBuilders: widgetBuilders,
        navigatorkeys: navigatorkeys,
      ),
    );
  }
}
