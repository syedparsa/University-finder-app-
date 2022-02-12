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
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(host.name + '  ' + 'details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(height: 25),
                InkWell(
                  onTap: onTap,
                  child: Container(
                    height: 400,
                    decoration: host.imageurl != null
                        ? BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(host.imageurl!),
                        fit: host.imageurl == null
                            ? BoxFit.contain
                            : BoxFit.cover,
                      ),
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: shadowlist,
                    )
                        : BoxDecoration(),
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
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Material(
                          child: InkWell(
                            child: Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: ElevatedButton.icon(
                                  label: Text(
                                    'Add to Wish list',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(
                                          Colors.black),
                                      padding: MaterialStateProperty.all(
                                          EdgeInsets.only(left: 10, right: 10)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .horizontal(
                                                  left: Radius.elliptical(5, 5),
                                                  right:
                                                  Radius.elliptical(5, 5)),
                                              side: BorderSide(
                                                  color: Colors.transparent)))),
                                  onPressed: () {
                                    final auth = Provider.of<AuthBase>(context,
                                        listen: false);
                                    final db = Provider.of<Database>(context,
                                        listen: false);
                                    print("zeeshan");
                                    print(auth.endUser);

                                    if (auth.endUser!.savedHostIds != null &&
                                        auth.endUser!.savedHostIds!.length >
                                            0) {
                                      var hosts = auth.endUser!.savedHostIds!;
                                      hosts.add(host.id);
                                      auth.endUser!.savedHostIds = hosts;
                                    } else {
                                      print("Adil");
                                      print(auth.endUser);
                                      auth.setEnduser(EndUser(
                                          email: auth.currentUser!.email!,
                                          savedHostIds: [host.id],
                                      savedcampIds: auth.endUser!.savedcampIds!),
                                      );
                                    }
                                    db.setUser(

                                        auth.endUser!, auth.currentUser!.uid);
                                    Hosts.isSavedChanged = true;
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.heart,
                                    color: Colors.red,
                                    semanticLabel: 'add to wishlist',
                                    size: 50,
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding:
                          EdgeInsets.only(left: 40, top: 10, right: 40),
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
                    margin: const EdgeInsets.only(top: 20, bottom: 50),
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
                                host.name + '\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                host.details + '\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                host.address + '\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                host.Domain + '\n',
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
