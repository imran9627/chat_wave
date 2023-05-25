
import 'dart:io' show Platform;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiPickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onPressed;

  const EmojiPickerWidget(
      {Key? key, required this.controller, Config? config, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmojiPickerWidget(controller: controller,onPressed: onPressed,
        config: Config(columns: 7, emojiSizeMax: 32 * (Platform.isIOS ? 1.3 :1.0)));
  }
}
