

import 'package:flutter/cupertino.dart';

import '../../utils/skeleton_theme.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/post_skeleton.dart';

class SkeletonProfile extends StatelessWidget {
  final int items;
  final SkeletonTheme? theme;
  const SkeletonProfile({super.key, this.items = 2, this.theme});

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
                    const SizedBox(
                      height: 20,
                    ),
                    PostSkeleton(items: items)
                  ]),
                ))),
      ],
    );
  }
}
