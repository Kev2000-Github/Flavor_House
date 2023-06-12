

import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String sex;
  final String phoneNumber;
  final String countryId;

  Post(this.id, this.username, this.fullName, this.email, this.sex,
      this.phoneNumber, this.countryId);

  @override
  List<Object> get props => [id, username, fullName, email, sex, phoneNumber, countryId];

  factory Post.fromJson(Map<String, dynamic> json){
    return Post(
        json['id'],
        json['username'],
        json['fullName'],
        json['email'],
        json['sex'],
        json['phoneNumber'],
        json['countryId']
    );
  }
}