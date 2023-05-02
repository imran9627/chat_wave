/*

import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:chat_wave/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomPopUpMenu extends StatelessWidget {
  const CustomPopUpMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 1,
            child: CustomText(
              title: AppConsts.newGroup,
              fontSize: AppTextSize.largeText,
            ),
          ),
          const PopupMenuItem(
              value: 2,
              child: CustomText(
                title: AppConsts.newBroadCast,
                fontSize: AppTextSize.largeText,
              )),
          const PopupMenuItem(
            value: 3,
            child: CustomText(
              title: AppConsts.linkedDevices,
              fontSize: AppTextSize.largeText,
            ),
          ),
          const PopupMenuItem(
            value: 4,
            child: CustomText(
              title: AppConsts.starredMessages,
              fontSize: AppTextSize.largeText,
            ),
          ),
          const PopupMenuItem(
            value: 5,
            child: CustomText(
              title: AppConsts.settings,
              fontSize: AppTextSize.largeText,
            ),
          )
        ];
      },
      onSelected: (int index) {
        switch (index) {
          case 1:
            print('1');
            break;
          case 2:
            print('2');
            break;
          case 3:
            print('3');
            break;
          case 4:
            print('4');
            break;
          case 5:
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ));
        }
      },
    );
  }
}
*/
