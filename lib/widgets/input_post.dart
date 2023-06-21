

import 'package:flutter/cupertino.dart';

import '../utils/colors.dart';
import 'avatar.dart';
import 'button.dart';

class InputPost extends StatelessWidget {
  final String avatarURL;
  const InputPost({Key? key, required this.avatarURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Avatar(
            pictureHeight: 60,
            borderSize: 3,
            imageURL: avatarURL)
      ),
      Expanded(
          flex: 4,
          child: Button(
            onPressed: () {},
            text: "¿Que vas a comer?",
            borderSide: const BorderSide(color: gray01Color, width: 2),
            borderRadius: BorderRadius.circular(10),
            size: Size.fromHeight(45),
            fontSize: 14,
            textColor: gray03Color,
          )
      )
    ]);
  }
}
