import 'package:flavor_house/common/routes/router_home.dart';
import 'package:flavor_house/common/routes/router_login.dart';
import 'package:flavor_house/common/routes/router_register.dart';
import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/common/routes/router_register_two.dart';
import 'package:flavor_house/common/routes/router_welcome.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    List<IRoute> routes = [WelcomeRoute(), RegisterRoute(), RegisterTwoRoute(), LoginRoute(), MainRoute()];
    for (IRoute router in routes) {
      if (settings.name != router.route) continue;
      router.validate(args);
      return router.getRoute(args);
    }
    return _errorRoute();
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(child: Text('Error')));
  });
}
