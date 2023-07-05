import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/forgotpassword/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class ForgotPasswordRoute implements IRoute{
  final String _route = routes.forgotpassword;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}