
import 'package:dream_university_finder_app/Services/notification_service.dart';
import 'package:dream_university_finder_app/app/Registration_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Services/Auth.dart';
import 'Services/Database.dart';
import 'app/Home/MainLanding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


 /* await NotificationService().init();*/
 /* await Awesomenotificationservice();*/
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
