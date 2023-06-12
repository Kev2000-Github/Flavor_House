import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class LoginRoute implements IRoute{
  final String _route = routes.login;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const LoginScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}