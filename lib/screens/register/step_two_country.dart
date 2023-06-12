

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class StepCountry extends StatelessWidget {
  final Function(String) onCountrySelect;
  const StepCountry({Key? key, required this.onCountrySelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: ListTile(
          title: Text("Country", style: TextStyle(
              color: gray04Color, fontSize: 22, fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.keyboard_arrow_right, size: 20),
          onTap: () {
            onCountrySelect("a");
          },
        )
    );
  }
}