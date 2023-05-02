import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ice_helphand/services/database.dart';
import 'package:overlay_support/overlay_support.dart';
import '../models/myuser.dart';
import 'dart:io';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _fcm = FirebaseMessaging.instance;

  MyUser? _userfromfirebaseuser(User? user) {
    return user != null ? MyUser(user.uid) : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userfromfirebaseuser);
  }

  Future<MyUser?> signInWithGoogle(BuildContext context) async {
    User? user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          toast('The account already exists with a different credential',
              context: context);
        } else if (e.code == 'invalid-credential') {
          toast('Error occurred while accessing credentials. Try again',
              context: context);
        }
      } catch (e) {
        // handle the error here
      }
    }

    return _userfromfirebaseuser(user);
  }

//signin with email and
  Future<MyUser?> signinWithEmailAndPass(
      String email, String pass, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: pass.trim());
      User? user = userCredential.user;

      //function to store token
      DatabaseService databaseService = DatabaseService(user!.uid);
      final token = await _fcm.getToken();
      databaseService.storeToken(token: token);

      return _userfromfirebaseuser(user);
    } on FirebaseAuthException catch (e) {
      // print('xyz');
      if (e.code == 'invalid-email') {
        // print(e.code);
        // toast(Text('The email address is badly formatted'));
        toast('invalid-email', context: context);
      } else if (e.code == 'user-not-found') {
        toast('user-not-found', context: context, duration: Toast.LENGTH_SHORT);
      } else if (e.code == 'wrong-password') {
        toast('wrong-password', context: context, duration: Toast.LENGTH_SHORT);
      } else {
        toast('Login Failed', context: context, duration: Toast.LENGTH_SHORT);
      }
    }
  }

  //signup with email and pass
  Future<MyUser?> signupWithEmailAndPass(
      {required String email,
      required String pass,
      required String username,
      required String image,
      required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: email.trim(), password: pass.trim());
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${userCredential.user!.uid}.jpg');
      print("Reference of storage $ref");
      await ref.putFile(File(image));

      final url = await ref.getDownloadURL();

      User? user = userCredential.user;
      DatabaseService databaseService = DatabaseService(user!.uid);
      databaseService.createmyUser(
        username: username,
        email: email,
        image: url,
      );
      final token = await _fcm.getToken();
      databaseService.storeToken(token: token);
      return _userfromfirebaseuser(user);
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      if (e.code == 'invalid-email') {
        toast('invalid-email', context: context);
      } else {
        toast('Registration Failed',
            context: context, duration: Toast.LENGTH_SHORT);
      }
      // return e;
    }
  }

  Future signout() async {
    return await _auth.signOut();
  }
}
