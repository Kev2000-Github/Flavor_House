
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class InputPostSkeleton extends StatelessWidget {
  const InputPostSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
    ]);
  }
}
