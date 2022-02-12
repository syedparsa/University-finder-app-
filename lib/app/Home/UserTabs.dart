

import 'package:flutter/material.dart';

enum Tabitems{Dashboard, Favourites,Settings   }

class TabItemData{
  const TabItemData({required this.title, required this.icon});
  final String? title;
  final IconData? icon;

  static const Map<Tabitems,TabItemData>allTabs={

    Tabitems.Dashboard:TabItemData(title: 'Universities', icon:Icons.school),
    Tabitems.Favourites:TabItemData(title: 'Favourites', icon:Icons.favorite),
    Tabitems.Settings:TabItemData(title: 'Settings', icon:Icons.settings),


  };
}