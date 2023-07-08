import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/post_moment.dart';
import 'package:flavor_house/widgets/post_recipe.dart';
import 'package:flavor_house/widgets/user_item.dart';
import 'package:flutter/material.dart';

class Helper {
  static PostMoment createMomentWidget(Moment post, String userId) {
    return PostMoment(
      isSameUser: post.userId == userId,
      post: post
    );
  }

  static PostRecipe createRecipeWidget(Recipe recipe, String userId) {
    return PostRecipe(
      isSameUser: recipe.userId == userId,
      post: recipe,
    );
  }

  static UserItemWidget createUserItemWidget(UserItem userInfo) {
    return UserItemWidget(
      user: userInfo,
    );
  }

  static RichText createPostDescription(String description) {
    List<String> splitDescription = description.split("#");
    return RichText(
        text: TextSpan(
            style: DesignTextTheme.get(type: TextThemeEnum.grayLight),
            children: [TextSpan(text: description)]));
  }
}
