

import 'dart:ui';

class Tag {
  final String id;
  final String name;
  final Color color;

  Tag(this.id, this.name, this.color);

  factory Tag.fromJson(Map<String, dynamic> json){
    return Tag(
        json['id'],
        json['name'],
        json['color']
    );
  }
}