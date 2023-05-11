import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/widgets/custom_text.dart';
import 'package:flutter/material.dart';

import 'custom_avatar.dart';

class CustomListTile extends StatelessWidget {
  final Widget avatar;
  final String title;
  final String subTitle;
  final String? timeStamp;
  final VoidCallback? onTap;
  final Color? backColor;
  final double? elevation;
  final EdgeInsetsGeometry? contentPadding;

  const CustomListTile(
      {Key? key,
      required this.avatar,
      required this.title,
      required this.subTitle,
      this.onTap,
        this.elevation =2,
        this.backColor,
        this.contentPadding,
      this.timeStamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: onTap,
         textColor: backColor,
        contentPadding: contentPadding,
        leading: CustomAvatar(child: avatar),
        title: CustomText(
          title: title,
          fontSize: AppTextSize.largeText,
        ),
        subtitle: CustomText(
          title: subTitle,textColor: Colors.black54,
        ),
        trailing: timeStamp == null
            ? const SizedBox()
            : CustomText(
                title: '$timeStamp',
              ),
      ),
    );
  }
}
