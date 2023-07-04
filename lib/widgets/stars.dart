import 'package:flutter/material.dart';

import '../utils/colors.dart';

class StarsRating extends StatelessWidget {
  final Function? onRate;
  final double rate;
  final double size;
  const StarsRating({Key? key, this.onRate, required this.rate, this.size = 28}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: List.generate(
            5,
            (index) => GestureDetector(
                  onTap: () {
                    if(onRate != null) onRate!(index);
                  },
                  child: Icon( index + 1 <= rate ? Icons.star : Icons.star_border,
                      size: size, color: yellowColor),
                )));
  }
}
