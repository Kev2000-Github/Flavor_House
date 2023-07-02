

import 'package:flutter/cupertino.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;
import '../utils/colors.dart';
import 'avatar.dart';
import 'button.dart';

class InputPost extends StatelessWidget {
  final Image? avatar;
  const InputPost({Key? key, required this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Avatar(
            pictureHeight: 60,
            borderSize: 2,
            image: avatar,)
      ),
      Expanded(
          flex: 4,
          child: Button(
            onPressed: () {
              Navigator.pushNamed(context, routes.createpost);
            },
            text: "¿Que vas a comer?",
            borderSide: const BorderSide(color: gray01Color, width: 2),
            borderRadius: BorderRadius.circular(10),
            size: const Size.fromHeight(45),
            fontSize: 14,
            textColor: gray03Color,
          )
      )
    ]);
  }
}
