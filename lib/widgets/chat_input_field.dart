import 'dart:io';
import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/chat_model.dart';
import 'package:chat_wave/models/messages_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../repository/firebase_services/services.dart';

class CustomChatInputBar extends StatefulWidget {
  final ChatModel user;

  const CustomChatInputBar({Key? key, required this.user}) : super(key: key);

  @override
  State<CustomChatInputBar> createState() => _CustomChatInputBarState();
}

class _CustomChatInputBarState extends State<CustomChatInputBar> {
  late TextEditingController _controller;
  List<XFile> images = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('\\\\\\\\\\\\\\\builder');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () {
                    print('////////////////////////emoji');
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      images.isNotEmpty
                          ? SizedBox(

                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height *
                            0.09,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,

                          //  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            print('\\\\\\\\\\\\\\\builder');
                            return Card(
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                     width: MediaQuery.of(context).size.width *
                                                0.2,
                                            height:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                      fit: BoxFit.fill,
                                      File(images[index].path))),
                            );
                          },
                        ),
                      )
                          : const SizedBox(),
                      TextField(
                        controller: _controller,
                        maxLines: null,
                        minLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    images =
                    await FirebaseDataSource.multipleImages()!;

                    print('\\\\\\\\\\\\\\\images ${images}');
                    setState(() {});
                  },
                ),
                _controller.text.isEmpty
                    ? IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () async {
                    XFile? image =
                    await FirebaseDataSource.captureImageFromCamera();
                    images.add(image!);
                    setState(() {});
                    // await DBHandler.chatImage(
                    //
                    //     widget.user, images);
                  },
                )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
        //const SizedBox(width: 8.0),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: CircleAvatar(
            radius: 20,
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  DBHandler.sendMessage(
                      widget.user, _controller.text.toString(), Type.text);
                  _controller.text = '';
                } else {
                  DBHandler.chatImage(widget.user, images);
                  images = [];

                  setState(() {

                  });
                }
                // Handle send button press
              },
            ),
          ),
        ),
      ],
    );
  }
}
