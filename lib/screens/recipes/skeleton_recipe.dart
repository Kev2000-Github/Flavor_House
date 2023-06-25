import 'package:flavor_house/widgets/input_post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/skeleton_theme.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/post_skeleton.dart';

class SkeletonRecipe extends StatefulWidget {
  final int items;
  final SkeletonTheme? theme;

  const SkeletonRecipe({
    Key? key,
    this.items = 1,
    this.theme
  }) : super(key: key);

  @override
  _SkeletonRecipeState createState() => _SkeletonRecipeState();
}

class _SkeletonRecipeState extends State<SkeletonRecipe> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonWrapper(
            skeletonTheme: widget.theme,
            child: const Padding(
                padding: EdgeInsets.only(top: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(children: [
                    InputPostSkeleton(),
                    SizedBox(
                      height: 20,
                    ),
                    PostSkeleton(items: 2)
                  ]),
                ))),
      ],
    );
  }
}