import 'package:flutter/cupertino.dart';

import '../utils/colors.dart';
import 'avatar.dart';

class PostUser extends StatelessWidget {
  final String fullName;
  final String username;
  final String avatarURL;
  const PostUser({Key? key, required this.fullName, required this.username, required this.avatarURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Avatar(
        imageURL:
        avatarURL,
        pictureHeight: 60,
        borderSize: 2,
      ),
      const SizedBox(
        width: 10,
      ),
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName,
              style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: darkColor),
            ),
            Text(username, style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
                color: darkColor))
          ])
    ]);
  }
}
