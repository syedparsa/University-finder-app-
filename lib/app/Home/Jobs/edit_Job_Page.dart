import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Job.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EditJobPage extends StatefulWidget {
  final Database? database;
  final Job? job;

  const EditJobPage({Key? key, required this.database,   this.job}) : super(key: key);

  static Future<void> Show(BuildContext context, {Job? job, Database? database,}) async {

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
         
          database: database,
          job: job,

        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _rateperhour;

  @override
  void initState(){
  super.initState();
  if (widget.job !=null){

    _name=widget.job!.name;
    _rateperhour=widget.job!.ratePerHour;
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
        final jobs=await widget.database!.jobsStream().first;
        final allNames=jobs.map((job)=>job.name).toList();
        if (widget.job !=null){
          allNames.remove(widget.job!.name);
        }

        if(allNames.contains(_name)){
              ShowAlertDailog(context, defaultActionText: 'ok',
              title: 'Name already used',
                  content: 'Please choose different name');
        } else{

          final id= widget.job?.id
          ?? DocumentIDfromCurrentDate();
          final job = Job(name: _name!, ratePerHour: _rateperhour!, id: id);
          await widget.database!.SetJob(job);
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
        elevation: 2.0,
        title: Text(widget.job==null ? 'New Job':'Edit job'),
        actions: <Widget>[
          FlatButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildcontent(),
      backgroundColor: Colors.grey[200],
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
        decoration: const InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Rate Per Hour'),
        initialValue: _rateperhour !=null ?  '$_rateperhour': null,
        keyboardType:
            const TextInputType.numberWithOptions(signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Value can\'t be empty',
        onSaved: (value) => _rateperhour = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
