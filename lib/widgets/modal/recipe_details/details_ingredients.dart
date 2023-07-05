

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/error/failures.dart';
import '../../../services/post/dummy_post_service.dart';
import '../../../services/post/post_service.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../../utils/colors.dart';
import '../../../utils/text_themes.dart';

class Ingredients extends StatefulWidget {
  final String recipeId;
  const Ingredients({super.key, required this.recipeId});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  List<String> ingredients = [];

  void getIngredients() async {
    PostService postService = DummyPost();
    dartz.Either<Failure, List<String>> result = await postService.getIngredients(widget.recipeId);
    result.fold((l) => null, (List<String> ingredients) {
      setState(() {
        this.ingredients = ingredients;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  ingredients.length,
                      (index) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(children: [
                        const Icon(Icons.bookmark_outline,
                            size: 28, color: primaryColor),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          ingredients[index],
                          style: DesignTextTheme.get(
                              type: TextThemeEnum.darkSemiMedium),
                        )
                      ]))))),
    );
  }
}