import 'dart:typed_data';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CampusListTiles extends StatefulWidget {
  const CampusListTiles({Key? key, this.db, this.onTap, this.uni})
      : super(key: key);
  final Database? db;
  final VoidCallback? onTap;
  final Campuses? uni;

  @override
  _CampusListTilesState createState() => _CampusListTilesState();
}

class _CampusListTilesState extends State<CampusListTiles> {



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

                  decoration: widget.uni!.imageurl!= null ? BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.uni!.imageurl!),
                      fit: widget.uni!.imageurl == null ? BoxFit.contain : BoxFit.cover,
                    ),
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: shadowlist,
                  ) : BoxDecoration(),
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
                onTap:widget.onTap,
                child: Container(
                  height: 180,
                  margin: const EdgeInsets.only(top: 60, bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: shadowlist,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )),
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
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              widget.uni!.details! +
                                  "   " +
                                  "  " +
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
