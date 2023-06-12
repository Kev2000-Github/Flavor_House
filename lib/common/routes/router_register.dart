import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/register/step_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class RegisterRoute implements IRoute{
  final String _route = routes.register;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const RegisterScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}