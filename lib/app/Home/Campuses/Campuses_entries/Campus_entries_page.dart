import 'dart:async';

import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campuses_entries/Campus_entry_page.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/edit_Campus_Page.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Entry_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../List_Items_Builder.dart';
import 'campus_entry_list_item.dart';


class CourseEntries extends StatelessWidget {
  const CourseEntries({ this.entry,required this.database,  required this.camp, this.host});

  final Database database;
  final campusEntry? entry;
  final Campuses camp;
  final Hosts? host;
  static Future<void> show(BuildContext context, Campuses camp ) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => CourseEntries(database: database, camp: camp),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, campusEntry? entry) async {
    try {
      await database.deletecampusEntry(entry!);
    } on FirebaseException catch (e) {
      showExceptionAlert(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,

        elevation: 2.0,
        title: Text(   camp.name! + " "+'Courses'),
        actions: <Widget>[
          IconButton( onPressed: () =>
              CourseEntryPage.show(context: context, database: database, camp: camp),
              icon: const Icon(Icons.add),),
          FlatButton(
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => EditCampusPage.Show(context, camp: camp,database: database),
          ),
        ],
      ),
      body: _buildContent(context, camp),

    );
  }

  Widget _buildContent(BuildContext context, Campuses? camp) {
    return StreamBuilder<List<campusEntry>>(
      stream: database.campusentriesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<campusEntry>(
          snapshot: snapshot,
           itembuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              camp: camp,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => CourseEntryPage.show(
                context: context,
                database: database,
                camp: camp,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
