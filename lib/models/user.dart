
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String email;
  final String sex;
  final String phoneNumber;
  final String countryId;
  final String? picture;

   User(this.id, this.username, this.fullName, this.email, this.sex,
      this.phoneNumber, this.countryId, this.picture);

  @override
  List<Object> get props => [id, username, fullName, email, sex, phoneNumber, countryId];

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      json['id'],
      json['username'],
      json['fullName'],
      json['email'],
      json['sex'],
      json['phoneNumber'],
      json['countryId'],
      json['picture']
    );
  }
}