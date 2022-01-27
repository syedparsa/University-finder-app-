

import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Model.dart';
import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../forms_submit_Button.dart';




class SignInWithEmailFormsStateful extends StatefulWidget with EmailAndPassValidator {


  @override
  _SignInWithEmailFormsStatefulState createState() => _SignInWithEmailFormsStatefulState();
}

class _SignInWithEmailFormsStatefulState extends State<SignInWithEmailFormsStateful> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailfocunode = FocusNode();
  final FocusNode _passfocunode = FocusNode();

  String get _email => _emailController.text;

  String get _password => _passController.text;
  EmailSigninformType _formtype = EmailSigninformType.signIn;
  bool _submitted = false;
  bool _isLoading = false;
  bool? _isButtonDisabled = true;

  @override
  void dispose(){
    _emailController.dispose();
    _passController.dispose();
    _emailfocunode.dispose();
    _passfocunode.dispose();
    super.dispose();
  }
  Future<void> _submit() async {
    setState(() {
      _submitted = false;
      _isLoading = true;
    });


    try {
      //TODO:print emails and passwords
      final auth=Provider.of<AuthBase>(context,listen: false,);

      if (_formtype == EmailSigninformType.signIn) {
        await auth.SignInWithEmailPass(_email, _password);
      } else {
        await auth.RegisterUserWithEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlert(context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleForm() {
    setState(() {
      _formtype = _formtype == EmailSigninformType.signIn
          ? EmailSigninformType.register
          : EmailSigninformType.signIn;
    });
    _emailController.clear();
    _passController.clear();
  }

  void _EmailEditingComplete() {
    FocusScope.of(context).requestFocus(_passfocunode);
  }

  List<Widget> _buildChilderns() {
    final primarytext = _formtype == EmailSigninformType.signIn
        ? 'Sign in '
        : 'Creat an account';
    final secondarytext = _formtype == EmailSigninformType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool? submitEnable = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_isLoading;
    //bool submitEnable = _email.isNotEmpty && _password.isNotEmpty;

    return [
      _buildEmailtext(),
      SizedBox(height: 8.0),
      _buildPasswordtext(),
      SizedBox(height: 8.0),
      FormSubmissionButton(
        text: primarytext,
        onPressed: submitEnable ? _submit : ()=> null,

      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondarytext),
        onPressed: !_isLoading ? _toggleForm : null,
      ),
    ];
  }

  TextField _buildPasswordtext() {
    bool ShowError = _submitted && !widget.passValidator.isValid(_password);
    return TextField(
      focusNode: _passfocunode,
      controller: _passController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: ShowError ? widget.InValidPassErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: (password) => _updatestate,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailtext() {
    bool ShowError = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailfocunode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: ShowError ? widget.InValidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (email) => _updatestate,
      onEditingComplete: _EmailEditingComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChilderns(),
      ),
    );
  }

  void _updatestate() {
    print('email:$_email password:$_password');
    setState(() {});
  }
}
