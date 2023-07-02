
import 'package:flutter/material.dart';
class UserItem{
  final String id;
  final String username;
  final String fullName;
  final String location;
  final Image? avatar;
  final bool isFollowed;

  UserItem(this.id, this.username, this.fullName, this.location, this.avatar, this.isFollowed);


}