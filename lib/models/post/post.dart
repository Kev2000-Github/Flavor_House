

import 'package:flutter/material.dart';

abstract class Post {
  final String id;
  final String userId;
  final String username;
  final String fullName;
  final String? avatarURL;
  final String description;
  final int likes;
  final bool isLiked;
  final bool isFavorite;
  final String? pictureURL;
  final DateTime createdAt;

  Post(this.id, this.userId, this.username, this.fullName, this.avatarURL, this.description, this.likes,
      this.isLiked, this.isFavorite, this.pictureURL, this.createdAt);

  Image get picture {
    if(pictureURL != null) return Image.network(pictureURL!);
    return Image.asset("assets/images/user_avatar.png");
  }

  Image get avatar {
    //TODO: change dummy implementation later
    if(avatarURL != null) return Image.network(avatarURL!);
    return Image.asset("assets/images/user_avatar.png");
  }
}