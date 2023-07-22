import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/login/login.dart';
import 'package:flavor_house/screens/profile/change_password.dart';
import 'package:flavor_house/screens/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class ChangePasswordRoute implements IRoute{
  final String _route = routes.change_password;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}