import 'package:cloud_firestore/cloud_firestore.dart';

class DBHandler {
  static CollectionReference userCollection({required String collection}) {
    return FirebaseFirestore.instance.collection(collection);
  }
}
