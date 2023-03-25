import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDataSource {
  static Future<void> addUser(
      {required String userName,
      required int contact,
      required BuildContext context}) {
    CollectionReference user =
        FirebaseFirestore.instance.collection(AppConsts.userCollection);
    return user.add({'userName': userName, 'contact': contact}).then((value) {
      return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('user added successfully')));
    }).catchError((error) {
      return ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed: $error')));
    });
  }
}
