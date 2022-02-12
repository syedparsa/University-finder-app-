import 'dart:ui';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


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


  launchURL(String url, String text) async {
    /*print(url);
    if (await canLaunch (url)) {
      await launch(url,
          enableJavaScript: true, forceSafariVC: false, enableDomStorage: true);
    } else {
      Clipboard.setData(
        ClipboardData(text: uni.address!),
      ).then(
            (value) => Fluttertoast.showToast(
            msg: 'Can\'t Launch ' + text + ', copied to the clipboard!'),
      );
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(uni.name!+ '  '+'details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [

                   uni.imageurl != null?
              InkWell(
              onTap: launchURL(uni.website!, 'url'),
              child: Container(
                      height: 400,
                      decoration: uni.imageurl!= null ? BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(uni.imageurl!),
                          fit: uni.imageurl == null ? BoxFit.contain : BoxFit.cover,
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
            )
                  :Container(),

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
                                child: ElevatedButton.icon(


                                  label: Text(
                                    'Add to Wish list',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.black),
                                      padding:
                                      MaterialStateProperty.all(EdgeInsets.only(left: 10,right: 10)),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),

                                              side: BorderSide(color: Colors.transparent)))),

                                  onPressed: () {
                                    final auth = Provider.of<AuthBase>(context,
                                        listen: false);
                                    final db = Provider.of<Database>(context,
                                        listen: false);
                                    if (auth.endUser!.savedcampIds != null) {
                                      auth.endUser!.savedcampIds!.add(uni.id!);
                                    } else {
                                      auth.setEnduser(EndUser(
                                          email: auth.currentUser!.email!,
                                          savedcampIds: [uni.id]));
                                    }
                                    db.setUser(
                                        auth.endUser!, auth.currentUser!.uid);
                                    Campuses.isSavedChanged = true;
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
                            uni.name!,
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
                              Text(
                                uni.name!+'\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    fontStyle: FontStyle.italic),
                              ),
                              Text(
                                uni.details!+'\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                uni.address!+'\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                uni.city!+'\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                "Word_Ranking " +
                                    "   " +
                                    uni.worldRanking!.toString()+'\n',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              Text(
                                "Country_Ranking " +
                                    "   " +
                                    uni.CountryRanking!.toString()+'\n',
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
