import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_Exception_alert.dart';
import '../forms_submit_Button.dart';
import 'EmailSignIn_Bloc.dart';
import 'email_signinform.dart';

class SignInWithEmailFormsblocBased extends StatefulWidget {
  SignInWithEmailFormsblocBased({required this.bloc});

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) =>
            SignInWithEmailFormsblocBased(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _SignInWithEmailFormsblocBasedState createState() =>
      _SignInWithEmailFormsblocBasedState();
}

class _SignInWithEmailFormsblocBasedState
    extends State<SignInWithEmailFormsblocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailfocunode = FocusNode();
  final FocusNode _passfocunode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailfocunode.dispose();
    _passfocunode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      //TODO:print emails and passwords
      await widget.bloc.submit();
     /* Navigator.of(context).pop();*/
    } on FirebaseAuthException catch (e) {
      showExceptionAlert(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _toggleForm() {
    widget.bloc.toggleformType();
    _emailController.clear();
    _passController.clear();
  }

  void _EmailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email)
        ? _passfocunode
        : _emailfocunode;
    FocusScope.of(context).requestFocus(_passfocunode);
  }

  List<Widget> _buildChilderns(EmailSignInModel model) {
    return [
      _buildEmailtext(model),
      SizedBox(height: 8.0),
      _buildPasswordtext(model),
      SizedBox(height: 8.0),
      FormSubmissionButton(
        text: model.primarytButtonText,
        onPressed: model.canSubmit ? _submit : () => null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? _toggleForm : null,
      ),
    ];
  }

  TextField _buildPasswordtext(EmailSignInModel model) {
    return TextField(
      focusNode: _passfocunode,
      controller: _passController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePasword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailtext(EmailSignInModel model) {
    return TextField(
      focusNode: _emailfocunode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.EmailErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _EmailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChilderns(model),
            ),
          );
        });
  }
}
