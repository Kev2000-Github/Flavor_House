import 'package:flavor_house/widgets/avatar.dart';
import 'package:flavor_house/widgets/button.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 20),
      child: Column(children: [
        Row(children: [
          Expanded(
              flex: 1,
              child: Avatar(
                pictureHeight: 60,
                borderSize: 3,
                imageURL:
                "https://i.pinimg.com/originals/a6/58/32/a65832155622ac173337874f02b218fb.png",
              )
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
        ])
      ])
    );
  }
}
