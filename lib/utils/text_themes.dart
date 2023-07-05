import 'package:flutter/material.dart';
import 'colors.dart';

enum TextThemeEnum {
  darkMedium,
  darkLight,
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
      case TextThemeEnum.darkLight:
        return const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w300, color: darkColor);
      default:
        return const TextStyle();
    }
  }
}