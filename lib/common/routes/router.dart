import 'package:flutter/cupertino.dart';

abstract class IRoute {
  String get route;

  Route<dynamic> getRoute(Object? args);
  void validate(Object? args);
}