import 'dart:ffi';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Email_SignIn_BlocBased.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Sign_In_Manger.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manger, required this.isLoading})
      : super(key: key);
  final SignInManger manger;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManger>(
          create: (_) => SignInManger(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManger>(
            builder: (_, manger, __) => SignInPage(
              manger: manger,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseAuthException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlert(
      context,
      title: 'Sign In Failed',
      exception: exception,
    );
  }

  Future<void> _SignInAnonymously(BuildContext context) async {
    try {
      await manger.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _SignInWithGoogle(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);

    try {
      await manger.signInWithGoogle();
      var user = EndUser(email: manger.auth.currentUser!.email);
      var users = await db.usersStream().first;
      var userr = users
          .where((element) => element.email == manger.auth.currentUser!.email);
      if (userr.length == 1) {
        manger.auth.setEnduser(userr.elementAt(0));
      } else {
        manger.auth.setEnduser(user);
        db.setUser(user, manger.auth.currentUser!.uid);
      }
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _SignInWithFacebook(BuildContext context) async {
    final db = Provider.of<Database>(context, listen: false);
    try {
      var user = EndUser(email: manger.auth.currentUser!.email);
      var users = await db.usersStream().first;
      var userr = users
          .where((element) => element.email == manger.auth.currentUser!.email);
      if (userr.length == 1) {
        manger.auth.setEnduser(userr.elementAt(0));
      } else {
        manger.auth.setEnduser(user);
        db.setUser(user, manger.auth.currentUser!.uid);
      }
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  void _SignInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => SignInWithEmailFormsblocBased.create(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInManger>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff123456),
        title: const Text(
          'My Education Portal',
          textAlign: TextAlign.center,
        ),
        elevation: 10.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50.0, child: _buildHeader()),

          const SizedBox(height: 48.0),
          SocialLoginButton(
            buttonType: SocialLoginButtonType.google,
            onPressed:
                isLoading ? () => null : () => _SignInWithGoogle(context),
          ),
          const SizedBox(height: 8.0),
          //SocialSignInButton(
          //text: 'Sign in with facebook',
          //color: Color(0xFF334D92),
          //textcolor: Colors.black87,
          //onPressed: isLoading ? ()=> null: ()=>
          //
          SocialLoginButton(
            buttonType: SocialLoginButtonType.facebook,
            onPressed:
                isLoading ? () => null : () => _SignInWithFacebook(context),

            //assetName: 'images/facebook-logo.png',
          ),

          const SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with Email',
            color: Colors.teal,
            textcolor: Colors.black87,
            onPressed: isLoading ? () => null : () => _SignInWithEmail(context),
            borderRadius: 20,
          ),
          const SizedBox(height: 8.0),

          const Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            color: Colors.lime,
            textcolor: Colors.black87,
            onPressed:
                isLoading ? () => null : () => _SignInAnonymously(context),
            borderRadius: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      'Sign in ',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
