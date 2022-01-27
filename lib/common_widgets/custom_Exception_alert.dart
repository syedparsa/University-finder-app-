

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Show_alert_dialog.dart';

Future<void>? showExceptionAlert(
BuildContext context,{
required String title,
required Exception exception,
}
) =>ShowAlertDailog(
  context,
  title: title,
  content: _message(exception),
  defaultActionText: 'OK',
);

String? _message(Exception exception){
  if (exception is FirebaseAuthException){
    return exception.message;
  }
else {
    return exception.toString();
  }

}