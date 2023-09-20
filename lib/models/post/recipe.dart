import 'package:flavor_house/models/post/post.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flutter/material.dart';

class Recipe extends Post {
  final String title;
  final int stars;
  final List<Tag> tags;

  Recipe(
      String id,
      String userId,
      String username,
      String fullName,
      String? avatarURL,
      String description,
      int likes,
      bool isLiked,
      bool isFavorite,
      String? pictureURL,
      DateTime createdAt,
      this.title,
      this.stars,
      this.tags)
      : super(id, userId, username, fullName, avatarURL, description, likes, isLiked, isFavorite, pictureURL, createdAt);

}
