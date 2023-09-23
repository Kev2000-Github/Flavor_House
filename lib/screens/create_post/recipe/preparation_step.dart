

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/post/recipe_preparation.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_themes.dart';
import '../../../widgets/button.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/modal/text_input.dart';

class PreparationStep extends StatefulWidget {
  final List<RecipePreparationStep> preparationSteps;
  final Function(List<RecipePreparationStep> newSteps) updatePreparationSteps;
  const PreparationStep({super.key, required this.preparationSteps, required this.updatePreparationSteps});

  @override
  State<PreparationStep> createState() => _PreparationStepState();
}

class _PreparationStepState extends State<PreparationStep> {

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            TextInputModalContent(onSend: (String description) {
              RecipePreparationStep step = RecipePreparationStep(description, null);
              widget.updatePreparationSteps([...widget.preparationSteps, step]);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Ingrese por lo menos 1 paso', style: DesignTextTheme.get(type: TextThemeEnum.darkMedium)),
        const SizedBox(height: 30),
        ...List.generate(
            widget.preparationSteps.length,
                (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                          List<RecipePreparationStep> newSteps = [...widget.preparationSteps];
                          newSteps[index].imageURL = pickedFile?.path;
                          widget.updatePreparationSteps(newSteps);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: widget.preparationSteps[index].imageURL != null ? widget.preparationSteps[index].picture.image : const AssetImage("assets/images/gray-add.png"),
                                      fit: BoxFit.cover)),
                            ))
                      )),
                  const SizedBox(width: 20),
                  Flexible(
                      flex: 7,
                      child: ElevatedContainer(
                          content: widget.preparationSteps[index].description)),
                  ElevatedButton(
                    onPressed: () {
                      List<RecipePreparationStep> steps = [...widget.preparationSteps];
                      steps.removeAt(index);
                      widget.updatePreparationSteps(steps);
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