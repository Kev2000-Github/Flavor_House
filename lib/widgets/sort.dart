import 'package:flutter/material.dart';

import '../utils/colors.dart';

class Sort extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const Sort({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: whiteColor,
        child: Row(
          children: [
            const Text(
              "Mas recientes",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: darkColor),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.sort),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)
                        )),
                    builder: builder);
              },
            )
          ],
        ));
  }
}
