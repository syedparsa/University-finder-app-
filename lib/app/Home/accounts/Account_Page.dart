import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/app/Home/accounts/Avatar.dart';
import 'package:dream_university_finder_app/common_widgets/Show_alert_dialog.dart';
import 'package:dream_university_finder_app/configuration/helper_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  double xoffset = 0;
  double yoffset = 0;
  double scalefactor = 1;
  bool isdraweropen = false;

  Future<void> _Signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(
        context,
        listen: false,
      );

      await auth.signOut();
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
                  style: const TextStyle(color: Colors.white,
                      fontSize: 15),
                ),



        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return
     Container(



        color: Colors.blueGrey.shade300,
        child: Column(
          children: [


                 SizedBox(height: 60.0),


               Row(
                 children:const [

                   Expanded(

                     child: Padding(
                       padding: EdgeInsets.only(left: 20),
                       child: Text('Settings',textAlign: TextAlign.left,
                  style:
                  TextStyle(fontWeight: FontWeight.bold,fontSize: 30,color: Colors.white),),
                     ),
                   ),
               ],),

                 Container(

                  margin: EdgeInsets.only(top:7),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                        right: Radius.elliptical(5, 10),
                      ),
                      color: Colors.black12,
                      boxShadow: shadowlist

                  ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          Expanded(child:
                        _buildUserinfo(auth.currentUser),  ),
                      ],


                    ),

                ),
            SizedBox(height: 40.0),
            Container(


              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                  right: Radius.elliptical(5, 10),

                ),

                boxShadow: shadowlist,),

              child: Material(

                color:  Colors.black12,
                child:

                Row(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(

                      padding: EdgeInsets.only(left:15),
                      child: IconButton(
                        icon: Icon(Icons.person,size: 40,), onPressed: () {  },
                      ),
                    ),


                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Profile',textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                          ),),
                      ),
                    ),


                  ],),



              ),



            ),

            Container(

              margin: EdgeInsets.only(top: 0.5),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                  right: Radius.elliptical(5, 10),

                ),

                boxShadow: shadowlist,),

              child: Material(

                color:  Colors.black12,
                child:

                Row(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(

                      padding: EdgeInsets.only(left:15),
                      child: IconButton(
                        icon: Icon(Icons.message,size: 40,color: Colors.black,), onPressed: () {  },
                      ),
                    ),

                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('FeedBack',textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                          ),),
                      ),
                    ),


                  ],),



              ),



            ),
            Container(

              margin: EdgeInsets.only(top: 0.5),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                  right: Radius.elliptical(5, 10),

                ),

                boxShadow: shadowlist,),

              child: Material(

                color:  Colors.black12,
                child:

                Row(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(

                      padding: EdgeInsets.only(left:15),
                      child: IconButton(
                        icon: Icon(Icons.style,size: 40,color: Colors.black,), onPressed: () {  },
                      ),
                    ),

                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Contribution',textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                          ),),
                      ),
                    ),


                  ],),



              ),



            ),

            SizedBox(height: 80),
            Container(

              margin: EdgeInsets.only(top: 0.5),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                  right: Radius.elliptical(5, 10),

                ),

                boxShadow: shadowlist,),

              child: Material(

                color:  Colors.black12,
                child:

                Row(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Padding(

                      padding: EdgeInsets.only(left:15),
                      child: IconButton(
                        icon: Icon(Icons.favorite,size: 40,color: Colors.black,), onPressed: () {  },
                      ),
                    ),

                    Expanded(
                      flex: 10,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('Tell a Friend',textAlign: TextAlign.right,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                          ),),
                      ),
                    ),


                  ],),



              ),



            ),
            Container(


              margin: EdgeInsets.only(top: 0.5),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.horizontal(left: Radius.elliptical(5, 10),
                    right: Radius.elliptical(5, 10),

                  ),

                  boxShadow: shadowlist,),

              child: Material(

                color:  Colors.black12,
                child:

                        Row(

                        crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                            Padding(

                             padding: EdgeInsets.only(left:15),
                             child: IconButton(
                               icon: Icon(Icons.help_center,size: 40,), onPressed: () {  },
                       ),
                           ),


                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('need Help',textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                              ),),
                          ),
                        ),


                      ],),



                    ),



              ),






            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Container(


                margin: EdgeInsets.only(top: 100.0),
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.zero,


                  ),

                child:

                  Row(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Material(
                        color:  Colors.transparent,
                        child: Padding(
                          padding: EdgeInsets.all( 10),
                          child: IconButton(
                            onPressed:()=> _confirmSignout(context),
                            icon: Icon(Icons.logout,size: 40,) ,),
                        ),
                      ),


                    ],),



                ),
            ),








          ],),
      );

  }


}
