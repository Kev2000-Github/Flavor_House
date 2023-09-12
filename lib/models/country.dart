

import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String id;
  final String name;

  Country(this.id, this.name);

  @override
  List<Object> get props => [id, name];

  factory Country.initial() {
    return Country('','');
  }

  factory Country.fromJson(Map<String, dynamic> json){
    return Country(
        json['id'],
        json['name'],
    );
  }
}