

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/user/user.dart';
import '../../../utils/colors.dart';
import '../../../widgets/Avatar.dart';
import '../../../widgets/text_field.dart';

class GeneralStep extends StatefulWidget {
  final User user;
  const GeneralStep({super.key, required this.user});

  @override
  State<GeneralStep> createState() => _GeneralStepState();
}

class _GeneralStepState extends State<GeneralStep> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Avatar(
                pictureHeight: 55, borderSize: 2, image: widget.user?.picture),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextFieldInput(
                  hintText: "Nombre de la receta",
                  onSubmitted: (String value) {},
                  textInputType: TextInputType.text,
                  textEditingController: _titleController,
                )),
          ],
        ),
        SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFieldInput(
                    hintText: "Agregue una breve descripcion",
                    onSubmitted: (String value) {},
                    textInputType: TextInputType.multiline,
                    textEditingController: _descriptionController,
                    minLine: 6,
                    maxLine: null,
                  ),
                  const SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        (imagePath == "")
                            ? Container()
                            : Image.file(File(imagePath),
                            width: 250, height: 250),
                        IconButton(
                            iconSize: 70,
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              XFile? pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              imagePath = pickedFile?.path ?? "";
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.image,
                              size: 70,
                              color: gray03Color,
                            )),
                      ]),
                ]))
      ],
    );
  }
}
