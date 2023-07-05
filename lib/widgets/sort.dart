import 'package:flavor_house/models/sort/sort_config.dart';
import 'package:flavor_house/widgets/button.dart';
import 'package:flavor_house/widgets/modal/sort.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class Sort extends StatelessWidget {
  final SortConfig selectedValue;
  final Function(SortConfig) onChange;

  const Sort({super.key, required this.selectedValue, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: whiteColor,
        child: Row(
          children: [
            const Text(
              "Mas recientes",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: darkColor),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.sort),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)
                        )),
                    builder: (context) => SortModalContent(
                          selectedValue: selectedValue,
                          onApply: (selectedConfig) {
                            onChange(selectedConfig);
                          },
                          onCancel: () {
                            onChange(SortConfig.latest());
                          },
                        ));
              },
            )
          ],
        ));
  }
}
