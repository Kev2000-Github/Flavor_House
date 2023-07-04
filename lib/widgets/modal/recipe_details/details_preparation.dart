
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/cupertino.dart';

import '../../../common/error/failures.dart';
import '../../../models/post/recipe_preparation.dart';
import '../../../services/post/dummy_post_service.dart';
import '../../../services/post/post_service.dart';

class Preparation extends StatefulWidget {
  final String recipeId;
  const Preparation({super.key, required this.recipeId});

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  List<RecipePreparationStep> steps = [];

  @override
  void initState() {
    super.initState();
    getPreparationSteps();
  }

  void getPreparationSteps() async {
    PostService postService = DummyPost();
    dartz.Either<Failure, List<RecipePreparationStep>> result =
    await postService.getRecipePreparation("recipeId");
    result.fold((l) => null, (List<RecipePreparationStep> steps) {
      setState(() {
        this.steps = steps;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
          child: Column(
            children: List.generate(
                steps.length,
                    (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        image: steps[index].picture.image,
                                        fit: BoxFit.cover)),
                              ))),
                      const SizedBox(width: 10),
                      Flexible(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(steps[index].description),
                          )),
                    ],
                  ),
                )),
          )),
    );
  }
}