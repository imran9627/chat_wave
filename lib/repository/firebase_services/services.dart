import 'dart:developer';
import 'dart:io';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/views/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../views/mobile_otp_screen.dart';

class FirebaseDataSource extends ChangeNotifier {
  String? fetchImagePath;
  bool isFetched = false;

/*
  Future<void> addUser(
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
*/

 static Future<File?> pickedImage() async {
    final imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    //Select Image
    image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
    var file = File(image.path);
    return file;
    }
    return null;


   /* log('/////////////////////////////////////////////////////imagePath :${image.path}');
    if (file.path.isNotEmpty) {
      //Upload to Firebase
     String url = await uploadImage(imageFile:file );
     //DBHandler.updateUser(name, about, image);
      //await DBHandler.addUserImage(imgPath: 'images/').putFile(url);

      notifyListeners();
    } else {
      print('No Image Path Received');*/
   // }
  }

 static Future<String> uploadImage({var imageFile}) async {
    var snapshot = FirebaseStorage.instance.ref(DBHandler.user!.uid);
      await  snapshot.putFile(imageFile);
    var downloadUrl = await snapshot.getDownloadURL();
    print('.............Image URL.........$downloadUrl');
    return downloadUrl;
  }
  
/*  static Future<void> verifyOtp(String phoneNumber, BuildContext context) async{
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
      phoneNumber: '+923106338186',
      verificationCompleted: (PhoneAuthCredential credential) async{
        await auth.signInWithCredential(credential);
        //print('..............credential $credential');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  HomePage(),
            ));
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('............................................The provided phone number is not valid.');
        }
        
      },
      codeSent: (String verificationId, int? resendToken) async{
        String smsCode = 'xxxx';

        // Create a PhoneAuthCredential with the code
        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        print('.......Credntials.....${credential}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(),));
        // Sign the user in (or link) with the credential
        //await auth.signInWithCredential(credential);
        
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        
      },
    );
  }*/
}
