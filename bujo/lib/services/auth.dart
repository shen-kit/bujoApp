// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'An account with that email already exists';
      } else if (e.code == 'invalid-email') {
        return 'Email address is invalid';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(credential.user);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No account exists with that email';
      } else if (e.code == 'wrong-password') {
        return 'Password incorrect';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      return e.toString();
    }
  }

  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      return e.toString();
    }
  }

  Future deleteAccountPermanently() async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('Print Error: User must log in again to delete their account');
        return 'Must log in again to delete account';
      }
    } catch (e) {
      print(e);
    }
  }
}
