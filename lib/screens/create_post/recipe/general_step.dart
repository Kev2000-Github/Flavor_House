import 'dart:io';

import 'package:flavor_house/models/post/recipe.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/post/tag.dart';
import '../../../models/user/user.dart';
import '../../../utils/colors.dart';
import '../../../widgets/Avatar.dart';
import '../../../widgets/conditional.dart';
import '../../../widgets/text_field.dart';

class GeneralStep extends StatefulWidget {
  final User user;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final List<Tag> tags;
  final String? postImage;
  final List<String> selectedTags;
  final Function(List<String> tags) onSelectTags;
  final Function(String image) onSelectImage;

  const GeneralStep({super.key, required this.user, required this.titleController, required this.descriptionController, required this.onSelectTags, required this.tags, required this.selectedTags, required this.onSelectImage, this.postImage});

  @override
  State<GeneralStep> createState() => _GeneralStepState();
}

class _GeneralStepState extends State<GeneralStep> {
  Image? image;

  @override
  void initState() {
    super.initState();
    if(widget.postImage != null){
      image = Image.network(widget.postImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder =
    OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Column(
      children: [
        Row(
          children: [
            Avatar(
                pictureHeight: 55, borderSize: 2, image: widget.user.picture),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: TextFormField(
                  controller: widget.titleController,
                  validator: (val) {
                    if(val == null || val.isEmpty) return 'Titulo vacio';
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Nombre de la receta",
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    enabledBorder: inputBorder,
                    filled: true,
                    contentPadding: const EdgeInsets.all(8),
                  ),
                  keyboardType: TextInputType.text,
                )),
          ],
        ),
        SingleChildScrollView(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: widget.descriptionController,
                    validator: (val) {
                      if(val == null || val.isEmpty) return 'Descripcion vacia';
                      if(val.length < 10) return 'La descripcion debe tener como minimo 10 caracteres';
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Agregue una breve descripcion",
                      border: inputBorder,
                      focusedBorder: inputBorder,
                      enabledBorder: inputBorder,
                      filled: true,
                      contentPadding: const EdgeInsets.all(8),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 6,
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Conditional(
                          condition: image != null,
                          positive: Container(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: image)
                          ),
                        ),
                        const Divider(height: 1, thickness: 1.5, color: gray02Color),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  iconSize: 40,
                                  splashRadius: 25,
                                  onPressed: () async {
                                    final ImagePicker picker = ImagePicker();
                                    XFile? pickedFile = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if(pickedFile == null) return;
                                    image = Image.file(File(pickedFile.path));
                                    widget.onSelectImage(pickedFile.path);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.photo_outlined,
                                    color: gray03Color,
                                  ))
                            ]
                        ),
                        Wrap(
                          spacing: 10,
                          children: List.generate(
                              widget.tags.length,
                              (index) => ChoiceChip(
                                    label: Text(widget.tags[index].name),
                                    avatar: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Icon(
                                        widget.selectedTags.contains(widget.tags[index].id)
                                            ? Icons.done
                                            : Icons.circle_outlined,
                                        color: widget.selectedTags
                                                .contains(widget.tags[index].id)
                                            ? secondaryColor
                                            : gray03Color,
                                      ),
                                    ),
                                    selected:
                                        widget.selectedTags.contains(widget.tags[index].id),
                                    selectedShadowColor: primaryColor,
                                    selectedColor: primaryColor.withAlpha(90),
                                    shadowColor: primaryColor,
                                    onSelected: (bool value) {
                                      String tagId = widget.tags[index].id;
                                      List<String> newTags = [];
                                      if (widget.selectedTags.contains(tagId)) {
                                        newTags = widget.selectedTags.where((id) => id != tagId).toList();
                                      } else {
                                        newTags = [...widget.selectedTags, tagId];
                                      }
                                      widget.onSelectTags(newTags);
                                    },
                                  )),
                        )
                      ]),
                ]))
      ],
    );
  }
}
