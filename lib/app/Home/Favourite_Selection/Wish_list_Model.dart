import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campus_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/Host_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishListPage extends StatefulWidget {
  WishListPage({Key? key, this.user}) : super(key: key);
  EndUser? user;

  @override
  _WishListPageState createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  // Stream<List<Campuses>> camplist = Stream.value([]);
  // Stream<List<Hosts>> hostlist = Stream.value([]);
  var _CampusStreamController = StreamController<List<Campuses>>();
  var _HoststreamController = StreamController<List<Hosts>>();

  bool? isSaved;

  getFavcampus() async {
    final db = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    var places = auth.endUser!.savedcampIds;
    if (places == null) return Stream.value([]);
    var attractions = await db.CampusesStream().first;

    List<Campuses> newcampus =
        attractions.where((element) => places.contains(element.id!)).toList();
    _CampusStreamController.sink.add(newcampus);
  }
   getFavHost() async {
    final db = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    var places = auth.endUser!.savedHostIds;
    if (places == null) return Stream.value([]);
    var attractions = await db.HostsStream().first;

    List<Hosts> newHost =
        attractions.where((element) => places.contains(element.id)).toList();
    _HoststreamController.sink.add(newHost);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
     await getFavcampus();
      await getFavHost();
    });
  }





  Widget _CampusStreambuilder(BuildContext context) {

    return StreamBuilder<List<Campuses>>(

      stream: _CampusStreamController.stream,
      builder: (context, snapshot) {
        return ListItemBuilder(
          snapshot: snapshot,
          itembuilder: (context, uni) => CampusListTiles(
            uni: uni as Campuses,
            onTap: () => () {},
          ),
        );
      },
    );
  }


  Widget _HostStreambuilder(BuildContext context) {

    final auth=Provider.of<AuthBase>(context,listen: false);
    final databse=Provider.of<Database>(context,listen: false);


    return StreamBuilder<List<Hosts>>(
      stream: _HoststreamController.stream,
      builder: (context, snapshot) {

        return ListItemBuilder<Hosts>(
          snapshot: snapshot,
          itembuilder: (context, host,) =>Dismissible(
          background: Container(
            color: Colors.red,
          ),
          direction: DismissDirection.endToStart,
          key: Key('host-${host.id}'),
            onDismissed: (direction)=>
              WidgetsBinding.instance?.addPostFrameCallback((_) async

            {


              var id=auth.endUser!.savedHostIds!;
             /* var email=auth.endUser!.email!;

              var attractions = await databse.usersStream().first;
              List<EndUser> newHost =
              attractions.where((element)
              => id.contains(email==auth.currentUser?.email)).toList();*/

             id.remove(widget.user?.savedHostIds);
             databse.setUser(auth.endUser!,auth.currentUser!.uid);
          }),


              child:HostsTiles(
            host: host as Hosts,
            onTap: () => () {},
          ),
          ),
        );
      },
    );
  }

  /*Widget _buildContents(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child: Center(
            child: Text(
              'Wish List',
              style: TextStyle(
                color: Colors.teal,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
   /* if (Campuses.isSavedChanged) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await getFavcampus();
      });
      Campuses.isSavedChanged = false;
    }*/
     if (Hosts.isSavedChanged) {

      WidgetsBinding.instance?.addPostFrameCallback((_) async {
         await getFavHost();

      });
      Campuses.isSavedChanged = false;
    }
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
     appBar: AppBar(
       backgroundColor: Colors.blueGrey,
       centerTitle: true,
       title: Text('Wish List'),
     ),
      body:

           Column(
            children: [


/*
                Expanded(


                   child:_CampusStreambuilder(context),


             ),*/


               Expanded(

                    child:_HostStreambuilder(context),


              ),




            ],
          ),


    );
  }
}
