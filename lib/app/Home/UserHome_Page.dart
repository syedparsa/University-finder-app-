import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Dashboard/dash_board_page.dart';
import 'package:dream_university_finder_app/app/Home/UserTabs.dart';
import 'package:dream_university_finder_app/app/Home/User_home_Scaffold.dart';
import 'package:dream_university_finder_app/app/Home/accounts/Account_Page.dart';
import 'package:dream_university_finder_app/app/Home/Favourite_Selection/Wish_list_Model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user_Model.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Tabitems _currenTab = Tabitems.Dashboard;
  EndUser? end;

  _getuser() async {
    final db = Provider.of<Database>(context, listen: false);
    final manager = Provider.of<AuthBase>(context, listen: false);
    var user = EndUser(email: manager.currentUser!.email);
    var users = await db.usersStream().first;
    var userr =
        users.where((element) => element.email == manager.currentUser!.email);

    if (userr.length > 0) {
      manager.setEnduser(userr.elementAt(0));
      setState(() {
        end = userr.elementAt(0);
      });
    } else {
      manager.setEnduser(user);
      db.setUser(user, manager.currentUser!.uid);
      setState(() {
        end = user;
      });
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _getuser();
    });
  }

  final Map<Tabitems, GlobalKey<NavigatorState>> navigatorkeys = {
    Tabitems.Dashboard: GlobalKey<NavigatorState>(),
    Tabitems.Favourites: GlobalKey<NavigatorState>(),
    Tabitems.Settings: GlobalKey<NavigatorState>(),
  };

  void _select(Tabitems tabitems) {
    if (tabitems == _currenTab) {
      navigatorkeys[tabitems]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currenTab = tabitems);
    }
  }

  Map<Tabitems, WidgetBuilder> get widgetBuilders {
    final manger = Provider.of<AuthBase>(context, listen: false);
    _getuser();

    return {
      Tabitems.Dashboard: (_) => WillPopScope(
            onWillPop: () async => false,
            child: DashboardPage(),
          ),
      Tabitems.Favourites: (_) => WillPopScope(
            onWillPop: () async => false,
            child: WishListPage(user: end!),
          ),
      Tabitems.Settings: (_) => WillPopScope(
            onWillPop: () async => false,
            child: AccountPage(),
          ),
    };
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _getuser();
    });
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
