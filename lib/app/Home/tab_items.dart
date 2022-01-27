

import 'package:flutter/material.dart';

enum Tabitems{account,Host,campus,courses,}

class TabItemData{
  const TabItemData({required this.title, required this.icon});
  final String? title;
  final IconData? icon;

 static const Map<Tabitems,TabItemData>allTabs={

   Tabitems.account:TabItemData(title: 'Account', icon:Icons.person),
   Tabitems.Host:TabItemData(title: 'Institute', icon:Icons.school),
   Tabitems.campus:TabItemData(title: 'Campuses', icon:Icons.account_tree),
   Tabitems.courses :TabItemData(title: 'Courses', icon:Icons.book),


};
}