import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';

class CardPage extends StatelessWidget {
  CardPage({ Key? key,
     Color? color,
     Color? shadowColor,
     double? elevation,
     ShapeBorder? shape,
    bool? borderOnForeground: true,
     EdgeInsetsGeometry? margin,
     Clip? clipBehavior,
     Widget? child,
    bool semanticContainer: true}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 20),
      child: Scaffold(
        appBar: AppBar(
          title: Text('GeeksforGeeks'),
          backgroundColor: Colors.greenAccent[400],
          centerTitle: true,
        ), //AppBar
        body: Center(
          /** Card Widget **/
          child: Column(
            children:[
              Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: Colors.greenAccent[100]!,

              child: SizedBox(
                width: 300,
                height: 500,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                  CircleAvatar(
                  backgroundColor: Colors.green[500],
                    radius: 108,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://pbs.twimg.com/profile_images/1304985167476523008/QNHrwL2q_400x400.jpg"),
                      //NetworkImage
                      radius: 100,
                    ), //CircleAvatar
                  ), //CirclAvatar
                  SizedBox(
                    height: 10,
                  ), //SizedBox
                  Text(
                    'GeeksforGeeks',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.green[900],
                      fontWeight: FontWeight.w500,
                    ), //Textstyle
                  ), //Text
                  SizedBox(
                    height: 10,
                  ), //SizedBox
                  const Text(
                    'GeeksforGeeks is a computer science portal',
                    style: TextStyle(
                    fontSize: 15,

                  ), //Textstyle
                ), //Text
                SizedBox(
                  height: 10,
                ), //SizedBox
                SizedBox(
                  width: 80,
                  child: RaisedButton(
                    onPressed: () => null,
                    color: Colors.green,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          Icon(Icons.touch_app),
                          Text('Visit'),
                        ],
                      ), //Row
                    ), //Padding
                  ), //RaisedButton
                ) //SizedBox
                ],
              ), //Column
            ), //Padding
        ), //SizedBox
      ),

              FavoriteButton(
                isFavorite: true,
                valueChanged: (_isFavorite) {
                  print('Is Favorite : $_isFavorite');
                },
              ),
            ],
          ), //Card
      )
      , //Center
      ),
    );

  }

}
