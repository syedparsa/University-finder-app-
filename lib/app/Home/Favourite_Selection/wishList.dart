import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/Services/User.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campus_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Description_Page/Campus_Description_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class WishListPage extends StatefulWidget {
  const WishListPage({Key? key, required this.user}) : super(key: key);
  final MyUser user;

  @override
  _WishListPageState createState() => _WishListPageState(user);
}

class _WishListPageState extends State<WishListPage> {
  _WishListPageState(this.user);

  final MyUser user;
  Stream<List<Campuses>> attractions = Stream.value([]);

  @override
  Widget build(BuildContext context) {
    if (Campuses.isSavedChanged) {
      Stream<List<Campuses>> attractions;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        attractions = await getAttractions();
        setState(() {
          this.attractions = attractions;
        });
      });
      Campuses.isSavedChanged = false;
    }
    return Scaffold(
      body: _buildContents(context),
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
        Expanded(
          child: StreamBuilder<List<Campuses>>(
            stream: this.attractions,
            builder: (context, snapshot) {
              return ListItemBuilder(
                snapshot: snapshot,
                itembuilder: (context, attraction) => CampusDescriptionTiles(
                  uni: attraction as Campuses,
                  onTap: () =>(){},

                ),
              );
            },
          ),
        ),
      ],
    );
  }



  Future<Stream<List<Campuses>>> getAttractions() async {
    final db = Provider.of<Database>(context, listen: false);

    var places = user.savedPlacesIds;
    if (places == null) return Stream.value([]);
    var attractions = await db.CampusesStream().first;

    List<Campuses> newAttractions =
    attractions.where((element) => places.contains(element.id!)).toList();
    return Stream.value(newAttractions);
  }
}