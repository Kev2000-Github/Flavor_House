import 'package:flutter/material.dart';

class UserItem {
  final String id;
  final String username;
  final String fullName;
  final String location;
  final String? avatarURL;
  final bool isFollowed;

  UserItem(this.id, this.username, this.fullName, this.location, this.avatarURL,
      this.isFollowed);

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(json['id'], json['username'], json['fullName'], json['Country']['name'], json['avatar'], true);
  }

  Image get avatar {
    if (avatarURL != null) return Image.network(avatarURL!);
    return Image.asset("assets/images/user_avatar.png");
  }
}
