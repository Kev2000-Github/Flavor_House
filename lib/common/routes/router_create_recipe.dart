import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/screens/create_post/create_post_moment.dart';
import 'package:flavor_house/screens/create_post/recipe/create_post_recipe.dart';
import 'package:flutter/material.dart';

import '../constants/routes.dart' as routes;

class CreateRecipeRoute implements IRoute{
  final String _route = routes.create_recipe;

  @override
  Route getRoute(Object? args) {
    if(args is Recipe){
      Recipe recipe = args;
      return MaterialPageRoute(builder: (_) => CreatePostRecipeScreen(recipe: recipe,));
    }
    return MaterialPageRoute(builder: (_) => const CreatePostRecipeScreen());
  }

  @override
  void validate(Object? args) {

  }

  @override
  String get route => _route;

}