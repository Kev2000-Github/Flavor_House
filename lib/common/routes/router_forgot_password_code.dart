import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/forgot_password/forgot_password_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class ForgotPasswordCodeRoute implements IRoute{
  final String _route = routes.forgot_password_code;

  @override
  Route getRoute(Object? args) {
    String email = args as String;
    return MaterialPageRoute(builder: (_) => ForgotPasswordCodeScreen(email: email));
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}