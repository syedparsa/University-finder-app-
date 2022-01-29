import 'dart:ui';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/Services/notification_service.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HostDescriptionTiles extends StatelessWidget {
  final Hosts host;

  final Database? db;
  final VoidCallback? onTap;

  const HostDescriptionTiles({
    Key? key,
    required this.host,
    required this.onTap,
    this.db,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(host.name+ '  '+'details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 400,
                    decoration: host.imageurl!= null ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(host.imageurl!),
                        fit: host.imageurl == null ? BoxFit.contain : BoxFit.cover,
                      ),
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: shadowlist,
                    ) : BoxDecoration(),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                host.name,
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
                                  onPressed: () {
                                    final auth = Provider.of<AuthBase>(context,
                                        listen: false);
                                    final db = Provider.of<Database>(context,
                                        listen: false);
                                    if (auth.endUser!.savedcampIds != null) {
                                      auth.endUser!.savedcampIds!.add(host.id!);
                                    } else {
                                      auth.setEnduser(EndUser(
                                          email: auth.currentUser!.email!,
                                          savedcampIds: [host.id]));
                                    }
                                    db.setUser(
                                        auth.endUser!, auth.currentUser!.uid);
                                    Hosts.isSavedChanged = true;
                                  },
                                  icon: FaIcon(FontAwesomeIcons.heart,color: Colors.red,
                                    semanticLabel: 'add to wishlist',
                                    size: 50,
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40, top: 10, right: 40),
                          child: Text(
                            host.name,
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                shadows: shadowlist),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                InkWell(
                  child: Container(

                    height: 400,
                    margin: const EdgeInsets.only(top: 20,bottom: 50),
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
                              SizedBox(height: 10),
                              Text(
                                host.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                host.details,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                host.address,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                host.Domain,
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
        ),
      ),
    );
  }
}