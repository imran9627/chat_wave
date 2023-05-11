class Messages {
  Messages({
    required this.msg,
    required this.read,
    required this.toId,
    required this.type,
    required this.sent,
    required this.fromId,
  });
  late  String msg;
  late  String read;
  late  String toId;
  late  Type type;
  late  String sent;
  late  String fromId;

  Messages.fromJson(Map<String, dynamic> json){
    msg = json['msg'].toString();
    read = json['read'].toString();
    toId = json['told'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    sent = json['sent'].toString();
    fromId = json['fromId'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = toId;
    data['type'] = type.name;
    data['sent'] = sent;
    data['fromId'] = fromId;
    return data;
  }
}

enum Type {text, image}