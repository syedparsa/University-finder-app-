import 'package:flutter/material.dart';

class CustomRaisedButton extends StatelessWidget {
  final Widget? child;
  final double borderRadius;
  final Color color;
  final double height;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final String? label;

  const CustomRaisedButton(
      {this.height = 50.0,
      required this.color,
       this.child,
      this.backgroundColor = Colors.grey,
      this.borderRadius = 2.0,
      required this.onPressed, this.label});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,

        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(borderRadius),
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return backgroundColor;
              }
              return color;
            },
          ),

        ),

        onPressed: onPressed,
      ),
    );
  }
}
