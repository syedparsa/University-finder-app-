
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Campuses/Campuses_entries/job_entries_page.dart';
import 'package:dream_university_finder_app/app/Home/Courses/Course_List_tiles.dart';
import 'package:dream_university_finder_app/app/Home/Courses/Courses_edit%20.dart';
import 'package:dream_university_finder_app/app/Home/Courses/List_Items_Builder.dart';
import 'package:dream_university_finder_app/app/Home/models/Courses_Model.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class CoursePage extends StatelessWidget {


  Future<void> _delete(BuildContext context, Courses course) async {

    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.DeleteCourse(course);
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
        title: const Text('Offered Courses'),
      actions:<Widget> [
        IconButton(
          icon:const Icon(Icons.add, color: Colors.white,),

          onPressed: ()=>CoursesEditPage.Show(context),
        ),
        IconButton(
          icon:const Icon(Icons.edit, color: Colors.white,),

          onPressed: ()=>CoursesEditPage.Show(context),
        ),

      ],),
      body:  _buildContent(context),

    );
  }

  Widget _buildContent(BuildContext context) {
   final database=Provider.of<Database>(context,listen: false);
   return StreamBuilder<List<Courses>>(
       stream: database.CoursesStream(),
       builder: (context,snapshot){
         return ListItemBuilder<Courses>(
         snapshot: snapshot,
         itembuilder: (context,course)=>Dismissible(
           background: Container(color: Colors.red,),
           direction: DismissDirection.endToStart,
           key: Key('course-${course.id}'),
           onDismissed: (direction)=> _delete(context,course),
           child: CoursesTiles(course: course,

               onTap: ()=>CoursesEditPage.Show(context, course:course),

           ),
         ),
         );

         },
   );
  }









}
