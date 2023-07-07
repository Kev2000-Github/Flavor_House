import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/screens/main/main.dart';
import 'package:flavor_house/screens/profile/profile.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart' as routes;

class OtherUserProfileRoute implements IRoute{
  final String _route = routes.other_user_profile;

  @override
  Route getRoute(Object? args) {
    if(args is UserItem){
      UserItem? userItem = args;
      return MaterialPageRoute(builder: (_) => ProfileScreen(userId: userItem.id,));
    }
    return MaterialPageRoute(builder: (_) => const ProfileScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}