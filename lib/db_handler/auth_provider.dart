

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import '../utils/consts/app_consts.dart';
import 'collection_references.dart';

class AuthProvider extends ChangeNotifier{

 static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  static Future<void> logOut() async {
    DateFormat dateFormat = DateFormat('MMMM d, yyyy');
    DateFormat timeFormat = DateFormat('hh:mm a');
    String formattedDate = dateFormat.format(DateTime.now());
    String formattedTime = timeFormat.format(DateTime.now());
    await DBHandler.fireStoreData
        .collection(Collections.userDataCollection)
        .doc(DBHandler.user.uid)
        .update({'isOnline': '$formattedDate at $formattedTime'});
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

    } catch (e){
      print('//////////////////////////////{someThing went wrong}');
    }
  }

}