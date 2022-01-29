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
  Stream<List<Campuses>> camplist = Stream.value([]);
  Stream<List<Hosts>> hostlist = Stream.value([]);


   bool? isSaved;

  Future<Stream<List<Campuses>>> getFavcampus() async {
    final db = Provider.of<Database>(context, listen: false);
    var places = widget.user!.savedcampIds;
    if (places == null) return Stream.value([]);
    var attractions = await db.CampusesStream().first;

    List<Campuses> newcampus =
        attractions.where((element) => places.contains(element.id!)).toList();
    return Stream.value(newcampus);
  }

  Future<Stream<List<Hosts>>> getFavHost() async {
    final db = Provider.of<Database>(context, listen: false);
    var places = widget.user!.savedHostIds;
    if (places == null) return Stream.value([]);
    var attractions = await db.HostsStream().first;

    List<Hosts> newHost =
        attractions.where((element) => places.contains(element.id)).toList();
    return Stream.value(newHost);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var camp = await  getFavcampus();
      setState(() {
        this.camplist  = camp;
      });
    });
  }

  Widget _CampusStreambuilder(BuildContext context){

    return StreamBuilder<List<Hosts>>(
      stream: this.hostlist,
      builder: (context, snapshot) {
        return ListItemBuilder(
          snapshot: snapshot,
          itembuilder: (context, host) => HostsTiles(
            host: host as Hosts,
            onTap: () => () {

            },
          ),
        );
      },
    );
  }
Widget  _HostStreambuilder(BuildContext context) {

    return StreamBuilder<List<Hosts>>(
      stream: this.hostlist,
      builder: (context, snapshot) {
        return ListItemBuilder(
          snapshot: snapshot,
          itembuilder: (context, host) => HostsTiles(
            host: host as Hosts,
            onTap: () => () {

            },
          ),
        );
      },
    );

  }
  Widget _buildContents(BuildContext context) {
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
  }

  @override
  Widget build(BuildContext context) {
    if (Campuses.isSavedChanged) {
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        var camplist = await getFavcampus();
        setState(() {
          this.camplist = camplist;
        });
      });
      Campuses.isSavedChanged = false;
    }

    if (Hosts.isSavedChanged) {

      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        var hostlist = await getFavHost();

        setState(() {
          this.hostlist = hostlist;
        });
      });
      Campuses.isSavedChanged = false;
    }
    return Scaffold(
      appBar:AppBar (
        centerTitle: true,
          title: Text('Wish list')
      ),
      body: Column(children: [

        _CampusStreambuilder(context),
        _HostStreambuilder(context),
        _buildContents(context)],),
    );
  }


}
