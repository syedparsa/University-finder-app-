import 'dart:async';

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/email_signinform.dart';



class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController =
  StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    UpdateWith(isLoading: true, submitted: true);

    try {
      //TODO:print emails and passwords

      if (_model.formType == EmailSigninformType.signIn) {
        await auth.SignInWithEmailPass(_model.email, _model.password);
      } else {
        await auth.RegisterUserWithEmail(_model.email, _model.password);
      }
    } catch (e) {
      UpdateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleformType() {
    final formType = _model.formType =
    _model.formType == EmailSigninformType.signIn
        ? EmailSigninformType.register
        : EmailSigninformType.signIn;

    UpdateWith(
      email: '',
      password: '',
      formType: formType,
      submitted: false,
      isLoading: false,
    );
  }

  void updateEmail(String email) => UpdateWith(email: email);

  void updatePasword(String password) => UpdateWith(password: password);

  void UpdateWith({
    String? email,
    String? password,
    EmailSigninformType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    //udate Model
    _model = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted);
    //add update model to the _modelcontroller
    _modelController.add(_model);
  }
}
