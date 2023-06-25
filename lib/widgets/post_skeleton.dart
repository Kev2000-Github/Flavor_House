import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class PostSkeleton extends StatelessWidget {
  final int items;
  const PostSkeleton({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
      itemCount: items,
    );
  }
}
