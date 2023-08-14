import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/config/sort_config.dart';
import '../../utils/colors.dart';
import '../../utils/text_themes.dart';
import '../button.dart';

class FavoriteModalContent extends StatefulWidget {
  final SortConfig selectedValue;
  final PostTypeConfig selectedPostType;
  final Function(SortConfig, PostTypeConfig)? onApply;
  final VoidCallback? onCancel;

  const FavoriteModalContent(
      {super.key,
        required this.selectedValue,
        required this.selectedPostType,
        this.onApply, this.onCancel});

  @override
  State<FavoriteModalContent> createState() => _FavoriteModalContentState();
}

class _FavoriteModalContentState extends State<FavoriteModalContent> {
  SortConfig selectedConfig = SortConfig.latest();
  final List<SortConfig> sortOptions = [SortConfig.latest(), SortConfig.oldest()];
  final List<PostTypeConfig> postTypeOptions = [PostTypeConfig.Moment(), PostTypeConfig.Recipe(), PostTypeConfig.All()];
  PostTypeConfig selectedPostType = PostTypeConfig.All();

  @override
  void initState() {
    selectedConfig = widget.selectedValue;
    selectedPostType = widget.selectedPostType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).copyWith().size.height *
            0.50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                  height: 5, width: 40, color: gray03Color),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Filtros",
                style: DesignTextTheme.get(type: TextThemeEnum.darkMedium),
              ),
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 1,
                  thickness: 1,
                )),
            Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Orden",
                      style: DesignTextTheme.get(type: TextThemeEnum.darkMedium),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                        child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                                isDense: false,
                                hint: const Text("orden"),
                                value: selectedConfig.value,
                                items: List.generate(
                                    sortOptions.length,
                                        (index) {
                                      return DropdownMenuItem(
                                          value: sortOptions[index]
                                              .value,
                                          child: Container(
                                              margin:
                                              const EdgeInsets
                                                  .all(8),
                                              child: Text(
                                                  sortOptions[index]
                                                      .name)));
                                    }),
                                onChanged: (val) {
                                  if (val == null) return;
                                  setState(() {
                                    selectedConfig = sortOptions.firstWhere((config) => config.value == val);
                                  });
                                })))
                  ],
                )),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Posts",
                      style: DesignTextTheme.get(type: TextThemeEnum.darkMedium),
                    ),
                    const Spacer(),
                    DropdownButtonHideUnderline(
                        child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                                isDense: false,
                                hint: const Text("tipo de post"),
                                value: selectedPostType.value,
                                items: List.generate(
                                    postTypeOptions.length,
                                        (index) {
                                      return DropdownMenuItem(
                                          value: postTypeOptions[index]
                                              .value,
                                          child: Container(
                                              margin:
                                              const EdgeInsets
                                                  .all(8),
                                              child: Text(
                                                  postTypeOptions[index]
                                                      .name)));
                                    }),
                                onChanged: (val) {
                                  if (val == null) return;
                                  setState(() {
                                    selectedPostType = postTypeOptions.firstWhere((config) => config.value == val);
                                  });
                                })))
                  ],
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Button(
                            onPressed: () {
                              if(widget.onApply == null) return;
                              widget.onApply!(selectedConfig, selectedPostType);
                              Navigator.pop(context);
                            },
                            text: "Listo",
                            size: const Size(150, 40),
                            backgroundColor: secondaryColor,
                            textColor: whiteColor,
                            borderRadius:
                            BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: secondaryColor),
                          )),
                      const SizedBox(width: 10),
                      Expanded(
                          flex: 1,
                          child: Button(
                            onPressed: () {
                              if(widget.onCancel == null) return;
                              widget.onCancel!();
                              Navigator.pop(context);
                            },
                            text: "Borrar",
                            size: const Size(150, 40),
                            backgroundColor: gray02Color,
                            borderRadius:
                            BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: gray02Color),
                          ))
                    ]))
          ],
        ));
  }
}
