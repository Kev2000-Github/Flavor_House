import 'package:flavor_house/screens/search/search.dart';
import 'package:flavor_house/widgets/input_post_skeleton.dart';
import 'package:flavor_house/widgets/user_item_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/skeleton_theme.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/post_skeleton.dart';

class SkeletonSearch extends StatelessWidget {
  final int items;
  final SkeletonTheme? theme;
  final SearchType type;

  const SkeletonSearch({
    Key? key,
    this.type = SearchType.moment,
    this.items = 1,
    this.theme
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SkeletonWrapper(
            skeletonTheme: theme,
            child: Padding(
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(children: [
                    type == SearchType.user ? const UserItemSkeleton(items: 8) : const PostSkeleton(items: 2)
                  ]),
                ))),
      ],
    );
  }
}
