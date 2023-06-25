import 'dart:ui';

import 'package:shimmer/shimmer.dart';

class SkeletonTheme {
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;
  final Duration period;

  SkeletonTheme(
      this.baseColor, this.highlightColor, this.direction, this.period);

  factory SkeletonTheme.initial() {
    return SkeletonTheme(const Color(0xFFE0E0E0), const Color(0xFFF5F5F5),
        ShimmerDirection.ltr, const Duration(seconds: 2));
  }
}
