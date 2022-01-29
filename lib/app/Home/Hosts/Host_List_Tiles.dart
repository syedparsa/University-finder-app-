import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:flutter/material.dart';
class HostsTiles extends StatefulWidget {
  const HostsTiles({Key? key, this.host, this.onTap, this.db}) : super(key: key);
  final Hosts? host;
  final Database? db;
  final VoidCallback? onTap;
  @override
  _HostsTilesState createState() => _HostsTilesState();
}

class _HostsTilesState extends State<HostsTiles> {

  String? image;

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

                  decoration: widget.host!.imageurl!= null ? BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.host!.imageurl!),
                      fit: widget.host!.imageurl == null ? BoxFit.contain : BoxFit.cover,
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
                              widget.host!.name,
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
                              widget.host!.Domain,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              widget.host!.details+
                                  "   " +
                                  "  " +
                                  widget.host!.address,
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
