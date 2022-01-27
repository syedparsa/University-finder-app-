

import 'package:flutter/material.dart';

enum Tabitems{Settings,Favourites,Universities}

class TabItemData{
  const TabItemData({required this.title, required this.icon});
  final String? title;
  final IconData? icon;

  static const Map<Tabitems,TabItemData>allTabs={

    Tabitems.Settings:TabItemData(title: 'Settings', icon:Icons.settings),
    Tabitems.Favourites:TabItemData(title: 'Favourites', icon:Icons.favorite),
    Tabitems.Universities:TabItemData(title: 'Universities', icon:Icons.school),



  };
}