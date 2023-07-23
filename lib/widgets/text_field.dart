import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final FocusNode? focusNode;
  final Color? bgColor;
  final Widget? prefixICon;
  final Widget? suffixIcon;
  final Function(String)? onSubmitted;
  final bool autofocus;
  final int? minLine;
  final int? maxLine;

  const TextFieldInput(
      {Key? key,
      this.isPass = false,
      required this.hintText,
      required this.textInputType,
      required this.textEditingController,
      this.bgColor,
      this.prefixICon,
      this.suffixIcon,
      this.focusNode,
      this.onSubmitted,
      this.autofocus = false,
      this.minLine = 1,
      this.maxLine = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      focusNode: focusNode,
      controller: textEditingController,
      onSubmitted: onSubmitted,
      autofocus: autofocus,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        prefixIcon: prefixICon,
        suffixIcon: suffixIcon,
        fillColor: bgColor,
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      minLines: minLine,
      maxLines: maxLine,
    );
  }
}
