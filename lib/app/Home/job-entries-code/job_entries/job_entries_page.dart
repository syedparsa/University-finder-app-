import 'dart:async';

import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Jobs/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Jobs/edit_Job_Page.dart';
import 'package:dream_university_finder_app/app/Home/job-entries-code/job_entries/entry_page.dart';
import 'package:dream_university_finder_app/app/Home/models/Job.dart';
import 'package:dream_university_finder_app/app/Home/models/entry.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'entry_list_item.dart';


class JobEntriesPage extends StatelessWidget {
  JobEntriesPage({this.entry,required this.database, required this.job});

  final Database database;
  final Job job;
  Entry? entry;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry? entry) async {
    try {
      await database.deletejobEntry(entry!);
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
      appBar: AppBar(
        elevation: 2.0,
        title: Text(job.name),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => EditJobPage.Show(context, job: job,database: database),
          ),
        ],
      ),
      body: _buildContent(context, job),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            EntryPage.show(context: context, database: database, job: job),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Job? job) {
    return StreamBuilder<List<Entry>>(
      stream: database.jobentriesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
           itembuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
