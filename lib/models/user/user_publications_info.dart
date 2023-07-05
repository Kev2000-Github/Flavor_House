

import 'package:equatable/equatable.dart';

class UserPublicationsInfo extends Equatable{
  final String username;
  final String fullName;
  final int publications;
  final int followers;
  final int followed;

  UserPublicationsInfo(this.publications, this.followers, this.followed, this.username, this.fullName);

  @override
  List<Object> get props => [publications, followers, followed, username, fullName];
}