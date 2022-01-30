
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campuses_entries/Campus_entries_page.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/edit_Campus_Page.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/List_Items_Builder.dart';


import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Campus_List_Tiles.dart';



class CampusesPage extends StatelessWidget {






  Future<void> _delete(BuildContext context, Campuses uni) async {

    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.DeleteCampus(uni);
    }
    on FirebaseException catch(e){
      showExceptionAlert(context, title: 'Operation failed', exception: e);

    }
  }


  @override
  Widget build(BuildContext context,) {

   final database=Provider.of<Database>(context,listen:false);
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text('Campuses'),
      actions:<Widget> [
        IconButton(
          icon:const Icon(Icons.add, color: Colors.white,),
          onPressed: ()=>EditCampusPage.Show(context,
            database:Provider.of<Database>(context,listen: false),

          ),
        ),

      ],),
      body:  _buildContent(context),

    );
  }

  Widget _buildContent(BuildContext context) {
   final database=Provider.of<Database>(context,listen: false);
   return StreamBuilder<List<Campuses>>(
       stream: database.CampusesStream(),
       builder: (context,snapshot){
         return ListItemBuilder<Campuses>(
         snapshot: snapshot,
         itembuilder: (context,uni)=>Dismissible(
           background: Container(color: Colors.red,),
           direction: DismissDirection.endToStart,
           key: Key('uni-${uni.id}'),
           onDismissed: (direction)=> _delete(context,uni),
           child: CampusListTiles(uni: uni,
               onTap:  () => CourseEntries.show(context,uni),
           ),
         ),
         );

         },
   );
  }




}
