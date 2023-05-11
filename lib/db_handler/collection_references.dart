import 'package:chat_wave/models/chat_model.dart';
import 'package:chat_wave/models/messages_model.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';


class DBHandler {
  static final auth = FirebaseAuth.instance;

  static get user => auth.currentUser;
  static FirebaseFirestore fireStoreData = FirebaseFirestore.instance;
  static late ChatModel me;

  static Future<List<ChatModel>> userCollection() async {
    List<ChatModel> listOfChat = [];
    QuerySnapshot<Map<String, dynamic>> reference =
        await fireStoreData.collection(Collections.userDataCollection).get();

    for (var document in reference.docs) {
      listOfChat.add(ChatModel.fromJson(document.data()));
    }

    return listOfChat;
  }

  /*static Reference addUserImage({required String imgPath}) {
    final storageRef = FirebaseStorage.instance.ref();
    Reference imgRef = storageRef.child(imgPath);
    return imgRef;
  }*/

  static Future<ChatModel?> getSelfInfo() async {
    DocumentSnapshot<Map<String, dynamic>> selfData = await fireStoreData
        .collection(Collections.userDataCollection)
        .doc(user!.uid)
        .get();
    if (selfData.exists) {
      me = ChatModel.fromJson(selfData.data() ?? {});
      return me;
    } else {
      return await createUser().then((value) => getSelfInfo());
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
    final time = DateTime.now().millisecondsSinceEpoch.toString();
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

  static Future<void> updateUser(
      String name, String about, String image) async {
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
    var a ='ab';

    print('////////////${a.hashCode}/////////hashcode////////${user.uid.hashCode <= id.hashCode}');
    print('/////////////////////uid////////${user.uid.hashCode }');
    print('/////////////////////id////////${ id.hashCode}');
    return user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';
  }

  static Future<void> sendMessage(ChatModel chatModel, String msg) async {

    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages messages = Messages(
        msg: msg,
        read: '',
        toId: chatModel.id!,
        type: Type.text,
        sent: time,
        fromId: user.uid);

    final ref = fireStoreData
        .collection('Chats/${getConversationId(chatModel.id!)}/Messages');
    ref.doc(time).set(messages.toJson());
  }

  static Future<void> updateReadMessage(Messages msg)async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    fireStoreData
        .collection('Chats/${getConversationId(msg.fromId)}/Messages').doc(msg.sent).update({'read':time});
  }
}
