import 'package:dream_university_finder_app/common_widgets/custom_raised_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialSignInButton extends CustomRaisedButton {
  SocialSignInButton({
    required String assetName,
    required String text,
    required Color color,
    required Color textcolor,
    required VoidCallback onPressed,
  }) : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(assetName),
              Text(
                text,
                style: TextStyle(color: textcolor, fontSize: 15.0),
              ),
              Opacity(opacity: 0, child: Image.asset(assetName)),
            ],
          ),
          height: 40.0,
          onPressed: onPressed,
          color: color,
        );
}
