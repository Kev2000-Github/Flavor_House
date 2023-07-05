import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Avatar extends StatelessWidget {
  final double pictureHeight;
  final Image? image;
  final Color? borderColor;
  final double borderSize;
  const Avatar(
      {Key? key,
      this.borderColor,
        this.borderSize = 5,
      required this.pictureHeight,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: pictureHeight / 2,
        backgroundColor: borderColor ?? primaryColor,
        child: CircleAvatar(
          radius: (pictureHeight / 2) - borderSize,
          backgroundImage: image?.image ?? const AssetImage("assets/images/user_avatar.png"),
        ));
  }
}
