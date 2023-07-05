import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/screens/create_post/create_post_moment.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart' as routes;

class CreatePostRoute implements IRoute{
  final String _route = routes.createpost;

  @override
  Route getRoute(Object? args) {
    return MaterialPageRoute(builder: (_) => const CreatePostMomentScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}