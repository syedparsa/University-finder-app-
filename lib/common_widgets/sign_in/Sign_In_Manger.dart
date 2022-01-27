import 'dart:async';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInManger{
  SignInManger({required this.isLoading, required this.auth});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;


 Future<User?> _signin(Future<User?> Function() SigninMethod) async{
   try{
    isLoading.value=true;
     return await SigninMethod();
   }
   catch(e){
     isLoading.value=false;
  rethrow;
   }


 }




  Future<User?> signInAnonymously()=>_signin(auth.signInAnonymously);
  Future<User?>signInWithGoogle()=>_signin(auth.signInWithGoogle);
  Future<User?> FacebookLogIn()=>_signin(auth.FacebookLogIn);


}