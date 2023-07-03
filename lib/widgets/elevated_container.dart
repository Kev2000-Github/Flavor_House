

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class ElevatedContainer extends StatelessWidget {
  final String content;
  const ElevatedContainer({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: gray02Color,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(1, 4), // changes position of shadow
            ),
          ]),
      child: Text(
        content,
        style: const TextStyle(color: blackColor),
        overflow: TextOverflow.clip,
      ),
    );
  }
}
