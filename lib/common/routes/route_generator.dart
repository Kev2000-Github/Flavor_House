import 'package:flavor_house/common/routes/router.dart';
import 'package:flavor_house/common/routes/router_create_post.dart';
import 'package:flavor_house/common/routes/router_create_recipe.dart';
import 'package:flavor_house/common/routes/router_forgot_password.dart';
import 'package:flavor_house/common/routes/router_forgot_password_code.dart';
import 'package:flavor_house/common/routes/router_forgot_password_new.dart';
import 'package:flavor_house/common/routes/router_home.dart';
import 'package:flavor_house/common/routes/router_login.dart';
import 'package:flavor_house/common/routes/router_other_user_profile.dart';
import 'package:flavor_house/common/routes/router_register.dart';
import 'package:flavor_house/common/routes/router_register_two.dart';
import 'package:flavor_house/common/routes/router_welcome.dart';
import 'package:flavor_house/common/routes/router_change_password.dart';
import 'package:flavor_house/common/routes/router_edit_profile.dart';
import 'package:flavor_house/common/routes/select_country.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    List<IRoute> routes = [
      WelcomeRoute(),
      RegisterRoute(),
      RegisterTwoRoute(),
      LoginRoute(),
      MainRoute(),
      CreatePostRoute(),
      OtherUserProfileRoute(),
      CreateRecipeRoute(),
      ForgotPasswordRoute(),
      ForgotPasswordCodeRoute(),
      ForgotPasswordNewRoute(),
      EditProfileRoute(),
      ChangePasswordRoute(),
      SelectCountryRoute()
    ];
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
