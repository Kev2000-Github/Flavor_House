import 'package:flavor_house/widgets/conditional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ListViewInfiniteLoader extends StatelessWidget {
  final Function(bool) setLoadingModeState;
  final Function(Function(bool)) getMoreItems;
  final List<Widget> children;
  final bool loadingState;
  final bool canLoadMore;
  const ListViewInfiniteLoader(
      {super.key,
      required this.setLoadingModeState,
      required this.getMoreItems,
      required this.children,
      required this.loadingState,
      required this.canLoadMore});

  void onLoaderVisible(VisibilityInfo info) {
    if (info.visibleFraction > 0.1 && !loadingState && canLoadMore) {
      getMoreItems(setLoadingModeState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...children,
        VisibilityDetector(
            key: const Key("loader"),
            onVisibilityChanged: onLoaderVisible,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Conditional(
                  condition: canLoadMore,
                  positive: const Center(child: CircularProgressIndicator()),
                )))
      ],
    );
  }
}
