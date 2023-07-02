import 'package:equatable/equatable.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? sex;
  final String? phoneNumber;
  final String? countryId;
  final String? pictureURL;

  User(this.id, this.username, this.fullName, this.email, this.sex,
      this.phoneNumber, this.countryId, this.pictureURL);

  @override
  List<Object> get props => [id, username, fullName, email];

  factory User.basic(
      String id, String username, String fullName, String email) {
    return User(id, username, fullName, email, null, null, null, null);
  }

  factory User.fromUserItem(UserItem userItem) {
    return User(userItem.id, userItem.username, userItem.fullName, "NONE", null,
        null, null, userItem.avatarURL);
  }

  factory User.initial() {
    return User.basic("", "NONE", "NONE", "NONE");
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['username'], json['fullName'], json['email'],
        json['sex'], json['phoneNumber'], json['countryId'], json['pictureURL']);
  }

  Image get picture {
    //TODO: change dummy implementation later
    if(pictureURL != null) return Image.asset(pictureURL!);
    return Image.asset("assets/images/user_avatar.png");
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      "id": id,
      "email": email,
      "username": username,
      "fullName": fullName,
      "email": email,
      "sex": sex,
      "phoneNumber": phoneNumber,
      "countryId": countryId,
      "pictureURL": pictureURL
    };
    return map;
  }
}
