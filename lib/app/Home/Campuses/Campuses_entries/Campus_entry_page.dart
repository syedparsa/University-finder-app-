
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/course_format.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Entry_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/date_time_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '';


class CourseEntryPage extends StatefulWidget {
  const CourseEntryPage({required this.database, required this.camp, required this.entry, this.host});
  final Database database;
  final campusEntry? entry;
  final Campuses camp;
  final Hosts? host;


  static Future<void> show({BuildContext? context,
     Database? database, Campuses? camp, campusEntry? entry}) async {
    await Navigator.of(context!).push(
      MaterialPageRoute(
        builder: (context) =>
            CourseEntryPage(database: database!, camp: camp!, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }





  @override
  State<StatefulWidget> createState() => _CourseEntryPageState();
}

class _CourseEntryPageState extends State<CourseEntryPage> {
   DateTime? _startDate;
  DateTime? _endDate;
  String _comment="";
   String _details="" ;

   String _courseID="" ;
   int _courseFee =0;
   final int _courseduration=0 ;
   int _credithours=0 ;


  String _selectedsems="semester";
  String _selectdadmssion="education";



  List<DropdownMenuItem<String>> get semsdropdown{
    List<DropdownMenuItem<String>> menuItems  = [

      const DropdownMenuItem(child: Text("Spring"),value: "Spring"),
      const DropdownMenuItem(child: Text("fall"),value: "fall"),

    ];
    return menuItems ;
  }
  List<DropdownMenuItem<String>> get Educationdropdown{
    List<DropdownMenuItem<String>> menuItems  = [
      const DropdownMenuItem(child: Text("Bachelor's"),value: "Bachelor"),
      const DropdownMenuItem(child: Text("Master's"),value: "Master's"),
      const DropdownMenuItem(child: Text("Phd"),value: "Phd"),

    ];
    return menuItems ;
  }

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);


    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);


    _comment = widget.entry?.comment ?? '';
  }


  campusEntry _entryFromState() {
    final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day);
    final id = widget.entry?.id ?? DocumentIDfromCurrentDate();
    return campusEntry(

        id: id, start: start, comment:_comment
        , end: end, duration: _courseduration,
        CourseFee:_courseFee, educationlevel:
        _selectdadmssion, admissionoffer:_selectedsems ,
        details: _details, CourseId: _courseID,
        Credithours: _credithours);
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {

     try {
       final entry = _entryFromState();
       await widget.database.setcampusEntry(entry);
       Navigator.of(context).pop();
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

        backgroundColor: const Color(0xff123456),
        elevation: 2.0,
        title: Text( widget.camp.name!),
        actions: <Widget>[
          FlatButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStartDate(),


              _buildEndDate(),
              const SizedBox(height: 8.0),

              _buildSemesterropdown(),
              const SizedBox(height: 8.0),

              _buildeduropdown(),
              const SizedBox(height: 8.0),

              _buildComment(),
              _buildform(),
              const SizedBox(height: 8.0),
              _buildDuration(),

            ],
          ),
        ),
      ),
    );
  }
   Widget _buildform() {
     return Form(

       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: _buildchildernForm(),
       ),
     );
   }
   Widget _buildSemesterropdown(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      mainAxisAlignment: MainAxisAlignment.start,
      children: [ DropdownButtonFormField(
          items: semsdropdown,
        hint: const Text(" semester "),
        onChanged:
            (String? newValue){
        setState(() {
          _selectedsems = newValue!;
        });
      },
      ),
    ],
    );

   }
  Widget _buildeduropdown(){
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,

      mainAxisAlignment: MainAxisAlignment.start,
      children: [ DropdownButtonFormField(
        items: Educationdropdown,
        hint: const Text(" education level "),
        onChanged:(String? newValue){
          setState(() {
            _selectdadmssion = newValue!;
          });
        },
      ),
      ],
    );

  }
   List<Widget> _buildchildernForm() {
     return [

       TextField(
         keyboardType: TextInputType.text,
         maxLength: 10,
         controller: TextEditingController(text: _courseID),
         decoration: const InputDecoration(
           labelText: 'CourseID/code',
           labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
         ),
         style: const TextStyle(fontSize: 20.0, color: Colors.black),
         maxLines: null,
         onChanged: (courseID) => _courseID = courseID,
       ),

       TextField(
         keyboardType: TextInputType.text,
         maxLength: 50,
         controller: TextEditingController(text: _details),
         decoration: const InputDecoration(
           labelText: 'Course details',
           labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
         ),
         style: const TextStyle(fontSize: 20.0, color: Colors.black),
         maxLines: null,
         onChanged: (coursedetails) => _details = coursedetails,
       ),

       TextFormField(
         decoration: const InputDecoration(labelText: 'Annual Fee'),
         keyboardType: const TextInputType.numberWithOptions(
             signed: false, decimal: false),
         validator: (CourseFee) =>
         CourseFee!.isNotEmpty ? null : 'Value can\'t be empty',
         onSaved: (CourseFee) => _courseFee = int.tryParse(CourseFee!) ?? 0,
       ),
       TextFormField(

         decoration: const InputDecoration(labelText: 'CreditHour'),
         keyboardType: const TextInputType.numberWithOptions(
             signed: false, decimal: false),
         validator: (Credithour) =>
         Credithour!.isNotEmpty ? null : 'Value can\'t be empty',
         onSaved: (Credithour) => _credithours = int.tryParse(Credithour!) ?? 0,
       ),

     ];
   }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate!,

      selectDate: (date) => setState(() => _startDate = date),

    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate!,

      selectDate: (date) => setState(() => _endDate = date),

    );
  }


   Widget _buildComment() {
     return TextField(
       keyboardType: TextInputType.text,
       maxLength: 20,
       controller: TextEditingController(text: _comment),
       decoration: const InputDecoration(
         labelText: 'course name',
         labelStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
       ),
       style: const TextStyle(fontSize: 20.0, color: Colors.black),
       maxLines: null,
       onChanged: (comment) => _comment = comment,
     );
   }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = CourseFormat.Sems(currentEntry.durationIndays);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }




}
