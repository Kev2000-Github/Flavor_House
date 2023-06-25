

import 'package:flavor_house/utils/colors.dart';
import 'package:flavor_house/utils/skeleton_theme.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/input_post.dart';

class SkeletonWrapper extends StatefulWidget {
  final SkeletonTheme? skeletonTheme;
  final Widget child;

  const SkeletonWrapper({
    Key? key,
    this.skeletonTheme,
    required this.child,
  }) : super(key: key);

  @override
  _SkeletonWrapperState createState() => _SkeletonWrapperState();
}

class _SkeletonWrapperState extends State<SkeletonWrapper> {
  @override
  Widget build(BuildContext context) {
    final theme = widget.skeletonTheme ?? SkeletonTheme.initial();
    ShimmerDirection direction = theme.direction;

    return Shimmer.fromColors(
      baseColor: theme.baseColor,
      highlightColor: theme.highlightColor,
      direction: direction,
      period: theme.period,
      child: widget.child,
    );
  }
}