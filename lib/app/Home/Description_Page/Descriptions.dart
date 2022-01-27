
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campus_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Description_Page/Campus_Description_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Descriptions extends StatelessWidget {
  const Descriptions({Key? key, this.camp, this.database}) : super(key: key);
final Campuses? camp;
final Database? database;
  static Future<void> show(BuildContext context, Campuses camp ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => Descriptions(database: database, camp: camp),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Campuses>>(
      stream: database.CampusesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Campuses>(
          snapshot: snapshot,
          itembuilder: (context, camp) => Dismissible(
            background: Container(
              color: Colors.red,
            ),
            key: Key('camp-${camp.id}'),
            child: CampusDescriptionTiles(
              uni: camp, onTap: () {  },

            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            _buildContent(context),


          ],
        ),
      ),
    );
  }
}
