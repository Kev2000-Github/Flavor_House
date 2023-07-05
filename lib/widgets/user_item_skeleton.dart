
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class UserItemSkeleton extends StatelessWidget {
  final int items;
  const UserItemSkeleton(
      {Key? key, required this.items})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: whiteColor,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ),
            const SizedBox(height: 5),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: whiteColor
              ),
              width: 80,
              height: 9,
            )
          ])
        ]),
      ),
      itemCount: items,
    );
  }
}
