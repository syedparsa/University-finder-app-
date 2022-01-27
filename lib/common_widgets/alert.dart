import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<bool?> showAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelActionText,
  AlertType alertType = AlertType.info,
  bool useCupertinoType = false,
  required String defaultActionText,
}) async {
  if (Platform.isIOS || useCupertinoType) {
    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          if (cancelActionText != null)
            CupertinoDialogAction(
              child: Text(cancelActionText),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
            ),
          CupertinoDialogAction(
            child: Text(defaultActionText),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
          ),
        ],
      ),
    );
  }
  return Alert(
    context: context,
    title: title,
    desc: content,
    type: alertType,
    buttons: [
      if (cancelActionText != null)
        DialogButton(
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop(false),
          child: Text(
            cancelActionText,
            style: TextStyle(color: Colors.white),
          ),
        ),
      DialogButton(
        child: Text(
          defaultActionText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
      ),
    ],
  ).show();
}

Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      alertType: AlertType.error,
      title: title,
      content: _message(exception),
      defaultActionText: 'OK',
    );

Future<bool?> showQuestionAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? cancelActionText,
  required String defaultActionText,
}) =>
    showAlertDialog(
        context: context,
        alertType: AlertType.warning,
        title: title,
        content: content,
        defaultActionText: defaultActionText,
        cancelActionText: cancelActionText);

String _message(dynamic exception) {
  if (exception is FirebaseException) {
    return exception.message ?? exception.toString();
  }
  if (exception is PlatformException) {
    return exception.message ?? exception.toString();
  }
  return exception.toString();
}

// TODO: Revisit this
// NOTE: The full list of FirebaseAuth errors is stored here:
// https://github.com/firebase/firebase-ios-sdk/blob/2e77efd786e4895d50c3788371ec15980c729053/Firebase/Auth/Source/FIRAuthErrorUtils.m
// These are just the most relevant for email & password sign in:
// Map<String, String> _errors = {
//   'ERROR_WEAK_PASSWORD': 'The password must be 8 characters long or more.',
//   'ERROR_INVALID_CREDENTIAL': 'The email address is badly formatted.',
//   'ERROR_EMAIL_ALREADY_IN_USE':
//       'The email address is already registered. Sign in instead?',
//   'ERROR_INVALID_EMAIL': 'The email address is badly formatted.',
//   'ERROR_WRONG_PASSWORD': 'The password is incorrect. Please try again.',
//   'ERROR_USER_NOT_FOUND':
//       'The email address is not registered. Need an account?',
//   'ERROR_TOO_MANY_REQUESTS':
//       'We have blocked all requests from this device due to unusual activity. Try again later.',
//   'ERROR_OPERATION_NOT_ALLOWED':
//       'This sign in method is not allowed. Please contact support.',
// };
