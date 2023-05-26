import 'dart:convert';
import 'dart:io';

import 'package:chat_wave/models/chat_model.dart';
import 'package:chat_wave/models/messages_model.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class DBHandler {
  static final auth = FirebaseAuth.instance;
  static final storage = FirebaseStorage.instance;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static get user => auth.currentUser;
  static FirebaseFirestore fireStoreData = FirebaseFirestore.instance;
  static ChatModel me = ChatModel();

  static Future<List<ChatModel>> userCollection() async {
    List<ChatModel> listOfChat = [];
    QuerySnapshot<Map<String, dynamic>> reference =
    await fireStoreData.collection(Collections.userDataCollection).get();

    for (var document in reference.docs) {
      listOfChat.add(ChatModel.fromJson(document.data()));
    }

    return listOfChat;
  }


  static Future<ChatModel?> getSelfInfo() async {
    DocumentSnapshot<Map<String, dynamic>> selfData = await fireStoreData
        .collection(Collections.userDataCollection)
        .doc(user!.uid)
        .get();
    if (selfData.exists) {
      me = ChatModel.fromJson(selfData.data() ?? {});
      //getPushToken();
      return me;
    } else {
      return await createUser().then((value) => getSelfInfo());
    }
  }

  static Future<void> getPushToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;
        print('////////////pushToken/////////$token');
      }
    });
  }

  static Future<void> sendPushNotification(ChatModel chatModel, String msg) async {
    try {
      var body = {

        "to": chatModel.pushToken,
        "notification": {
          "title": chatModel.name,
          "body": msg
        }
      };

      var response = await post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          body: jsonEncode(body),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders
                .authorizationHeader: "AAAAag0Xe40:APA91bHMKhLPY0EF-G43Fms9zQLEMrYZCtVEH6Ne40-GRixK7sZS-QMRmDLxMYJVxA4EibKO-3fsfLXck1QlP6aWVZMv-VAqJQrn_TXyryqSVSSs2s_qppugW_no_o72u5GPq8vWmnBC"

          }

      );
      print('//////////////////response ////////${response.statusCode}');
    } catch (e){
      print('someThing went wrong');
    }
  }

  static Future<bool> userExists() async {
    return (await fireStoreData
        .collection(Collections.userDataCollection)
        .doc(user!.uid)
        .get())
        .exists;
  }

  static Future<bool> createUser() async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final chatUser = ChatModel(
        name: user!.displayName ?? '',
        id: user!.uid ?? '',
        about: 'Hello There',
        email: user!.email ?? '',
        image: user!.photoURL ?? '',
        createdAt: time,
        lastActive: time,
        isOnline: 'Online',
        pushToken: '');

    await fireStoreData
        .collection(Collections.userDataCollection)
        .doc(user!.uid)
        .set(chatUser.toMap());
    return true;
  }

  static Future<List<ChatModel>> getAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> usersData = await fireStoreData
        .collection(Collections.userDataCollection)
        .where('id', isNotEqualTo: user!.uid)
        .get();
    List<ChatModel> listOfUsers = [];
    for (var document in usersData.docs) {
      listOfUsers.add(ChatModel.fromJson(document.data()));
    }

    return listOfUsers;
  }

  static Future<void> updateUser(String name, String about,
      String image) async {
    return (await fireStoreData
        .collection(Collections.userDataCollection)
        .doc(user!.uid)
        .update({'name': name, 'about': about, 'image': image}));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatModel chatModel) {
    return fireStoreData
        .collection('Chats/${getConversationId(chatModel.id!)}/Messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static String getConversationId(String id) {
    return user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';
  }

  static Future<void> sendMessage(ChatModel chatModel, String msg,
      Type type) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    final Messages messages = Messages(
        msg: msg,
        read: '',
        toId: chatModel.id!,
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = fireStoreData
        .collection('Chats/${getConversationId(chatModel.id!)}/Messages');
    ref.doc(time).set(messages.toJson()).then((value) {
      sendPushNotification(chatModel, msg);
    });
  }
////////////////////
  static Future<void> updateReadMessage(Messages msg) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    fireStoreData
        .collection('Chats/${getConversationId(msg.fromId)}/Messages')
        .doc(msg.sent)
        .update({'read': time});
  }


  static Future<Messages> getLastMessage(ChatModel chatModel) async {
    Map<String, dynamic>? data;
    try {
      QuerySnapshot querySnapshot = await fireStoreData
          .collection('Chats/${getConversationId(chatModel.id!)}/Messages')
          .orderBy(FieldPath
          .documentId,
          descending: true) // Replace 'collectionName' with your collection's name
          .limit(
          1) // Replace 'documentId' with the ID of the document you want to retrieve
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Document(s) found
        QueryDocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        data = documentSnapshot.data() as Map<String, dynamic>;
        // Do something with the document data
        print('${data}///////////get message');
      } else {
        // No documents found in the collection
        print('No documents found');
      }
    } catch (e) {
      // Error retrieving the document
      print('Error getting document: $e');
    }
    return Messages.fromJson(data!);
  }

  static Future<void> chatImage(ChatModel chatModel, List<XFile> images) async {
    for (var file in images) {
      final ext = file.path
          .split('.')
          .last;
      final ref = storage.ref().child(
          'Chats/ ${getConversationId(chatModel.id!)}/${DateTime
              .now()
              .millisecondsSinceEpoch
          }$ext');
      await ref.putFile(
          File(file.path), SettableMetadata(contentType: 'chatImages/$ext'));
      final imageUrl = await ref.getDownloadURL();
      await sendMessage(chatModel, imageUrl, Type.image);
    }
  }

}
