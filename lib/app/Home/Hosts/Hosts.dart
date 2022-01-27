
import 'package:dream_university_finder_app/Services/Database.dart';

import 'package:dream_university_finder_app/app/Home/Hosts/Host_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/Institiute_Creation_Form.dart';
import 'package:dream_university_finder_app/app/Home/Hosts/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';




class HostsPage extends StatelessWidget {









  Future<void> _delete(BuildContext context, Hosts host) async {

    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.DeleteHost(host);
    }
    on FirebaseException catch(e){
      showExceptionAlert(context, title: 'Operation failed', exception: e);

    }
  }





  @override
  Widget build(BuildContext context,) {
   
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text('Institutes'),
      actions:<Widget> [
        IconButton(
          icon:const Icon(Icons.add, color: Colors.white,),
          onPressed: ()=>Institutecreation.Show(context
          ),
        ),

      ],),
      body:  _buildContent(context),

    );
  }

  Widget _buildContent(BuildContext context) {
   final database=Provider.of<Database>(context,listen: false);
   return StreamBuilder<List<Hosts>>(
       stream: database.HostsStream(),
       builder: (context,snapshot){
         return ListItemBuilder<Hosts>(
         snapshot: snapshot,
         itembuilder: (context,host)=>Dismissible(
           background: Container(color: Colors.red,),
           direction: DismissDirection.endToStart,
           key: Key('host-${host.id}'),
           onDismissed: (direction)=> _delete(context,host),
           child: HostsTiles(host: host,

               onTap: ()=>Institutecreation.Show(context, host:host),

           ),
         ),
         );

         },
   );
  }









}
