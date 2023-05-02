import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DBHandler {

  static CollectionReference userCollection({required String collection}) {
    return FirebaseFirestore.instance.collection(collection);
  }

  static Reference addUserImage({required String imgPath}) {
    final storageRef = FirebaseStorage.instance.ref();
    Reference imgRef = storageRef.child(imgPath);
    return imgRef;
  }

  static FirebaseAuth phoneAuthentication(){
      FirebaseAuth auth = FirebaseAuth.instance;
      return auth;
  }
}
