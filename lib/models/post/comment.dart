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

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(json['id'], json['User']['id'], json['User']['username'], json['User']['fullName'], json['content'], json['createdAt'], json['User']['avatar']);
  }

  Image get picture{
    if(avatarURL != null) return Image.network(avatarURL!);
    return Image.asset("assets/images/user_avatar.png");
  }
}