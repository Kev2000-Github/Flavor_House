import 'package:flavor_house/utils/skeleton_theme.dart';
import 'package:flavor_house/utils/skeleton_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/input_post_skeleton.dart';
import '../../widgets/post_skeleton.dart';

class SkeletonHome extends StatefulWidget {
  final int items;
  final SkeletonTheme? theme;

  const SkeletonHome({
    Key? key,
    this.items = 1,
    this.theme,
  }) : super(key: key);

  @override
  _SkeletonHomeState createState() => _SkeletonHomeState();
}

class _SkeletonHomeState extends State<SkeletonHome> {
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
