import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Avatar extends StatelessWidget {
  final double pictureHeight;
  final String imageURL;
  final Color? borderColor;
  const Avatar(
      {Key? key,
      this.borderColor,
      required this.pictureHeight,
      required this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: pictureHeight / 2,
        backgroundColor: borderColor ?? primaryColor,
        child: CircleAvatar(
          radius: (pictureHeight / 2) - 5,
          backgroundImage: NetworkImage(imageURL),
        ));
  }
}
