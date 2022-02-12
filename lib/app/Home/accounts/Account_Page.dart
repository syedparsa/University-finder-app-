import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/app/Home/accounts/Avatar.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {


  Future<void> _Signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );

      await auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('issssssAdminnnnnnnUniotafkjj');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignout(BuildContext context) async {
    final didrequestSiginout = await ShowAlertDailog(
      context,
      title: 'Logout',
      content: 'Are you sure you want to logout',
      cancelActiontext: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didrequestSiginout == true) {
      _Signout(context);
    }
  }

  Widget _buildUserinfo(User? user) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AvatarPage(
            Photourl: user!.photoURL,
            radius: 37,
          ),
          if (user.displayName != null)
            Text(
              user.displayName!,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
        ],
      ),
    );
  }

  void _deleteUserAccount(AuthBase auth) async {
    try {
      await auth.deleteUserAccount();

      Fluttertoast.showToast(msg: 'Account Deleted Successfully!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login')
        Fluttertoast.showToast(msg: 'Please Login again to Delete Account!');
    }
  }

  void _FeedBack() async {


      Fluttertoast.showToast(msg: 'write us email at syedzeshan786512@gmail.com!');

    }
  void _Contribute() async {


    Fluttertoast.showToast(msg: 'Coming soon');

  }


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Container(
      color: Colors.blueGrey.shade300,
      child: Column(
        children: [
          SizedBox(height: 60.0),
          Row(
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.horizontal(
                  left: Radius.elliptical(5, 10),
                  right: Radius.elliptical(5, 10),
                ),
                color: Colors.black12,
                boxShadow: shadowlist),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildUserinfo(auth.currentUser),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.0),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(5, 10),
                right: Radius.elliptical(5, 10),
              ),
              boxShadow: shadowlist,
            ),
            child: Material(
              color: Colors.black12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),

                      child: ElevatedButton.icon(
                        onPressed: () => _deleteUserAccount(auth),
                        icon:Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 18,
                        ),),
                        label: Text(
                          'Delete Account',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black12),
                            padding:
                                MaterialStateProperty.all(EdgeInsets.only(right:15)),
                            shape:
                                MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                                            right: Radius.elliptical(5, 10) ),
                                        side: BorderSide(
                                            color: Colors.transparent)))),
                      ),

                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(5, 10),
                right: Radius.elliptical(5, 10),
              ),
              boxShadow: shadowlist,
            ),
            child: Material(
              color: Colors.black12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: ElevatedButton.icon(
                      onPressed: () => _FeedBack(),
                      icon:Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                        Icons.message,
                        color: Colors.black,
                        size: 18,
                      ),),
                      label: Text(
                        'Feedback',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black12),
                          padding:
                          MaterialStateProperty.all(EdgeInsets.only(right:15)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                                      right: Radius.elliptical(5, 10) ),
                                  side: BorderSide(
                                      color: Colors.transparent)))),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(5, 10),
                right: Radius.elliptical(5, 10),
              ),
              boxShadow: shadowlist,
            ),
            child: Material(
              color: Colors.black12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: ElevatedButton.icon(
                      onPressed: () => _Contribute(),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Padding(
                          padding: EdgeInsets.only(right: 5),
                          child:Icon(
                          Icons.style,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),),
                      label: Text(
                        'Contribute',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black12),
                          padding:
                          MaterialStateProperty.all(EdgeInsets.only(right:15)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                                      right: Radius.elliptical(5, 10) ),
                                  side: BorderSide(
                                      color: Colors.transparent)))),
                    ),
                  ),

                ],
              ),
            ),
          ),
          SizedBox(height: 80),
          Container(
            margin: EdgeInsets.only(top: 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(5, 10),
                right: Radius.elliptical(5, 10),
              ),
              boxShadow: shadowlist,
            ),
            child: Material(
              color: Colors.black12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: ElevatedButton.icon(
                      onPressed: () => (){},
                      icon:Padding(
                        padding: EdgeInsets.only(right: 5),
                        child:
                      Icon(
                        Icons.favorite,
                        color: Colors.black,
                        size: 18,
                      ),),
                      label: Text(
                        'Tell a Friend',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black12),
                          padding:
                          MaterialStateProperty.all(EdgeInsets.only(right:15)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                                      right: Radius.elliptical(5, 10) ),
                                  side: BorderSide(
                                      color: Colors.transparent)))),
                    ),
                  ),


                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 0.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(
                left: Radius.elliptical(5, 10),
                right: Radius.elliptical(5, 10),
              ),
              boxShadow: shadowlist,
            ),
            child: Material(
              color: Colors.black12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: ElevatedButton.icon(
                      onPressed: () => _FeedBack(),
                      icon: Padding(
                        padding: EdgeInsets.only(right: 5),
                        child:Icon(
                        Icons.help,
                        color: Colors.black,
                        size: 18,
                      ),),
                      label: Text(
                        'Need help?',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black12),
                          padding:
                          MaterialStateProperty.all(EdgeInsets.only(right:15)),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                                      right: Radius.elliptical(5, 10) ),
                                  side: BorderSide(
                                      color: Colors.transparent)))),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Container(
              margin: EdgeInsets.only(top: 100.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.zero,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmSignout(context),
                        icon: Icon(
                          Icons.logout,
                          color: Colors.black,
                          size: 18,
                        ),
                        label: Text(
                          'log out',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.black12),
                            padding:
                            MaterialStateProperty.all(EdgeInsets.only(right:15)),
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                                        right: Radius.elliptical(5, 10) ),
                                    side: BorderSide(
                                        color: Colors.transparent)))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
