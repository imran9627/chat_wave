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

  const CustomListTile(
      {Key? key,
      required this.avatar,
      required this.title,
      required this.subTitle,
      this.onTap,
      this.timeStamp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CustomAvatar(child: avatar),
      title: CustomText(
        title: title,
        fontSize: AppTextSize.largeText,
      ),
      subtitle: CustomText(
        title: subTitle,
      ),
      trailing: timeStamp == null
          ? SizedBox()
          : CustomText(
              title: '$timeStamp',
            ),
    );
  }
}
