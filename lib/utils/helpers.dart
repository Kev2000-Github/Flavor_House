import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/post_moment.dart';
import 'package:flavor_house/widgets/post_recipe.dart';
import 'package:flavor_house/widgets/user_item.dart';
import 'package:flutter/material.dart';

class Helper {
  static PostMoment createMomentWidget(Moment post) {
    return PostMoment(
      id: post.id,
      fullName: post.fullName,
      username: post.username,
      description: post.description,
      likes: post.likes,
      isLiked: post.isLiked,
      isFavorite: post.isFavorite,
      avatar: post.avatar,
      picture: post.picture,
      createdAt: post.createdAt,
    );
  }

  static PostRecipe createRecipeWidget(Recipe recipe) {
    return PostRecipe(
      id: recipe.id,
      fullName: recipe.fullName,
      username: recipe.username,
      description: recipe.description,
      likes: recipe.likes,
      isLiked: recipe.isLiked,
      isFavorite: recipe.isFavorite,
      avatar: recipe.avatar,
      picture: recipe.picture,
      postTitle: recipe.title,
      rates: recipe.stars,
      tags: recipe.tags,
      createdAt: recipe.createdAt,
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
