import 'package:flavor_house/common/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../../screens/welcome/welcome.dart';
import '../constants/routes.dart' as routes;

class WelcomeRoute implements IRoute{
  final String _route = routes.welcome;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const WelcomeScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}