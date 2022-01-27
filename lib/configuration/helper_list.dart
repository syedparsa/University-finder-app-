import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Color primaryGreen=const Color(0xff416d6d);
 List<BoxShadow> shadowlist=[

   BoxShadow(color: Colors.grey.shade300,blurRadius: 30,offset: const Offset(0,10),),
 ];

List<Map> drawerItems=[


  {
    'icon':Icons.help,
    'title':'need help',
  },
  {
    'icon':Icons.add_alert,
    'title':'set a lert',
  },

  {
    'icon':FontAwesomeIcons.plus,
    'title':'Contribution',
  },

  {
    'icon':FontAwesomeIcons.userAlt,
    'title':'Profile',
  },


];


