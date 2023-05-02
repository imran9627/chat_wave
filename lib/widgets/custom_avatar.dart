import 'package:chat_wave/utils/consts/app_consts.dart';
import 'package:flutter/material.dart';

class CustomAvatar extends StatelessWidget {
  final Widget? child;
  final double? radius;
  final ImageProvider? imageProvider;
  const CustomAvatar({Key? key, this.child, this.radius, this.imageProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 3.0,
          )),
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageProvider,
        backgroundColor: Colors.transparent,
        child: child,
      ),
    );
  }
}
