import 'dart:ffi';

import 'package:dream_university_finder_app/Services/Auth.dart';

import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Email_SignIn_BlocBased.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Sign_In_Manger.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Sign_in_With_Email.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class InstituteSignInPage extends StatelessWidget {
  const InstituteSignInPage({Key? key, required this.manger, required this.isLoading}) : super(key: key);
  final SignInManger manger;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_,isLoading,__) => Provider<SignInManger>(
          create: (_) => SignInManger(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManger>(
            builder: (_, manger, __) => InstituteSignInPage(manger: manger, isLoading: isLoading.value,),
          ),
        ),
      ),
    );
  }

  void _SignInWithEmail(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (context)=>EmailSignIn(),
    ),
    );

  }

  void _showSignInError(BuildContext context,Exception exception){
    if( exception is FirebaseAuthException && exception.code=='ERROR_ABORTED_BY_USER' ){
      return;
    }
    showExceptionAlert(
      context,
      title: 'Sign In Failed',
      exception: exception,


    );
  }


  @override
  Widget build(BuildContext context) {
    final bloc=Provider.of<SignInManger>(context,listen: false);
    return Scaffold(


      body: EmailSignIn(),

      backgroundColor: Colors.grey[200],
    );
  }


  Widget _buildContent(BuildContext context ) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    SizedBox(
    height:50.0, child: _buildHeader()),

    const SizedBox(height: 48.0),
    SocialLoginButton(buttonType: SocialLoginButtonType.generalLogin,
    onPressed: isLoading?()=> null:()=>_SignInWithEmail(context),
    ),
    ],),
    );
  }
  Widget _buildHeader(){
    if (isLoading){

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
