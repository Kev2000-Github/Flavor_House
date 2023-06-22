import 'package:flutter/material.dart';

import '../utils/colors.dart';

class StarsRating extends StatelessWidget {
  final Function onRate;
  final double rate;
  const StarsRating({Key? key, required this.onRate, required this.rate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: List.generate(
            5,
            (index) => GestureDetector(
                  onTap: () => onRate(index),
                  child: Icon( index + 1 <= rate ? Icons.star : Icons.star_border,
                      size: 28, color: yellowColor),
                )));
  }
}
