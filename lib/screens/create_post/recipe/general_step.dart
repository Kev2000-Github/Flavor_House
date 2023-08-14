import 'dart:io';

import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/services/post/dummy_post_service.dart';
import 'package:flavor_house/services/post/post_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/post/tag.dart';
import '../../../models/user/user.dart';
import '../../../utils/colors.dart';
import '../../../widgets/Avatar.dart';
import '../../../widgets/conditional.dart';
import '../../../widgets/text_field.dart';

class GeneralStep extends StatefulWidget {
  final Recipe? recipe;
  final User user;
  const GeneralStep({super.key, required this.user, required this.recipe});

  @override
  State<GeneralStep> createState() => _GeneralStepState();
}

class _GeneralStepState extends State<GeneralStep> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  Image? image;
  bool isSelected = false;
  List<Tag> tags = [];
  List<String> selectedTags = [];

  void getTags() async {
    PostService service = DummyPost();
    dartz.Either<Failure, List<Tag>> result = await service.getTags();
    result.fold((l) => null, (List<Tag> interests) {
      setState(() {
        tags = interests;
        Iterable<String> recipeTagNames = (widget.recipe?.tags ?? []).map((Tag e) => e.id);
        selectedTags.addAll(recipeTagNames);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.recipe?.title ?? "";
    _descriptionController.text = widget.recipe?.description ?? "";
    image = widget.recipe?.picture;
    getTags();
  }

  @override
  Widget build(BuildContext context) {
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
                              tags.length,
                              (index) => ChoiceChip(
                                    label: Text(tags[index].name),
                                    avatar: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Icon(
                                        selectedTags.contains(tags[index].id)
                                            ? Icons.done
                                            : Icons.circle_outlined,
                                        color: selectedTags
                                                .contains(tags[index].id)
                                            ? secondaryColor
                                            : gray03Color,
                                      ),
                                    ),
                                    selected:
                                        selectedTags.contains(tags[index].id),
                                    selectedShadowColor: primaryColor,
                                    selectedColor: primaryColor.withAlpha(90),
                                    shadowColor: primaryColor,
                                    onSelected: (bool value) {
                                      setState(() {
                                        if (selectedTags
                                            .contains(tags[index].id)) {
                                          selectedTags.remove(tags[index].id);
                                        } else {
                                          selectedTags.add(tags[index].id);
                                        }
                                      });
                                    },
                                  )),
                        )
                      ]),
                ]))
      ],
    );
  }
}
