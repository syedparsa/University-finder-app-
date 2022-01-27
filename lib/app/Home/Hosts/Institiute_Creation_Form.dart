
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:provider/provider.dart';


class Institutecreation extends StatefulWidget {


  final Database database;
   final Hosts? host;



   const Institutecreation({Key? key,  required this.database, this.host})
      : super(key: key);



  static Future<void> Show(BuildContext context,   { Hosts? host,}) async {
  final  database=Provider.of<Database>(context,listen: false);
    await Navigator.of(context,rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context) => Institutecreation(
          database: database,
          host: host,
        ),
        fullscreenDialog: false,
      ),
    );
  }




  @override
  _InstitutecreationState createState() => _InstitutecreationState();
}

class _InstitutecreationState extends State<Institutecreation> {
  final _formKey = GlobalKey<FormState>();
  String? _name = "";
  String? _emailid = "";
  String? _Domain = "";
  int? _contact=0;
  String? _countrycode;

  @override
  void initState() {
    super.initState();
    if (widget.host != null) {
      _name = widget.host!.name;
      _contact=widget.host!.contact;
      _Domain=widget.host!.Domain;
      _emailid=widget.host!.emailid;
      _countrycode=widget.host!.countrycode;
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
        final hosts=await widget.database.HostsStream().first;
        final allEmails=hosts.map((host)=>host.emailid).toList();
        final allNames=hosts.map((host)=>host.name).toList();
        final allDomains=hosts.map((host)=>host.Domain).toList();


        if(allEmails.contains(_emailid) || allNames.contains(_name) || allDomains.contains(_Domain)){
          ShowAlertDailog(context, defaultActionText: 'ok',
              title: ' OOPs looks we have an Institute with same details already',
              content: 'Please choose unique details');
        } else{

          final id= widget.host?.id
              ?? DocumentIDfromCurrentDate();
          final host = Hosts
            (name: _name!,countrycode: _countrycode,  id: id, contact:_contact!,emailid: _emailid!,Domain: _Domain!);
          await widget.database.SetHost(host);
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
        backgroundColor: const Color(0xff123456),
        elevation: 2.0,
        title: const Text( 'Register New Institute'),
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
        decoration: const InputDecoration(labelText: 'Institute name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Domian of the institute '),
        validator: (value) =>
        value!.isNotEmpty ? null : 'Domain can\'t be empty',
        onSaved: (value) => _Domain = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Email id of the institute'),
        validator: (value) =>
        value!.isNotEmpty ? null : 'EmailId  can\'t be empty',
        onSaved: (value) => _emailid = value!,
      ),



    CustomRaisedButton(color: Colors.white, child: CountryCodePicker(
      showDropDownButton: true,

      backgroundColor: Colors.white54,
      onChanged: _onCountryChange,
      hideMainText: false,
      showFlagMain: true,
      showFlag: true,
      initialSelection: 'Hu',
      hideSearch: true,
      showCountryOnly: false,
      showOnlyCountryWhenClosed: true,
      alignLeft: true,
      comparator: (a, b) => b.name!.compareTo(a.name!),
      onInit: (code) =>
          print("on init ${code?.name} ${code?.dialCode} ${code?.name}"),

    ),

        onPressed: (){}),







      TextFormField(
        decoration: const InputDecoration(labelText: 'Contact '),


        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        validator: (value) =>
        value!.isNotEmpty ? null : 'Value can\'t be empty',
        onSaved: (value) => _contact = int.tryParse(value!) ?? 0,
      ),



    ];
  }

  void _onCountryChange(CountryCode countryCode) {
    //TODO : manipulate the selected country code here
    String? code=countryCode.toString();
    setState(() {

      if (code != "") _countrycode = code;
    });
    print("New Country selected: " + countryCode.toString());
  }

}
