import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/messages_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  late bool isMe;
  final Messages document;

  ChatBubble({
    Key? key,
    required this.document,
  }) : super(key: key);

  String getFormatted(BuildContext context, String time){
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  @override
  Widget build(BuildContext context) {
    isMe = document.fromId == DBHandler.user.uid;

    return Padding(
      padding: EdgeInsets.only(
        top: 12.0,
        right: isMe ? 8 : MediaQuery.of(context).size.width * 0.3,
        left: isMe ? MediaQuery.of(context).size.width * 0.3 : 8,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(

            child: Column(
              crossAxisAlignment:isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(document.type == Type.image ? 4 :15),
                  decoration: BoxDecoration(
                      color: isMe ? Colors.green : Colors.grey,
                      borderRadius: isMe
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20))
                          : const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                      border: Border.all(color: Colors.blue, width: 1)),
                  child: isMe
                      ? (document.type == Type.text
                      ? Text(
                    document.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: null,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                      width: MediaQuery.of(context).size.width*0.6,
                      height: MediaQuery.of(context).size.height*0.4,
                    fit: BoxFit.fill,
                    imageUrl: document.msg,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                   // errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                      )
                  )
                      : (document.type == Type.text
                      ? Text(
                    document.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    maxLines: null,
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                        child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width*0.6,
                    height: MediaQuery.of(context).size.height*0.4,
                    imageUrl: document.msg,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                   // errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                      )
                  ),

                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.15,
                  child: isMe ? FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children:  [

                        Text(getFormatted(context, document.sent),style: const TextStyle(color: Colors.black54),),
                         Icon(Icons.done_all_rounded,color: document.read.isEmpty ?  Colors.black54 : Colors.blue),
                      ],
                    ),
                  ) :
                 receiverTime(context)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget receiverTime(BuildContext context){
    if(document.read.isEmpty){
      DBHandler.updateReadMessage(document);
      print('updated status//////////////');
    }
    return  Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text( getFormatted(context, document.sent),style:  TextStyle(color: Colors.black54, fontSize: MediaQuery.of(context).size.width*0.024),),
    );
  }
}
