import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/modal/recipe_details/details_reviews.dart';
import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import 'details_ingredients.dart';
import 'details_preparation.dart';

class DetailsModalContent extends StatefulWidget {
  final String recipeId;
  const DetailsModalContent({super.key, required this.recipeId});

  @override
  State<DetailsModalContent> createState() => _DetailsModalContentState();
}

class _DetailsModalContentState extends State<DetailsModalContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).copyWith().size.height * 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(height: 5, width: 40, color: gray03Color),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 3,
                  initialIndex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(tabs: [
                        Tab(
                            child: Text(
                              "Ingredientes",
                              style: DesignTextTheme.get(
                                  type: TextThemeEnum.darkSemiMedium),
                            )),
                        Tab(
                            child: Text(
                              "Preparacion",
                              style: DesignTextTheme.get(
                                  type: TextThemeEnum.darkSemiMedium),
                            )),
                        Tab(
                            child: Text(
                              "Reseñas",
                              style: DesignTextTheme.get(
                                  type: TextThemeEnum.darkSemiMedium),
                            ))
                      ]),
                      Expanded(
                          child: TabBarView(
                              children: [
                                Ingredients(recipeId: widget.recipeId),
                                Preparation(recipeId: widget.recipeId),
                                Reviews(recipeId: widget.recipeId)
                              ]))
                    ],
                  ))
            )
          ],
        ));
  }
}

