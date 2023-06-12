import 'package:flavor_house/common/routes/router.dart';
import 'package:flutter/material.dart';

import '../../screens/register/step_two.dart';
import '../constants/routes.dart' as routes;

class RegisterTwoRoute implements IRoute{
  final String _route = routes.register_two;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const RegisterTwoScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}