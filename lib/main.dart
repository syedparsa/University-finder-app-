
import 'package:dream_university_finder_app/Services/notification_service.dart';
import 'package:dream_university_finder_app/app/Home/Notifications/AwesomeNotificationsService.dart';
import 'package:dream_university_finder_app/app/Registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Services/Auth.dart';
import 'Services/Database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


 /* await NotificationService().init();*/
  await AwesomeNotificationService();
  await Firebase.initializeApp();
 /* final prefs = await SharedPreferences.getInstance();
  var Admin =  prefs.getBool('issssssAdminnnnnnnUniotafkjj');*/
  runApp(MyApp(/*admin:Admin*/));
}

class MyApp extends StatelessWidget {
  MyApp(/*{required this.admin}*/);
  /*final bool? admin;*/
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBase>(
          create: (context) => Auth(),
        ),

        Provider<Database>(
          create: (context) => FirestoreDatabase(),
        ),
      ],
      child: MaterialApp(
        title: 'Education Portal',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home:  RegistrationPage(),
      ),
    );
  }
}
