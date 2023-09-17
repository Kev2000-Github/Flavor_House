import 'package:equatable/equatable.dart';
import 'package:flavor_house/models/post/post.dart';
import 'package:flutter/material.dart';

class Moment extends Post {
  Moment(
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
      DateTime createdAt)
      : super(id, userId, username, fullName, avatarURL, description, likes, isLiked,
            isFavorite, pictureURL, createdAt);

}
