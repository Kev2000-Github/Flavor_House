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
    return UserItem(json['id'], json['username'], json['fullName'], "Venezuela", "assets/images/avatar.jpg", true);
  }

  Image get avatar {
    //TODO: change dummy implementation later
    if (avatarURL != null) return Image.asset(avatarURL!);
    return Image.asset("assets/images/user_avatar.png");
  }
}
