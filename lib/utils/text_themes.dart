import 'package:flutter/material.dart';
import 'colors.dart';

enum TextThemeEnum {
  darkMedium,
  darkSemiMedium,
  darkLight,
  grayLight
}

class DesignTextTheme {
  static TextStyle get({TextThemeEnum? type}) {
    switch (type) {
      case TextThemeEnum.darkMedium:
        return const TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          color: darkColor,
        );
      case TextThemeEnum.darkSemiMedium:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkColor,
        );
      case TextThemeEnum.darkLight:
        return const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w300, color: darkColor);
      case TextThemeEnum.grayLight:
        return const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
          color: gray04Color,
        );
      default:
        return const TextStyle();
    }
  }
}
