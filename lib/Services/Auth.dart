import 'package:dream_university_finder_app/app/Home/models/user_Model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  Stream<User?> authStateChanges();

  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<User?> signInWithGoogle();

  Future<User?> FacebookLogIn();

  void setEnduser(EndUser user);

  Future<User?> RegisterUserWithEmail(String email, String password);

  Future<User?> SignInWithEmailPass(String email, String password);

  Future<void> signOut();

  Future<void> deleteUserAccount();

  EndUser? get endUser;
}

class Auth implements AuthBase {
  final _fireAuth = FirebaseAuth.instance;

  EndUser? _endUser;

  EndUser? get endUser => _endUser;

  void setEnduser(EndUser user) => _endUser = user;

  @override
  Stream<User?> authStateChanges() => _fireAuth.authStateChanges();

  @override
  User? get currentUser => _fireAuth.currentUser;

  @override
  Future<void> deleteUserAccount() async {
    await _fireAuth.currentUser!.delete();
  }

  @override
  Future<User?> signInAnonymously() async {
    final userCredentials = await _fireAuth.signInAnonymously();
    return userCredentials.user;
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential =
            await _fireAuth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'Missing Google ID Token');
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by User',
      );
    }
  }

  @override
  Future<User?> FacebookLogIn() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        final userCredentials = await _fireAuth.signInWithCredential(
          FacebookAuthProvider.credential(accessToken!.token),
        );
        return userCredentials.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER', message: "Sign in Aborted by user");
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: "ERROR FACEBOOK LOGIN FAILED",
          message: response.error!.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<User?> SignInWithEmailPass(String email, String password) async {
    final userCredentails = await _fireAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));

    return userCredentails.user;
  }

  @override
  Future<User?> RegisterUserWithEmail(String email, String password) async {
    final userCredentails = await _fireAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    return userCredentails.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookSignIn = FacebookLogin();
    await facebookSignIn.logOut();
    await _fireAuth.signOut();
  }
}
