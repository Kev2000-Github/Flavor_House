import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/user/user_item.dart';
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
        avatar: post.avatar ?? Image.asset("assets/images/avatar.jpg"),
        picture: post.picture ?? Image.asset("assets/images/cookies.jpg"));
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
      picture: recipe.picture ?? Image.asset("assets/images/cookies.jpg"),
      postTitle: recipe.title,
      rates: recipe.stars,
    );
  }

  static UserItemWidget createUserItemWidget(UserItem userInfo) {

    return UserItemWidget(user: userInfo,);
  }
}
