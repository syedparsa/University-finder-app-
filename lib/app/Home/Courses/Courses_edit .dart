import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Courses_Model.dart';
import 'package:dream_university_finder_app/common_widgets/DateTime.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoursesEditPage extends StatefulWidget {
  final Database database;

  final Courses? course;

  const CoursesEditPage({Key? key, required this.database,  required this.course})
      : super(key: key);

  static Future<void> Show(BuildContext context, { Courses? course}) async {
    final database=Provider.of<Database>(context,listen:false);
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => CoursesEditPage(
          database: database,
          course: course,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _CoursesEditPageState createState() => _CoursesEditPageState();
}

class _CoursesEditPageState extends State<CoursesEditPage> {

  final _formKey = GlobalKey<FormState>();

  String? _comment;
  String? _name = "";
  String? _details = "";
  String? _educationlevel = "";
  String? _admissionoffer = "";
  String? _courseID = "";
  int? _courseFee = 0;
  int? _courseduration = 0;
  int? _credithours = 0;

  @override
  void initState() {
    super.initState();

    if (widget.course != null) {


      _comment = widget.course?.comment ?? '';

      _name = widget.course!.name;
      _details = widget.course!.details;
      _educationlevel = widget.course!.educationlevel;
      _admissionoffer = widget.course!.admissionoffer;
      _courseduration = widget.course!.duration;
      _courseID = widget.course!.CourseId;
      _courseFee = widget.course!.CourseFee;
      _credithours = widget.course!.Credithours;
    }
  }

  bool _ValidateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }


  

  Future<void> _submit() async {
    if (_ValidateAndSaveForm()) {
      try {
        final course = await widget.database.CoursesStream().first;
        final allNames = course.map((course) => course.name).toList();
        final allCodes = course.map((course) => course.CourseId).toList();

        if (widget.course != null) {
          allNames.remove(widget.course!.name);
        }

        if (allNames.contains(_name) || allCodes.contains(_courseID)) {
          ShowAlertDailog(context,
              defaultActionText: 'ok',
              title: 'Name/Course ID already used',
              content: 'Please choose unique details');
        } else {

          final id = widget.course?.id  ?? DocumentIDfromCurrentDate();
          final course = Courses(duration: _courseduration!,
              CourseFee: _courseFee!, name: _name!,
              educationlevel: _educationlevel!,
              admissionoffer: _admissionoffer!,
              details: _details!, id: id, CourseId:
              _courseID!, Credithours: _credithours!,
              comment: _comment!
            );
          await widget.database.SetCourse(course);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlert(context, title: 'Operation Failed', exception: e);
      }
    }


    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
        elevation: 2.0,
        title: Text(widget.course == null
            ? 'Register New Course'
            : 'Edit the Course details'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body:
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(

                children:[
                _buildcontent(),


                  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildComment(),
                ),
              ],),
            ),
          ),
        ),
      ),

      backgroundColor: Colors.blueGrey.shade300,
    );
  }

 /* Widget _buildStartDate() {
    return CourseDatepicker(
      labelText: 'Start',
      selectedDate: _startDate!,

      selectDate: (value) => setState(() => _startDate = value),

    );
  }*/

 /* Widget _buildEndDate() {
    return CourseDatepicker(
      labelText: 'End',
      selectedDate: _endDate!,

      selectDate: (value) => setState(() => _endDate = value),

    );
  }*/
  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: const InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (value) => _comment = value,
    );


  }

  Widget _buildcontent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildform(),
          ),
        ),
      ),
    );
  }

  Widget _buildform() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildchildernForm(),
      ),
    );
  }

  List<Widget> _buildchildernForm() {
    return [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Course name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: ' Course Code'),
        validator: (value) =>
            value!.isNotEmpty ? null : 'value  can\'t be empty',
        onSaved: (value) => _courseID = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Details of the Course '),
        validator: (value) =>
            value!.isNotEmpty ? null : 'value can\'t be empty',
        onSaved: (value) => _details = value!,
      ),
      TextFormField(
        decoration:
            const InputDecoration(labelText: 'Offered Admission Spring/fall'),
        validator: (value) =>
            value!.isNotEmpty ? null : 'value  can\'t be empty',
        onSaved: (value) => _admissionoffer = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: ' Masters/Bacherlors/PHD'),
        validator: (value) =>
            value!.isNotEmpty ? null : 'value  can\'t be empty',
        onSaved: (value) => _educationlevel = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Annual Fee'),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Value can\'t be empty',
        onSaved: (value) => _courseFee = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'CreditHour'),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Value can\'t be empty',
        onSaved: (value) => _credithours = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Course duration'),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Value can\'t be empty',
        onSaved: (value) => _courseduration = int.tryParse(value!) ?? 0,
      ),
    ];
  }


}
