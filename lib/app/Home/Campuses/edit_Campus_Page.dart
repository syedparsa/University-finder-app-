import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/Campus_Model.dart';
import 'package:dream_university_finder_app/app/Home/models/Host_Models.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'package:provider/provider.dart';

class EditCampusPage extends StatefulWidget {
  final Database database;
  final Campuses? camp;

  const EditCampusPage({Key? key, required this.database, required this.camp})
      : super(key: key);

  static Future<void> Show(BuildContext context,
      {Database? database, Campuses? camp, Hosts? host}) async {
    final database=Provider.of<Database>(context,listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context) => EditCampusPage(
          database: database,
          camp: camp,
        ),
        fullscreenDialog: false,
      ),
    );
  }

  @override
  _EditCampusPageState createState() => _EditCampusPageState();
}

class _EditCampusPageState extends State<EditCampusPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name = "";
  String? _country = "";
  String? _city = "";
  String? _address = "";
  String? _details = "";
  FirebaseStorage storage = FirebaseStorage.instance;

  int? _CountryRanking = 0;
  int? _worldRanking = 0;
  String? _website;
  String? _imageUrl;
  String? _url;
  String? _countrycode;

  // _deleteImage() async {
  //   if (_imageUrl != null) {
  //     final auth = Provider.of<AuthBase>(context, listen: false);
  //     final db = Provider.of<Database>(context, listen: false);
  //
  //     String uid = auth.currentUser!.uid;
  //     await db.deleteImage('uploads/' .jpg');
  //     setState(() {
  //       _imageUrl = null;
  //     });
  //     // Fluttertoast.showToast(msg: 'Image Deleted!');
  //   }
  // }

  @override
  void initState() {
    super.initState();

    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    if (widget.camp != null) {
      _name = widget.camp!.name;
      _address = widget.camp!.address;
      _country = widget.camp!.country;
      _city = widget.camp!.city;
      _details = widget.camp!.details;
      _CountryRanking = widget.camp!.CountryRanking;
      _worldRanking = widget.camp!.worldRanking;
      _imageUrl=widget.camp!.imageurl;
      _countrycode=widget.camp!.countrycode;
      _website=widget.camp!.website;
      _url=widget.camp!.url;

    }
    String? url;
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      url = await db.downloadImage('uploads/'+widget.camp!.id! +'.jpg');
      if( url != null && url!.isNotEmpty){

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

  // Future uploadImageToFirebase(BuildContext context,var _image) async {
  //   final auth = Provider.of<AuthBase>(context, listen: false);
  //   String uid = auth.currentUser!.uid;
  //   String fileName = "$uid.jpg";
  //   var firebaseStorageRef =
  //    FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   var  uploadTask =await  firebaseStorageRef.putFile(_image);
  //   var taskSnapshot =await   uploadTask.ref.getDownloadURL();
  //   setState(() {
  //     _imageUrl = taskSnapshot;
  //   });
  // }
String? id ;
  _updateImage(var _image) async {
    id = widget.camp?.id ?? DocumentIDfromCurrentDate();
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
        final camps = await widget.database.CampusesStream().first;
        final allNames = camps.map((camp) => camp.name).toList();
        if (widget.camp != null) {
          allNames.remove(widget.camp!.name);
        }

        if (allNames.contains(_name)) {
          ShowAlertDailog(context,
              defaultActionText: 'ok',
              title: 'Name already used',
              content: 'Please choose different name');
        } else {

          final camp = Campuses(
            url: _url,
            website: _website,
            countrycode: _countrycode,
              imageurl: _imageUrl,
              name: _name,
              id: id,
              address: _address,
              details: _details,
              city: _city,
              country: _country,
              CountryRanking: _CountryRanking,
              worldRanking: _worldRanking);
          await widget.database.SetCampus(camp);
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
        title: Text(widget.camp == null
            ? 'Register New Campus'
            : 'Edit Campus Details'),
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
            child: Container(
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
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
        decoration: const InputDecoration(labelText: 'Campus name'),
        validator: (value) => value!.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value!,
      ),
      const SizedBox(
        height: 2.0,
      ),
      SizedBox(
        width: 400,
        height: 100,
        child: CountryCodePicker(
          searchDecoration: const InputDecoration(labelText: 'Choose country'),
          showDropDownButton: true,
          backgroundColor: Colors.white54,
          onChanged: _onCountryChange,
          hideMainText: false,
          showFlagMain: true,
          showFlag: true,
          initialSelection: 'Hu',
          hideSearch: true,
          showCountryOnly: true,
          showOnlyCountryWhenClosed: true,
          alignLeft: true,
        ),
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'website '),
        validator: (value) =>
        value!.isNotEmpty ? null : 'web address can\'t be empty',
        onSaved: (value) => _website = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Country '),
        validator: (value) =>
        value!.isNotEmpty ? null : 'campus domain can\'t be empty',
        onSaved: (value) => _url = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Country '),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Country can\'t be empty',
        onSaved: (value) => _country = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'City '),
        validator: (value) =>
            value!.isNotEmpty ? null : 'City name can\'t be empty',
        onSaved: (value) => _city = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Location'),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Address can\'t be empty',
        onSaved: (value) => _address = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Campus Details '),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Details can\'t be empty',
        onSaved: (value) => _details = value!,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'World-Wide Ranking'),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'value can\'t be empty',
        onSaved: (value) => _worldRanking = int.tryParse(value!) ?? 0,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Country Ranking'),
        keyboardType: const TextInputType.numberWithOptions(
            signed: false, decimal: false),
        validator: (value) =>
            value!.isNotEmpty ? null : 'Value can\'t be empty',
        onSaved: (value) => _CountryRanking = int.tryParse(value!) ?? 0,
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
