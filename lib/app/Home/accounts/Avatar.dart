import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarPage extends StatefulWidget {
  const AvatarPage({Key? key, this.Photourl, required this.radius})
      : super(key: key);
  final String? Photourl;
  final double radius;

  @override
  _AvatarPageState createState() => _AvatarPageState(
        Photourl,
        radius,
      );
}

class _AvatarPageState extends State<AvatarPage> {
  _AvatarPageState(
    this.Photourl,
    this.radius, {
    this.imageFile,
  });

  File? imageFile;
  final String? Photourl;
  final double radius;

  _getFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

  /// Get from Camera
  Future<void> _getFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
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
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black54,
          width: 3.0,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Center(
          child: GestureDetector(
            onTap: () {
              _showPicker(context);
            },
            child: CircleAvatar(
              child: imageFile != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        imageFile!,
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
              radius: radius,
              backgroundColor: Colors.black12,
              backgroundImage:
                  Photourl != null ? NetworkImage(Photourl!) : null,
            ),
          ),
        ),
      ]),
    );
  }
}
