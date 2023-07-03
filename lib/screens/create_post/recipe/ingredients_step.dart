

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/modal/text_input.dart';

class IngredientStep extends StatefulWidget {
  const IngredientStep({super.key});

  @override
  State<IngredientStep> createState() => _IngredientStepState();
}

class _IngredientStepState extends State<IngredientStep> {
  List<String> ingredients = [];

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            TextInputModalContent(onSend: (String ingredient) {
              setState(() {
                ingredients.add(ingredient);
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
            ingredients.length,
                (index) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: ElevatedContainer(
                        content: ingredients[index] ?? "Hubo un error...")),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ingredients.remove(ingredients[index]);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(5),
                      backgroundColor: redColor),
                  child: const Icon(
                    Icons.delete,
                    color: whiteColor,
                    size: 20,
                  ),
                )
              ],
            )),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(
                child: ElevatedContainer(
                    content: "Ingrese un ingrediente y sus medidas")),
            ElevatedButton(
              onPressed: () => onOpenTextInput(context),
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(10),
                  backgroundColor: primaryColor),
              child: const Icon(Icons.add, color: whiteColor),
            )
          ],
        )
      ],
    );
  }
}
