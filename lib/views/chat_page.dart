import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/chat_model.dart';
import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/widgets/chat_bubble_style.dart';
import 'package:chat_wave/widgets/chat_input_field.dart';
import 'package:chat_wave/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/messages_model.dart';

class ChatPage extends StatefulWidget {
  final ChatModel document;

  const ChatPage({Key? key, required this.document}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DateFormat dateFormat = DateFormat('MMMM d, yyyy');
  DateFormat timeFormat = DateFormat('hh:mm a');
  late String formattedDate;
  late String formattedTime;

  @override
  void initState() {
    super.initState();

  }

  String seenStatus(String status){
    formattedDate = dateFormat.format(DateTime.now());
    formattedTime = timeFormat.format(DateTime.now());

    var currentDate = DateTime.now().day;

    if(status != 'Online'){
      print('inside the not online block');
      var seenDay = int.parse(status.substring(4,6));
      print('after seen day');
      if(status.contains(formattedDate)){
        return 'Last seen today ${status.replaceAll(formattedDate, '').trim()}';
      }else if(currentDate-1 == seenDay){
        return 'Last seen yesterday${status.substring(12,status.length)}';
      }else{
        return status;
      }
    }else{
      return status;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 25,
          toolbarHeight: 60,
          backgroundColor: AppColors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context,true);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          title: CustomListTile(
              elevation: 0,
              backColor: Colors.transparent,
              contentPadding: const EdgeInsets.only(left: 0),
              avatar: CircleAvatar(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedNetworkImage(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
                    height: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
                    fit: BoxFit.fill,
                    imageUrl: widget.document.image!,
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.person),
                    placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              title: widget.document.name!,
              subTitle: seenStatus(widget.document.isOnline!)
          )),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(

                  child: StreamBuilder(
                    stream: DBHandler.getAllMessages(widget.document),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),);
                      } else if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        return ListView.builder(
                          reverse: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return ChatBubble(document: Messages.fromJson(
                                data[index].data()),);
                          },
                        );
                      } else {
                        return const Center(
                            child: Text('Some Thing went wrong'));
                      }
                    },
                  )),
              CustomChatInputBar(user: widget.document,)
            ]),
      ),
    );
  }
}
