import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextOverflow? overflow;
  final int? maxLine;
  final TextAlign? alignment;

  const CustomText(
      {Key? key,
      required this.title,
      this.textColor = Colors.black,
      this.fontSize = AppTextSize.mediumText,
      this.fontWeight = FontWeight.normal,
      this.overflow,
      this.alignment,
      this.maxLine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: fontSize, color: textColor, fontWeight: fontWeight),
      overflow: overflow,
      maxLines: maxLine,
      textAlign: TextAlign.start,
    );
  }
}
