import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/main/main.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart' as routes;

class MainRoute implements IRoute{
  final String _route = routes.main_screen;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const MainScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}