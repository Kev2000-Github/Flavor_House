import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/skeleton_theme.dart';
import '../../utils/skeleton_wrapper.dart';

class SkeletonFavorite extends StatefulWidget {
  final int items;
  final SkeletonTheme? theme;

  const SkeletonFavorite({
    Key? key,
    this.items = 1,
    this.theme,
  }) : super(key: key);

  @override
  _SkeletonFavoriteState createState() => _SkeletonFavoriteState();
}

class _SkeletonFavoriteState extends State<SkeletonFavorite> {
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