import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/Create Posts/CreatePost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

import '../constants/routes.dart' as routes;

class CreatePostRoute implements IRoute{
  final String _route = routes.createpost;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const CreatePostScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}