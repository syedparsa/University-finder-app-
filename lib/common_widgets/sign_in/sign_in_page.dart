import 'dart:ffi';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Sign_In_Manger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class SignInPage extends StatelessWidget {
   SignInPage({Key? key,this.db, required this.manger, required this.isLoading})
      : super(key: key);
  final SignInManger manger;
  final bool isLoading;
  Database? db;

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




  Future<bool> checkIfUserExists(String email) async {
    final users = await db?.usersStream().first;
    final allEmails = users?.map((user) => user.email).toList();
    if (!allEmails!.contains(email)) {
      return false;
    }
    return true;
  }

  Future<bool> canLogin(String email, bool isAdmin) async {
    final users = await db!.usersStream().first;
    final allUsers = users.map((user) => user).toList();
    bool _isAdmin =
    allUsers.where((user) => user.email == email).first.isAdmin!;
    if (_isAdmin == isAdmin) {
      return true;
    }
    return false;
  }


  Widget _buildHeader() {
    if (isLoading) {
      return SizedBox(
        height: 80,
        child: Center(
            child: LoadingAnimationWidget.staggeredDotWave(
              color: Colors.blueGrey,
              size: 65,
            )),
      );
    }
    return SizedBox(
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          ' Sign up!/Sign In\n  to continue',
          style: TextStyle( color: Colors.white,fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
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

           const Text(
             'or',
             style: TextStyle(fontSize: 14.0, color: Colors.black),
             textAlign: TextAlign.center,
           ),
           const SizedBox(height: 8.0),
           SocialLoginButton(
             text: 'Go anonymous',


             onPressed:
             isLoading ? () => null : () => _SignInAnonymously(context),
              buttonType: SocialLoginButtonType.generalLogin,
           ),
         ],
       ),
     );
   }
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SignInManger>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text(
          'Dream University Finder',
          textAlign: TextAlign.center,
        ),
        elevation: 10.0,
      ),
      body: Container(
        color: Colors.blueGrey.shade300,
        child:Column(
        children: [
         SizedBox(height:200),
        _buildContent(context)],),),

    );
  }




}
