import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../text_field.dart';

class TextInputModalContent extends StatefulWidget {
  final Function(String) onSend;
  final Widget? child;
  const TextInputModalContent({super.key, required this.onSend, this.child});

  @override
  State<TextInputModalContent> createState() => _TextInputModalContentState();
}

class _TextInputModalContentState extends State<TextInputModalContent> {
  final TextEditingController _textController = TextEditingController();
  bool isEmpty = false;

  void updateIsTextEmpty( ){
    setState(() {
      isEmpty = _textController.value.text.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _textController.addListener(updateIsTextEmpty);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child ?? Container(),
            Row(
              children: [
                Expanded(
                    child: TextFieldInput(
                      hintText: "",
                      autofocus: true,
                      onSubmitted: (String value) {},
                      textInputType: TextInputType.text,
                      textEditingController: _textController,
                    )),
                IconButton(
                    onPressed: isEmpty ? null : () {
                      widget.onSend(_textController.value.text);
                      Navigator.pop(context);
                    },
                    splashRadius: 22,
                    icon: Icon(
                      Icons.send,
                      color: isEmpty ? gray03Color : primaryColor,
                    ))
              ],
            )
          ],
        ));
  }
}
