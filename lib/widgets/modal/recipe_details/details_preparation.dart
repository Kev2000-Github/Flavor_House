import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/utils/colors.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flutter/cupertino.dart';

import '../../../common/error/failures.dart';
import '../../../common/popups/common.dart';
import '../../../models/post/recipe_preparation.dart';
import '../../../services/paginated.dart';
import '../../../services/post/post_service.dart';

class Preparation extends StatefulWidget {
  final String recipeId;
  const Preparation({super.key, required this.recipeId});

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  Paginated<RecipePreparationStep> steps = Paginated.initial();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    getPreparationSteps(setLoadingModeState);
  }

  void setLoadingModeState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  void getPreparationSteps(Function(bool) setLoadingState) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Paginated<RecipePreparationStep>> result =
        await postService.getRecipePreparation(widget.recipeId);
    result.fold((l) => CommonPopup.alert(context, l), (newSteps) {
      setState(() {
        steps.addPage(newSteps);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListViewInfiniteLoader(
        canLoadMore: steps.page < steps.totalPages,
        getMoreItems: getPreparationSteps,
        loadingState: _loadingMore,
        setLoadingModeState: setLoadingModeState,
        children: List.generate(
            steps.items,
                (index) => Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: gray03Color))),
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(bottom: 8),
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
                                    image: steps.getItem(index).picture.image,
                                    fit: BoxFit.cover)),
                          ))),
                  const SizedBox(width: 10),
                  Flexible(
                      flex: 7,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(steps.getItem(index).description),
                      )),
                ],
              ),
            ))
      ),
    );
  }
}
