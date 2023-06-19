

import 'package:equatable/equatable.dart';

class Interest extends Equatable {
  final String id;
  final String name;
  final String? picURL;

  Interest(this.id, this.name, this.picURL);

  @override
  List<Object> get props => [id, name];

  factory Interest.fromJson(Map<String, dynamic> json){
    return Interest(
        json['id'],
        json['name'],
        json['picURL']
    );
  }
}