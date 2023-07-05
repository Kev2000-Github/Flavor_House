import 'package:flavor_house/models/post/post.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flutter/material.dart';

class Recipe extends Post {
  final String title;
  final double stars;
  final List<Tag> tags;

  Recipe(
      String id,
      String username,
      String fullName,
      Image? avatar,
      String description,
      int likes,
      bool isLiked,
      bool isFavorite,
      Image? picture,
      this.title,
      this.stars,
      this.tags)
      : super(id, username, fullName, avatar, description, likes, isLiked, isFavorite, picture);

}
