

import 'package:flutter/material.dart';

abstract class Post {
  final String id;
  final String username;
  final String fullName;
  final Image? avatar;
  final String description;
  final int likes;
  final bool isLiked;
  final bool isFavorite;
  final Image? picture;
  final DateTime createdAt;

  Post(this.id, this.username, this.fullName, this.avatar, this.description, this.likes,
      this.isLiked, this.isFavorite, this.picture, this.createdAt);
}