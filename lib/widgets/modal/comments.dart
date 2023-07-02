import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/text_themes.dart';

class CommentsModalContent extends StatefulWidget {
  const CommentsModalContent({super.key});

  @override
  State<CommentsModalContent> createState() => _CommentsModalContentState();
}

class _CommentsModalContentState extends State<CommentsModalContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).copyWith().size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(height: 5, width: 40, color: gray03Color),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Comentarios",
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
                child: Column(
                  children: [Container()],
                ))
          ],
        ));
  }
}
