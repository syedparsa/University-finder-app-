import 'package:dream_university_finder_app/Services/Auth.dart';

import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Model.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/validator.dart';

import 'package:flutter/material.dart';




class EmailSignInChangeModel with EmailAndPassValidator,ChangeNotifier {
  EmailSignInChangeModel( {
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSigninformType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String email;
  String password;
  EmailSigninformType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(isLoading: true, submitted: true);

    try {
      //TODO:print emails and passwords

      if (formType == EmailSigninformType.signIn) {
        await auth.SignInWithEmailPass(email,password);
      } else {
        await auth.RegisterUserWithEmail(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }


  String get primarytButtonText {
    return formType == EmailSigninformType.signIn
        ? 'Sign in '
        : 'Creat an account';
  }

  String get secondaryButtonText {
    return formType == EmailSigninformType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool ShowError = submitted && !passValidator.isValid(password);
    return ShowError ? InValidPassErrorText : null;
  }

  String? get EmailErrorText {
    bool ShowError = submitted && !emailValidator.isValid(email);
    return ShowError ? InValidEmailErrorText : null;
  }

  void toggleformType() {
    final formType = this.formType== EmailSigninformType.signIn
        ? EmailSigninformType.register
        : EmailSigninformType.signIn;

    updateWith(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePasword(String password) => updateWith(password: password);



  void updateWith({
    String? email,
    String? password,
    EmailSigninformType? formType,
    bool? isLoading,
    bool? submitted,
  }) {

      this.email= email ?? this.email;
      this.password=password ?? this.password;
      this.formType= formType ?? this.formType;
      this.isLoading= isLoading ?? this.isLoading;
      this.submitted= submitted ?? this.submitted;
      notifyListeners();
  }
}
