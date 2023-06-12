import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/home/home.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart' as routes;

class HomeRoute implements IRoute{
  final String _route = routes.home;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const HomeScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}