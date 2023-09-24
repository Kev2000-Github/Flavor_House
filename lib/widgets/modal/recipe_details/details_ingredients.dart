

import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flutter/material.dart';

import '../../../common/error/failures.dart';
import '../../../services/paginated.dart';
import '../../../services/post/post_service.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_themes.dart';

class Ingredients extends StatefulWidget {
  final String recipeId;
  const Ingredients({super.key, required this.recipeId});

  @override
  State<Ingredients> createState() => _IngredientsState();
}

class _IngredientsState extends State<Ingredients> {
  Paginated<String> ingredients = Paginated.initial();
  bool _loadingMore = false;

  void getIngredients(Function(bool) setLoadingState) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Paginated<String>> result = await postService.getIngredients(widget.recipeId);
    result.fold((l) => null, (Paginated<String> ingredients) {
      setState(() {
        this.ingredients.addPage(ingredients);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getIngredients(setLoadingModeState);
  }

  void setLoadingModeState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListViewInfiniteLoader(
        canLoadMore: ingredients.page < ingredients.totalPages,
        getMoreItems: getIngredients,
        loadingState: _loadingMore,
        setLoadingModeState: setLoadingModeState,
        children: List.generate(
            ingredients.items,
                (index) => Padding(
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  const Icon(Icons.bookmark_outline,
                      size: 28, color: primaryColor),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    ingredients.getItem(index),
                    style: DesignTextTheme.get(
                        type: TextThemeEnum.darkSemiMedium),
                  )
                ]))),
      ),
    );
  }
}