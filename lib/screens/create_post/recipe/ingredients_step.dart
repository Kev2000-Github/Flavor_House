

import 'package:flavor_house/utils/text_themes.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/modal/text_input.dart';

class IngredientStep extends StatefulWidget {
  final List<String> ingredients;
  final Function(List<String> updatedIngredients) onChangeIngredients;
  const IngredientStep({super.key, required this.ingredients, required this.onChangeIngredients});

  @override
  State<IngredientStep> createState() => _IngredientStepState();
}

class _IngredientStepState extends State<IngredientStep> {

  @override
  void initState() {
    super.initState();
  }

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            TextInputModalContent(onSend: (String ingredient) {
              widget.onChangeIngredients([...widget.ingredients, ingredient]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Ingrese por lo menos 1 ingrediente', style: DesignTextTheme.get(type: TextThemeEnum.darkMedium)),
        const SizedBox(height: 30),
        ...List.generate(
            widget.ingredients.length,
                (index) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: ElevatedContainer(
                        content: widget.ingredients[index])),
                ElevatedButton(
                  onPressed: () {
                    List<String> ingredients = [...widget.ingredients];
                    ingredients.removeAt(index);
                    widget.onChangeIngredients(ingredients);
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
