import 'package:dream_university_finder_app/common_widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    required String text,
    required Color color,
    required Color textcolor,
    required double borderRadius,
    required VoidCallback onPressed,
  }) : super(
          child: Text(text, style: TextStyle(color: textcolor, fontSize: 15.0)),
          height: 40.0,
          onPressed: onPressed,
          color: color,
          borderRadius: borderRadius,
        );
}
