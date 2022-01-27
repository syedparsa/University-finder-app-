import 'package:dream_university_finder_app/Services/Auth.dart';
import 'package:dream_university_finder_app/Services/Database.dart';
import 'package:dream_university_finder_app/app/Home/Home_Page.dart';
import 'package:dream_university_finder_app/common_widgets/sign_in/Institute_Sign__in_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HostLandingPage extends StatelessWidget {
  const HostLandingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(
      context,
      listen: false,
    );
    return StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return InstituteSignInPage.create(context);
            }

            return Provider<Database>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: const HomePage());
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
