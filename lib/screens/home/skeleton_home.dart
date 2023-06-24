

import 'package:flavor_house/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../widgets/input_post.dart';

class SkeletonHome extends StatefulWidget {
  final int items;
  final Color baseColor;
  final Color highlightColor;
  final ShimmerDirection direction;
  final Duration period;

  const SkeletonHome({
    Key? key,
    this.items = 1,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
    this.direction = ShimmerDirection.ltr,
    this.period = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _SkeletonHomeState createState() => _SkeletonHomeState();
}

class _SkeletonHomeState extends State<SkeletonHome> {
  @override
  Widget build(BuildContext context) {
    ShimmerDirection direction = widget.direction;

    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: widget.baseColor,
          highlightColor: widget.highlightColor,
          direction: direction,
          period: widget.period,
          child:  Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: SingleChildScrollView(
                child: Column(children: [
                  Row(children: [
                    const Expanded(
                        flex: 1,
                        child: CircleAvatar(
                            radius: 30,
                            backgroundColor: whiteColor,
                            )
                    ),
                    Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: whiteColor
                          ),
                          width: double.infinity,
                          height: 45,
                        )
                    )
                  ]),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, __) => Container(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 10),
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Container(
                                  margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Row(children: [
                                        const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: whiteColor,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: whiteColor
                                                ),
                                                margin: const EdgeInsets.only(bottom: 10),
                                                width: 120,
                                                height: 16,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(3),
                                                    color: whiteColor
                                                ),
                                                width: 100,
                                                height: 13,
                                              )
                                            ])
                                      ]),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: whiteColor
                                        ),
                                        width: double.infinity,
                                        height: 250,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: whiteColor
                                            ),
                                            width: 200,
                                            height: 12,
                                          )),
                                      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        Wrap(spacing: 10, children: List.generate(3, (index) => Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: whiteColor
                                          ),
                                          width: 28,
                                          height: 28,
                                        ))),
                                      ]),
                                      Padding(
                                          padding: const EdgeInsets.only( top: 5),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(3),
                                                color: whiteColor
                                            ),
                                            width: 100,
                                            height: 12,
                                          ))
                                    ]),
                                  ))
                            ]),
                          )),
                    ),
                    itemCount: widget.items,
                  )
                ]),
              )),
        ),
      ],
    );
  }
}