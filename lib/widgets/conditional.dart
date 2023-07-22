

import 'package:flutter/cupertino.dart';

class Conditional extends StatelessWidget {
  final bool condition;
  final Widget? positive;
  final Widget? negative;
  const Conditional({super.key, required this.condition, this.positive, this.negative});

  @override
  Widget build(BuildContext context) {
    return condition ?
        positive ?? Container()
        :
        negative ?? Container();
  }
}
