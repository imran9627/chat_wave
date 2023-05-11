import 'package:chat_wave/db_handler/collection_references.dart';
import 'package:chat_wave/models/chat_model.dart';
import 'package:flutter/material.dart';

class CustomChatInputBar extends StatefulWidget {
    final ChatModel user;
   const CustomChatInputBar({Key? key, required this.user}) : super(key: key);

  @override
  State<CustomChatInputBar> createState() => _CustomChatInputBarState();
}

class _CustomChatInputBarState extends State<CustomChatInputBar> {
   late TextEditingController _controller;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.emoji_emotions),
                  onPressed: () {

                  },
                ),
                 Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    minLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () {

                  },
                ),
               _controller.text.isEmpty ? IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    // Handle camera button press
                  },
                ): const SizedBox(),

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
                if(_controller.text.isNotEmpty){
                  DBHandler.sendMessage(widget.user, _controller.text.toString());
                  _controller.text = '';
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
