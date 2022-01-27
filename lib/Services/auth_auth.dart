import 'package:dream_university_finder_app/Services/AUTHBASE.dart';
import 'package:dream_university_finder_app/Services/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
class authentication implements Base {
  final _firebaseAuth = FirebaseAuth.instance;
  var localAuth = LocalAuthentication();

  bool? _isCurrentUserAdmin;

  MyUser? _myUser;

  void setCurrentUserAdmin(bool value) {
    _isCurrentUserAdmin = value;
  }

  bool? get isCurrentUserAdmin => _isCurrentUserAdmin;

  MyUser? get myUser => _myUser;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password, bool isAdmin) async {
    final userCredentials = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password));
    _isCurrentUserAdmin = isAdmin;
    return userCredentials.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password, bool isAdmin, String name) async {
    try {
      final userCredentials = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      _isCurrentUserAdmin = isAdmin;
      await userCredentials.user?.updateDisplayName(name);
      return userCredentials.user;
    } catch (e) {
      return null;
    }
  }

  Future<void> terminateGoogleSignIn() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  Future<List?> initializeGoogleSignIn() async {
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      if (googleAuth.idToken != null) {
        return [googleAuth, googleUser.email];
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message: 'Missing Google ID Token');
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signInWithGoogle(
      GoogleSignInAuthentication googleAuth, bool isAdmin) async {
    try {
      var userCredentials = await _firebaseAuth
          .signInWithCredential(GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      ));
      _isCurrentUserAdmin = isAdmin;
      return userCredentials.user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    _isCurrentUserAdmin = false;
    switch (response.status) {
      case FacebookLoginStatus.success:
        try {
          final accessToken = response.accessToken;
          final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken!.token),
          );

          return userCredential.user;
        } on FirebaseAuthException catch (e) {
          throw FirebaseAuthException(
            code: e.code,
            message: e.message,
          );
        } on Exception catch (_) {
          throw FirebaseAuthException(
              code: 'Internal_error',
              message: 'Something Went Wrong! /nPlease Try Again.');
        }
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign In aborted by User',
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: response.error!.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    await terminateGoogleSignIn();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  void setMyUser(MyUser value) => _myUser = value;

  @override
  Future<void> deleteUserAccount() async {
    await _firebaseAuth.currentUser!.delete();
  }

  Future<bool> isBiometricsAvailable() async {
    var isDeviceSupported = await localAuth.isDeviceSupported();
    if (isDeviceSupported) {
      return await localAuth.canCheckBiometrics;
    }
    return false;
  }

  Future<bool> authenticateLocally() async {
    return await localAuth.authenticate(
      stickyAuth: true,
      useErrorDialogs: true,
      localizedReason: 'Please Authenticate with Biometrics to continue!',
    );
  }
}
