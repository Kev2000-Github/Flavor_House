import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/widgets/Avatar.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/text_themes.dart';
import '../common/constants/routes.dart' as routes;

class UserItemWidget extends StatelessWidget {
  final UserItem user;
  const UserItemWidget(
      {super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(routes.other_user_profile, arguments: user);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Row(children: [
          Avatar(
            image: user.avatar,
            pictureHeight: 60,
            borderSize: 2,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              user.fullName,
              style: DesignTextTheme.get(type: TextThemeEnum.darkMedium),
            ),
            Text(user.username,
                style: DesignTextTheme.get(type: TextThemeEnum.darkLight)),
            Text(user.location,
                style: const TextStyle(color: gray04Color))
          ])
        ]),
      )
    );
  }
}
