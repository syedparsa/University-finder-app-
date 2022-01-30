
import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';

import 'package:dream_university_finder_app/common_widgets/custom_Exception_alert.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Sign_In_Manger.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import 'Email_Sign_In_Form_type.dart';

class InstituteSignInPage extends StatefulWidget {
  const InstituteSignInPage({Key? key,  this.manger, this.model,  this.db, this.isLoading}) : super(key: key);
  final SignInManger? manger;
  final EmailSignInModel? model;
  final bool? isLoading;
  final Database? db;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (_) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
          builder: (_, model, __) => InstituteSignInPage(
              model: model,
              db: db) //every time called when notify listener called
      ),
    );
  }

  @override
  _InstituteSignInPageState createState() => _InstituteSignInPageState();
}

class _InstituteSignInPageState extends State<InstituteSignInPage> {


  

   final TextEditingController _emailController = TextEditingController();
   final TextEditingController _nameController = TextEditingController();
   final TextEditingController _passwordController = TextEditingController();
   final FocusScopeNode _node = FocusScopeNode();

   EmailSignInModel? get model => widget.model;

   Database? get db => widget.db;


   bool? isLoading;






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
   void dispose() {
     _emailController.dispose();
     _node.dispose();
     _passwordController.dispose();
     super.dispose();
   }
   Future<bool> checkIfUserExists(String email) async {
     final users = await db!.usersStream().first;
     final allEmails = users.map((user) => user.email).toList();
     if (!allEmails.contains(email)) {
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
   Future<void> _submit() async {
     try {
       bool success = false;
       if (model!.formType == EmailSignInFormType.signIn) {
         if (await checkIfUserExists(model!.email)) {
           if (await canLogin(model!.email,model!.isAdmin)) {
             success = await model!.submit(context);
           } else {
             Fluttertoast.showToast(msg: 'Unauthorized  attempt made!');
           }
         } else {
           if (model!.isAdmin) {
             Fluttertoast.showToast(msg: 'Unauthorized attempt!');
           } else {
             success = await model!.submit(context, ifExists: true);
           }
         }
       } else {
         success = await model!.submit(context);
       }
       if (success) {
         if (model!.formType == EmailSignInFormType.forgotPassword) {
           Fluttertoast.showToast(msg: 'Reset password link has been sent!');
           _updateFormType(EmailSignInFormType.signIn);
         }
       }
     } on Exception catch (e) {
       _showSignInError(context, e);
       _emailController.clear();
       _passwordController.clear();
       _nameController.clear();
     }
   }

   void _updateFormType(EmailSignInFormType formType) {
     model!.updateFormType(formType);
     _emailController.clear();
     _passwordController.clear();
     _nameController.clear();
   }


  Widget _buildEmailTextField() {
    return TextFormField(
      autofillHints: [AutofillHints.email],
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'user@mailbox.com',
        errorText: model!.emailErrorText,
        enabled: !model!.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      keyboardAppearance: Brightness.light,
      onChanged: model!.updateEmail,
      onEditingComplete: _emailEditingComplete,
      inputFormatters: <TextInputFormatter>[
        model!.emailInputFormatter,
      ],
    );
  }

  Widget _buildNameTextField() {
    return TextFormField(
      autofillHints: [AutofillHints.name],
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Name',
        errorText: model!.nameErrorText,
        enabled: !model!.isLoading,
      ),
      autocorrect: false,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      keyboardAppearance: Brightness.light,
      onChanged: model!.updateName,
      onEditingComplete: _emailEditingComplete,
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      autofillHints: [AutofillHints.password],
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: model!.passwordLabelText,
        errorText: model!.passwordErrorText,
        enabled: !model!.isLoading,
        suffixIcon: IconButton(
          alignment: Alignment.bottomRight,
          icon: model!.showPassword
              ? Icon(Icons.visibility)
              : Icon(Icons.visibility_off),
          color: model!.showPassword ? Colors.teal : Colors.grey,
          onPressed: () {
            model!.updateWith(showPassword: !model!.showPassword);
          },
        ),
      ),
      obscureText: !model!.showPassword,
      autocorrect: false,
      textInputAction: TextInputAction.done,
      keyboardAppearance: Brightness.light,
      onChanged: model!.updatePassword,
      onEditingComplete: _passwordEditingComplete,
    );
  }

   void _emailEditingComplete() {
     if (model!.canSubmitEmail) {
       _node.nextFocus();
     }
   }

   void _passwordEditingComplete() {
     if (!model!.canSubmitEmail) {
       _node.previousFocus();
       return;
     }
     _submit();
   }




   List<Widget> _buildChildren() {
    return [
      if (model!.formType == EmailSignInFormType.register) ...<Widget>[
        _buildNameTextField(),
      ],
      _buildEmailTextField(),
      if (model!.formType != EmailSignInFormType.forgotPassword) ...<Widget>[
        SizedBox(height: 8.0),
        _buildPasswordTextField(),
      ],
      SizedBox(height: 8.0),
      SocialLoginButton(
        buttonType: SocialLoginButtonType.generalLogin,
        backgroundColor: Colors.teal,
        disabledBackgroundColor: Colors.blueGrey.shade300,
        text: model!.primaryButtonText,
        fontSize: 20,
        height: 44,
        borderRadius: 25,
        onPressed: model!.canSubmit ? _submit : null,
      ),
      if (!model!.isAdmin) ...<Widget>[
        SizedBox(height: 8.0),
        TextButton(
          child:
          Text(model!.secondaryButtonText!, style: TextStyle(fontSize: 15)),
          onPressed: model!.isLoading
              ? null
              : () => _updateFormType(model!.secondaryActionFormType!),
        )
      ],
      if (model!.formType == EmailSignInFormType.signIn)
        TextButton(
          child: Text('Forgot password?', style: TextStyle(fontSize: 15)),
          onPressed: model!.isLoading
              ? null
              : () => _updateFormType(EmailSignInFormType.forgotPassword),
        ),


    ];
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
      body: Padding(
        padding: EdgeInsets.fromLTRB(16, 100, 16, 0),
        child: Center(


          child: Column(
              children:[



                Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                  color: Colors.white,
                  borderOnForeground: true,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AutofillGroup(
                      onDisposeAction:
                      model!.formType == EmailSignInFormType.forgotPassword
                          ? AutofillContextAction.commit
                          : AutofillContextAction.commit,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildChildren(),
                      ),
                    ),
                  ),
                ),
               


              ],),


        ),
      ),
    );
  }







}
