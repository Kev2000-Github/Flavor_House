

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/post/recipe_preparation.dart';
import '../../../utils/colors.dart';
import '../../../widgets/button.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/modal/text_input.dart';

class PreparationStep extends StatefulWidget {
  const PreparationStep({super.key});

  @override
  State<PreparationStep> createState() => _PreparationStepState();
}

class _PreparationStepState extends State<PreparationStep> {
  List<RecipePreparationStep> preparationSteps = [];

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            TextInputModalContent(onSend: (String description) {
              setState(() {
                RecipePreparationStep step =
                RecipePreparationStep(description, null);
                preparationSteps.add(step);
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(
            preparationSteps.length,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 3,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            width: 90,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: preparationSteps[index]
                                        .picture
                                        .image,
                                    fit: BoxFit.cover)),
                          ))),
                  const SizedBox(width: 20),
                  Flexible(
                      flex: 7,
                      child: ElevatedContainer(
                          content: preparationSteps[index].description ??
                              "Hubo un error...")),
                ],
              ),
            )),
        Button(
          text: "Agregar paso",
          onPressed: () => onOpenTextInput(context),
          borderSide: null,
          backgroundColor: primaryColor,
          textColor: whiteColor,
          size: const Size.fromHeight(40),
        ),
        const SizedBox(height: 10)
      ],
    );
  }
}