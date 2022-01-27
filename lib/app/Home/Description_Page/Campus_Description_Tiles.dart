import 'dart:ui';

import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/Services/notification_service.dart';
import 'package:dream_university_finder_app/app/Home/Notification/Notifications_Page.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CampusDescriptionTiles extends StatelessWidget {
  final Campuses uni;

  final Database? db;
  final VoidCallback? onTap;

  const CampusDescriptionTiles({
    Key? key,
    required this.uni,
    required this.onTap,
    this.db,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: shadowlist,
                ),
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            uni.name!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: onTap,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: shadowlist,
                    borderRadius: BorderRadius.circular(30)),
                child: Column(
                  children: [


                    Material(
                      child: InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite,
                                size: 50,
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40, top: 10, right: 40),
                      child: Text(
                        uni.name!,
                        style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            shadows: shadowlist),
                      ),
                    ),



                    Material(
                      child: InkWell(

                        child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: IconButton(
                              onPressed: (){
                                var f = NotificationService();
                                f.show();
                                },
                              icon: Icon(
                                Icons.add_alert,
                                size: 50,
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(

              child: Container(
                height: 400,
                margin: const EdgeInsets.only(top: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: shadowlist,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            uni.name!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                            uni.details! ,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 20.0,
                            ),

                          ),

                          Text(
                            uni.address!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 20.0,
                            ),

                          ),
                          Text(
                            uni.city! ,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 20.0,
                            ),

                          ),
                          Text(
                            "Word_Ranking "+"   "+uni.worldRanking!.toString() ,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 20.0,
                            ),

                          ),
                          Text(
                            "Country_Ranking "+"   "+uni.CountryRanking!.toString() ,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: 20.0,
                            ),

                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}