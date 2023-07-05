import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/register/select_country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../../screens/welcome/welcome.dart';
import '../constants/routes.dart' as routes;

class SelectCountryRoute implements IRoute{
  final String _route = routes.select_country;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const SelectCountryScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}