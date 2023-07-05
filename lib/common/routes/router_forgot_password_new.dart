import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/forgot_password/forgot_password_new.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class ForgotPasswordNewRoute implements IRoute{
  final String _route = routes.forgot_password_new;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const ForgotPasswordNewScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}