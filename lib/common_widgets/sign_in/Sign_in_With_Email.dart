import 'package:flutter/material.dart';


import 'Email_SignIn_BlocBased.dart';
import 'Sign_In_With_Email_Forms_Statefull.dart';

class EmailSignIn extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff123456),
        title: const Text(
          'Sign In',
          textAlign: TextAlign.center,
        ),
        elevation: 10.0,
      ),
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: SignInWithEmailFormsblocBased.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }


}
