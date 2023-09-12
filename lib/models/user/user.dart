import 'package:equatable/equatable.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String? gender;
  final String? phoneNumber;
  final Country? country;
  final String? pictureURL;
  String? token;
  bool? isFollowed;
  int? step;

  User(this.id, this.username, this.fullName, this.email, this.gender,
      this.phoneNumber, this.country, this.pictureURL, this.isFollowed);

  @override
  List<Object> get props => [id, username, fullName, email];

  factory User.basic(
      String id, String username, String fullName, String email) {
    return User(id, username, fullName, email, null, null, null, null, null);
  }

  factory User.fromUserItem(UserItem userItem) {
    return User(userItem.id, userItem.username, userItem.fullName, "NONE", null,
        null, null, userItem.avatarURL, userItem.isFollowed);
  }

  factory User.initial() {
    return User.basic("", "NONE", "NONE", "NONE");
  }

  factory User.fromJson(Map<String, dynamic> json) {
    var jsonCountry = json['Country'] ?? json['country'];
    var country;
    if(jsonCountry != null){
      country = Country(jsonCountry['id'], jsonCountry['name']);
    }
    User user = User(json['id'], json['username'], json['fullName'], json['email'],
        json['sex'], json['phoneNumber'], country, json['pictureURL'], json['isFollowed']);
    if(json['token'] != null) user.token = json['token'];
    user.step = json['step'];
    return user;
  }

  bool isInitial() {
    return id == "";
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
      "gender": gender,
      "phoneNumber": phoneNumber,
      "pictureURL": pictureURL,
      "token": token
    };
    final country = this.country;
    if(country != null){
      map['country'] = {
        "id": country.id,
        "name": country.name
      };
    }
    return map;
  }
}
