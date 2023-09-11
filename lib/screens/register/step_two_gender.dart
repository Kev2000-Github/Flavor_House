
import 'package:flutter/cupertino.dart';

import '../../utils/colors.dart';
import '../../widgets/button.dart';

class StepGender extends StatelessWidget {
  final Function(String?) onGenderSelect;
  const StepGender({Key? key, required this.onGenderSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(children: [
          const Text(
            "¿Cual es tu genero?",
            style: TextStyle(
                color: gray04Color, fontSize: 22, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 28),
          Button(
            onPressed: () => onGenderSelect("MAN"),
            text: "Hombre",
            size: Size.fromHeight(50),
            borderSide: BorderSide.none,
            backgroundColor: gray02Color,
            fontSize: 16,
          ),
          const SizedBox(height: 24),
          Button(
            onPressed: () => onGenderSelect("WOMAN"),
            text: "Mujer",
            size: Size.fromHeight(50),
            borderSide: BorderSide.none,
            backgroundColor: gray02Color,
            fontSize: 16,
          ),
          const SizedBox(height: 24),
          Button(
            onPressed: () => onGenderSelect("NONE"),
            text: "Prefiero no decirlo",
            size: Size.fromHeight(50),
            borderSide: BorderSide.none,
            backgroundColor: gray02Color,
            fontSize: 16,
          )
        ]));
  }
}