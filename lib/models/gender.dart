

import 'package:equatable/equatable.dart';

class Gender extends Equatable {
  final String id;
  final String name;

  const Gender(this.id, this.name);
  factory Gender.initial() {
    return const Gender("","");
  }
  factory Gender.fromString(String id) {
    switch(id){
      case 'MAN': return Gender.man();
      case 'WOMAN': return Gender.woman();
      case 'NONE': return Gender.none();
      default: return Gender.initial();
    }
  }
  factory Gender.man() {
    return const Gender('MAN', 'Hombre');
  }

  factory Gender.woman() {
    return const Gender('WOMAN', 'Mujer');
  }

  factory Gender.none() {
    return const Gender('NONE', 'No quiero decirlo');
  }

  @override
  List<Object> get props => [id, name];

  factory Gender.fromJson(Map<String, dynamic> json){
    return Gender(
        json['id'],
        json['name'],
    );
  }
}