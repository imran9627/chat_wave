import 'package:flutter/cupertino.dart';

class ChatModel extends ChangeNotifier {
   String? name;
   String? about;
   String? createdAt;
   String? image;
   String? isOnline;
   String? id;
   String? lastActive;
   String? email;
   String? pushToken;

  ChatModel(
      {this.name,
       this.about,
       this.createdAt,
       this.image,
       this.isOnline,
       this.id,
       this.lastActive,
       this.email,
       this.pushToken});

   static const String keyName = 'name';
   static const String keyAbout = 'about';
   static const String keyImage = 'image';
   static const String keyId = 'id';
   static const String keyCreatedAt = 'createdAt';
   static const String keyIsOnline = 'isOnline';
   static const String keyLastActive = 'lastActive';
   static const String keyEmail = 'email';
   static const String keyPushToken = 'pushToken';


  ChatModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    about = json['about'] ?? "" ;
    createdAt = json['createdAt'] ?? "" ;
    image = json['image'] ?? "" ;
    isOnline = json['isOnline'] ?? "" ;
    id = json['id'] ?? "" ;
    lastActive = json['lastActive'] ?? "" ;
    email = json['email'] ?? "" ;
    pushToken = json['pushToken'] ?? "" ;

  }

  Map<String, dynamic> toMap(){

    final data = <String, dynamic>{};
    data['name'] = name;
    data['about'] = about;
    data['createdAt'] = createdAt;
    data['isOnline'] = isOnline;
    data['id'] = id;
    data['lastActive'] = lastActive;
    data['image'] = image;
    data['email'] = email;
    data['pushToken'] = pushToken;

    return data;
  }
}
