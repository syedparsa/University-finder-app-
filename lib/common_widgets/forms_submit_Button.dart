import 'package:dream_university_finder_app/common_widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FormSubmissionButton extends CustomRaisedButton {
  FormSubmissionButton({
    required String text,
    required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          height: 44.0,
          color: Colors.indigo,
          borderRadius: 4.0,
          onPressed: onPressed,
        );
}
