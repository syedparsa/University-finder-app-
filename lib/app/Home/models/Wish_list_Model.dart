/*
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  _WishListPageState createState() => _WishListPageState();
}




class _WishListPageState extends State<WishListPage> {
  Stream<List<Campuses>> wishlist = Stream.value([]);

  @override
  Widget build(BuildContext context) {
    if (Campuses.isSavedChanged) {
      Stream<List<Campuses>> wishlists;
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        wishlists = await getAttractions();
        setState(() {
          this.wishlist = wishlists;
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
            stream: this.wishlist,
            builder: (context, snapshot) {
              return ListItemsBuilder(
                snapshot: snapshot,
                itemBuilder: (context, attraction) => AttractionListCard(
                  attraction: attraction as Attraction,
                  onTap: () =>
                      _showDetailsPage(googlePlace, context, attraction),
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

    List<Campuses> newwish =
    attractions.where((element) => places.contains(element.id!)).toList();
    return Stream.value(newwish);
  }


}
*/
