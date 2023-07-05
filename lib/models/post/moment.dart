import 'package:equatable/equatable.dart';
import 'package:flavor_house/models/post/post.dart';
import 'package:flutter/material.dart';

class Moment extends Post {
  Moment(
      String id,
      String username,
      String fullName,
      Image? avatar,
      String description,
      int likes,
      bool isLiked,
      bool isFavorite,
      Image? picture)
      : super(id, username, fullName, avatar, description, likes, isLiked,
            isFavorite, picture);

}
