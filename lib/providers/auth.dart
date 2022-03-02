import 'dart:io';

import 'package:chat/modules/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  var token = '';
  var uId = '';
  bool isLoading = false;
  late UserCredential authResult;

  Future<void> submitAuthFormLogin(
      String em, String pass, BuildContext ctx) async {
    try {
      isLoading = true;
      authResult = await auth.signInWithEmailAndPassword(
        email: em,
        password: pass,
      );
      uId = FirebaseAuth.instance.currentUser!.uid;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      var message = "error";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      isLoading = false;
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ));
      notifyListeners();
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> submitAuthFormSignUp(String em, String pass, String userName,
      File image, BuildContext ctx) async {
    UserCredential authResult;
    try {
      isLoading = true;
      authResult = await auth.createUserWithEmailAndPassword(
        email: em,
        password: pass,
      );
      final refImage = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authResult.user!.uid + '.jpg');

      await refImage.putFile(image);

      final imageUrl = await refImage.getDownloadURL();

      FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user!.uid)
          .set(UserModel(
            authResult.user!.uid,
            em,
            pass,
            userName,
            'write your bio ...',
            imageUrl,
            '',
            false,
            {
              'works at': '',
              'lives in': '',
              'from': '',
              'relationship': '',
              'education': {'college': '', 'high school': ''},
              'contact info': {
                "email": "",
                "mobile number": "",
              },
              'basic info': {
                'gender': '',
                'birthday': '',
                'languages': [],
              },
            },
            [],
            [],
            [],
            [],
        []
          ).toMap());
      uId = authResult.user!.uid.toString();
      token = authResult.credential!.token.toString();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      var message = "error";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      }
      else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      isLoading = false;
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ));
      print(e.toString());
      notifyListeners();
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    isLoading = false;
    uId = '';
    notifyListeners();
  }

  Future<void> verification(context) async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("check your email !"),
        backgroundColor: Colors.purple,
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error"),
        backgroundColor: Colors.red,
      ));
    });
  }
}
