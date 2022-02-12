import 'package:dream_university_finder_app/app/Home/Campuses/CampusesPage.dart';
import 'package:dream_university_finder_app/app/Home/Courses/Courses.dart';
import 'package:dream_university_finder_app/app/Home/Cupertino_home_Scaffold.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/Hosts.dart';
import 'package:dream_university_finder_app/app/Home/accounts/Account_Page.dart';
import 'package:dream_university_finder_app/app/Home/tab_items.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Tabitems _currenTab = Tabitems.Host;


  final Map<Tabitems,GlobalKey<NavigatorState>> navigatorkeys ={
    Tabitems.account:GlobalKey<NavigatorState>(),
    Tabitems.Host:GlobalKey<NavigatorState>(),
    Tabitems.campus:GlobalKey<NavigatorState>(),

    Tabitems.courses:GlobalKey<NavigatorState>(),


  };




 void   _select(Tabitems tabitems) {
    if (tabitems==_currenTab){
      navigatorkeys[tabitems]!.currentState!.popUntil((route) => route.isFirst);
    }else

    {
   setState(()=> _currenTab=tabitems );
 }
  }



  Map<Tabitems,WidgetBuilder> get widgetBuilders{
    return {
      Tabitems.account:(_)=>const AccountPage(),
      Tabitems.Host:(_)=>HostsPage(),

      Tabitems.campus:(_)=>CampusesPage(),
      Tabitems.courses:(_)=>CoursePage(),
    };

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async => false,
      child: WillPopScope(
        onWillPop:() async => !await navigatorkeys[_currenTab]!.currentState!.maybePop() ,
        child: CuppertinoScaffold(
            currentTab: _currenTab, onSelect:_select,
            widgetBuilders: widgetBuilders,
          navigatorkeys: navigatorkeys,
        ),
      ),
    );
  }


}
