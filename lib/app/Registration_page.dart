import 'package:dream_university_finder_app/app/Landing_Page.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/sign_in_Button.dart';
import 'package:flutter/material.dart';

import 'Host_Landing_Page.dart';
class RegistrationPage extends StatelessWidget {
  const RegistrationPage({Key? key}) : super(key: key);




 Future<void> _SignCall(BuildContext context) async {


    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>  const LandingPage(),
        fullscreenDialog: true,
      ),
    );
  }

 Future<void> _RegisterCall(BuildContext context) async {

     await  Navigator.of(context).push(
       MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const HostLandingPage(),


        ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueGrey,

        title: const Text(
          'My Education Portal',
          textAlign: TextAlign.center,
        ),
        elevation: 10.0,
      ),
      body: Container(

        color: Colors.blueGrey.shade300,
        child: Column(children: [
          SizedBox(height: 200),

          _buildContent(context)],),
      ),

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
    SignInButton(textcolor: Colors.white,
    text: ' Student',
    onPressed: ()=>_SignCall(context), color:  Colors.blueGrey, borderRadius: 20,),


      const SizedBox(height: 8.0),


      const Text(
        'or',
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        textAlign: TextAlign.center,
      ),


      const SizedBox(height: 8.0),
      SignInButton(textcolor: Colors.white,
        text: ' Institute',
        borderRadius: 20,
        onPressed: ()=>_RegisterCall(context), color:  Colors.blueGrey,),

    ],),);



}
  Widget _buildHeader(){


    return  const Text(
      'Register As ',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );

  }

}
