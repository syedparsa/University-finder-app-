import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/custom_raised_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Institutecreation extends StatefulWidget {
  const Institutecreation({Key? key, required this.database, this.host})
      : super(key: key);

  final Database database;
  final Hosts? host;

  static Future<void> Show(
    BuildContext context, {
    Hosts? host,Database? database,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
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
  int? _contact = 0;
  String? _countrycode;
  FirebaseStorage storage = FirebaseStorage.instance;
  String? _address;
  String? _details;
  String? _url;
  String? _imageUrl;


  @override
  void initState() {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    super.initState();
    if (widget.host != null) {
      _name = widget.host!.name;
      _contact = widget.host!.contact;
      _Domain = widget.host!.Domain;
      _emailid = widget.host!.emailid;
      _imageUrl=widget.host!.imageurl;
      _countrycode = widget.host!.countrycode;
      _address = widget.host!.address;
      _details = widget.host!.details;
      _url=widget.host!.url;

    }
    String? url;
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      url = await db.downloadImage('uploads/' + widget.host!.id + '.jpg');
      if (url != null && url!.isNotEmpty) {
        setState(() {

          _imageUrl = url;
        });
      }
    });
  }

  bool _ValidateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  String? id;

  _updateImage(var _image) async {
    id = widget.host?.id ?? DocumentIDfromCurrentDate();
    final db = Provider.of<Database>(context, listen: false);
    String downloadeUrl = await db.uploadImage(_image, 'uploads/$id!.' 'jpg');

    setState(() {
      _imageUrl = downloadeUrl;
    });
  }

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      await _updateImage(File(image.path));
    }
  }

  /// Get from Camera
  Future<void> _getFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      await _updateImage(File(image.path));
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _submit() async {
    if (_ValidateAndSaveForm()) {
      try {
        final hosts = await widget.database.HostsStream().first;
        final allEmails = hosts.map((host) => host.emailid).toList();
        final allNames = hosts.map((host) => host.name).toList();
        final allDomains = hosts.map((host) => host.Domain).toList();

        if (allEmails.contains(_emailid) ||
            allNames.contains(_name) ||
            allDomains.contains(_Domain)) {
          ShowAlertDailog(context,
              defaultActionText: 'ok',
              title:
                  ' OOPs looks we have an Institute with same details already',
              content: 'Please choose unique details');
        } else {
          final id = widget.host?.id ?? DocumentIDfromCurrentDate();
          final host = Hosts(
              url: _url,
              address: _address!,
              details: _details!,
              name: _name!,
              imageurl: _imageUrl,
              countrycode: _countrycode,
              id: id,
              contact: _contact!,
              emailid: _emailid!,
              Domain: _Domain!);
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
    backgroundColor: Colors.blueGrey,
        elevation: 2.0,
        title: const Text('Register New Institute'),
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
    backgroundColor: Colors.blueGrey.shade300,
    );
  }

  Widget _buildcontent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.black,
                          child: _imageUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    _imageUrl!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(50)),
                                  width: 100,
                                  height: 100,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ),
                      const Text(
                        'upload your institute Photo',
                        style: TextStyle(
                            fontSize: 16.0, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  child: Column(
                    children: [_buildform()],
                  ),
                ),
              ],
            ),
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
        decoration: const InputDecoration(labelText: 'Institute detaials'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _details = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Institute Address'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _address = value!,
      ),
      TextFormField(
        decoration:
            const InputDecoration(labelText: 'Domian of the institute '),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Domain can\'t be empty',
        onSaved: (value) => _Domain = value!,
      ),
      TextFormField(
        decoration:
            const InputDecoration(labelText: 'Email id of the institute'),
        validator: (value) =>
            value!.isNotEmpty ? null : 'EmailId  can\'t be empty',
        onSaved: (value) => _emailid = value!,
      ),
      CustomRaisedButton(
          color: Colors.white,
          child: CountryCodePicker(
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
          onPressed: () {}),
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
    String? code = countryCode.toString();
    setState(() {
      if (code != "") _countrycode = code;
    });
    print("New Country selected: " + countryCode.toString());
  }
}
