

import 'package:flutter/material.dart';

import '../../../common/error/failures.dart';
import '../../../services/post/dummy_post_service.dart';
import '../../../services/post/post_service.dart';
import '../../../utils/colors.dart';
import '../../../widgets/elevated_container.dart';
import '../../../widgets/modal/text_input.dart';
import 'package:dartz/dartz.dart' as dartz;

class IngredientStep extends StatefulWidget {
  final String? recipeId;
  const IngredientStep({super.key, this.recipeId});

  @override
  State<IngredientStep> createState() => _IngredientStepState();
} 

class _IngredientStepState extends State<IngredientStep> {
  List<String> ingredients = [];
  
  @override
  void initState() {
    super.initState();
    if(widget.recipeId != null){
      getIngredients();
    }
  }

  void getIngredients() async {
    PostService postService = DummyPost();
    dartz.Either<Failure, List<String>> result = await postService.getIngredients(widget.recipeId!);
    result.fold((l) => null, (List<String> ingredients) {
      setState(() {
        this.ingredients.addAll(ingredients);
      });
    });
  }

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
                        content: ingredients[index])),
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
