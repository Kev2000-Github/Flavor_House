import 'package:flavor_house/widgets/Avatar.dart';
import 'package:flutter/cupertino.dart';

import '../utils/colors.dart';
import '../utils/text_themes.dart';

class UserItem extends StatelessWidget {
  final String fullName;
  final String username;
  final String avatarURL;
  final String location;
  const UserItem(
      {super.key,
      required this.fullName,
      required this.username,
      required this.avatarURL, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(children: [
        Avatar(
          imageURL: avatarURL,
          pictureHeight: 60,
          borderSize: 2,
        ),
        const SizedBox(
          width: 10,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            fullName,
            style: DesignTextTheme.get(type: TextThemeEnum.darkMedium),
          ),
          Text(username,
              style: DesignTextTheme.get(type: TextThemeEnum.darkLight)),
          Text(location,
              style: const TextStyle(color: gray04Color))
        ])
      ]),
    );
  }
}
