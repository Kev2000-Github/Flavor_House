import 'package:equatable/equatable.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  late String id;
  late String username;
  late String fullName;
  late String email;
  late String? sex;
  late String? phoneNumber;
  late String? countryId;
  late Image? picture;

  User(this.id, this.username, this.fullName, this.email, this.sex,
      this.phoneNumber, this.countryId, this.picture);

  @override
  List<Object> get props => [id, username, fullName, email];

  factory User.basic(
      String id, String username, String fullName, String email) {
    return User(id, username, fullName, email, null, null, null, null);
  }

  factory User.fromUserItem(UserItem userItem) {
    return User(userItem.id, userItem.username, userItem.fullName, "NONE", null,
        null, null, userItem.avatar);
  }

  factory User.initial() {
    return User.basic("", "NONE", "NONE", "NONE");
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['id'], json['username'], json['fullName'], json['email'],
        json['sex'], json['phoneNumber'], json['countryId'], json['picture']);
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
      "picture": picture
    };
    return map;
  }
}
