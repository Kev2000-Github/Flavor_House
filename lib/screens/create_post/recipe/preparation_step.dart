

import 'package:flavor_house/services/paginated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/error/failures.dart';
import '../../../models/post/recipe_preparation.dart';
import '../../../services/post/dummy_post_service.dart';
import '../../../services/post/post_service.dart';
import '../../../utils/colors.dart';
import '../../../widgets/button.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/modal/text_input.dart';
import 'package:dartz/dartz.dart' as dartz;

class PreparationStep extends StatefulWidget {
  final String? recipeId;
  const PreparationStep({super.key, this.recipeId});

  @override
  State<PreparationStep> createState() => _PreparationStepState();
}

class _PreparationStepState extends State<PreparationStep> {
  List<RecipePreparationStep> preparationSteps = [];

  @override
  void initState() {
    super.initState();
    if(widget.recipeId != null){
      getPreparationSteps();
    }
  }

  void getPreparationSteps() async {
    PostService postService = DummyPost();
    dartz.Either<Failure, Paginated<RecipePreparationStep>> result =
    await postService.getRecipePreparation(widget.recipeId!);
    result.fold((l) => null, (steps) {
      setState(() {
        preparationSteps.addAll(steps.getData());
      });
    });
  }

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
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          XFile? pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                          preparationSteps[index].imageURL = pickedFile?.path;
                          setState((){});
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 90,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                      image: preparationSteps[index].imageURL != null ? preparationSteps[index].picture.image : const AssetImage("assets/images/gray-add.png"),
                                      fit: BoxFit.cover)),
                            ))
                      )),
                  const SizedBox(width: 20),
                  Flexible(
                      flex: 7,
                      child: ElevatedContainer(
                          content: preparationSteps[index].description)),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        preparationSteps.remove(preparationSteps[index]);
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