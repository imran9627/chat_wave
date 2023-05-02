class UserPersonalInfo {
  String? imageUrl;
  String? userName;
  String? about;
  String? contact;

  UserPersonalInfo(
      {required this.imageUrl,
      required this.userName,
      required this.about,
      required this.contact});

  static String keyImageUrl = 'ImageUrl';
  static String keyUserName = 'userName';
  static String keyAbout = 'about';
  static String keyContact = 'contact';

  Map<String, dynamic> toMap(){
  return{
     keyImageUrl:imageUrl,
     keyUserName:userName,
     keyAbout:about,
     keyContact:contact
  };
  }
}
