import 'package:flutter/material.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String fullName;
  final String comment;
  final DateTime createdAt;
  final String? avatarURL;

  Comment(this.id, this.userId, this.username, this.fullName, this.comment, this.createdAt, this.avatarURL);

  Image get picture{
    if(avatarURL != null) return Image.network(avatarURL!);
    return Image.asset("assets/images/user_avatar.png");
  }
}