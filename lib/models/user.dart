
import 'package:equatable/equatable.dart';

class User extends Equatable {
  late String id;
  late String username;
  late String fullName;
  late String email;
  late String? sex;
  late String? phoneNumber;
  late String? countryId;
  late String? picture;

   User(this.id, this.username, this.fullName, this.email, this.sex,
      this.phoneNumber, this.countryId, this.picture);

   User.basic(this.id, this.username, this.fullName, this.email);

  @override
  List<Object> get props => [id, username, fullName, email];

  factory User.initial(){
    return User.basic(
      "",
      "NONE",
      "NONE",
      "NONE"
    );
  }

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