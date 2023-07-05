import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/forgotpassword/forgot_password_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class ForgotPasswordCodeRoute implements IRoute{
  final String _route = routes.forgot_password_code;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const ForgotPasswordCodeScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}