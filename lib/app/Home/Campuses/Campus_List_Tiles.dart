


import 'dart:typed_data';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UniListTiles extends StatefulWidget {
  const UniListTiles({Key? key, this.db,  this.onTap,  this.uni})
      : super(key: key);
  final Database? db;
  final VoidCallback? onTap;
  final Campuses? uni;
  @override
  _UniListTilesState createState() => _UniListTilesState();
}

class _UniListTilesState extends State<UniListTiles> {




  Image? image;






  void getImage() async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db=Provider.of<Database>(context) ;
    String uid = auth.currentUser!.uid;
    if (widget.uni!.imageurl != null) {
      var img = await db.downloadImage('uploads/$uid.' 'jpg');

        setState(() {
      if(img !="")    image = img as Image? ;
        });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Container(

      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [

               Expanded(
                 child: InkWell(

                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image as ImageProvider ,
                        fit: image == null ? BoxFit.contain : BoxFit.cover,
                      ),
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
                                widget.uni!.name!,


                                textAlign: TextAlign.center,
                                 style: const TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 20.0,
                                ),
                              ),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
               ),

            Expanded(
              child: InkWell(

                child: Container(
                  height: 180,

                  margin: const EdgeInsets.only(top: 60,bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: shadowlist,
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),)
                  ),

                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.uni!.name!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic
                              ),
                            ),
                            Text(

                              widget.uni!.details!+  "   " + "  "+
                                  widget.uni!.address!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.w200,
                                fontSize: 20.0,
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),),

          ],
        ),
      ),
    );
  }
}
