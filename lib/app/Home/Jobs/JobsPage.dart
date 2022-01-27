
import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Jobs/Job_List_Tiles.dart';
import 'package:dream_university_finder_app/app/Home/Jobs/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/Jobs/edit_Job_Page.dart';
import 'package:dream_university_finder_app/app/Home/job-entries-code/job_entries/job_entries_page.dart';
import 'package:dream_university_finder_app/app/Home/models/Job.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class JobsPage extends StatelessWidget {




  





  Future <void>_Signout(BuildContext context) async {

    try {
      final auth=Provider.of<AuthBase>(context,listen: false,);


      await auth.signOut();



    }
    catch(e) {
      print (e.toString());

    }

  }
  Future<void> _confirmSignout (BuildContext context) async {
   final didrequestSiginout=await ShowAlertDailog(
        context,
       title: 'Logout',
       content: 'Are you sure you want to logout',
       cancelActiontext: 'Cancel',
       defaultActionText: 'Logout',
   );
 if(didrequestSiginout==true){

   _Signout(context);
 }
  }


  Future<void> _delete(BuildContext context, Job job) async {

    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.DeleteJob(job);
    }
    on FirebaseException catch(e){
      showExceptionAlert(context, title: 'Operation failed', exception: e);

    }
  }


  @override
  Widget build(BuildContext context,) {
   
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xff123456),
        title: const Text('Jobs'),
      actions:<Widget> [
        FlatButton(
          onPressed: ()=> _confirmSignout(context),
          child: const Text('log out ',
              style: TextStyle(fontSize: 18.0,color: Colors.white),
              ),
        )
      ],),
      body:  _buildContent(context),
      floatingActionButton: FloatingActionButton(

        child: const Icon(Icons.add),
        onPressed: ()=>EditJobPage.Show(context,
        database:Provider.of<Database>(context,listen: false),
      ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
   final database=Provider.of<Database>(context,listen: false);
   return StreamBuilder<List<Job>>(
       stream: database.jobsStream(),
       builder: (context,snapshot){
         return ListItemBuilder<Job>(
         snapshot: snapshot,
         itembuilder: (context,job)=>Dismissible(
           background: Container(color: Colors.red,),
           direction: DismissDirection.endToStart,
           key: Key('job-${job.id}'),
           onDismissed: (direction)=> _delete(context,job),
           child: JobListTiles(job: job,
               onTap: () => JobEntriesPage.show(context, job),
           ),
         ),
         );

         },
   );
  }




}
