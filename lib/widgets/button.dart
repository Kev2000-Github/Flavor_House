import 'package:flutter/material.dart';

import '../utils/colors.dart';

class Button extends StatelessWidget {
  final Size? size;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? borderSide;
  final Color backgroundColor;
  final Color textColor;
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final VoidCallback? onPressed;

  const Button(
      {Key? key,
      this.size,
      this.borderRadius,
      this.borderSide,
      this.backgroundColor = whiteColor,
      this.textColor = blackColor,
      this.fontWeight = FontWeight.w600,
      this.fontSize = 18,
      required this.onPressed,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          side: borderSide ?? const BorderSide(color: primaryColor, width: 2),
          minimumSize: size ?? const Size.fromHeight(55),
          shape: RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(40)),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: textColor, fontWeight: fontWeight, fontSize: fontSize),
        ));
  }
}
