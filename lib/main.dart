import 'package:flavor_house/common/routes/route_generator.dart';
import 'package:flavor_house/screens/login/login.dart';
import 'package:flavor_house/screens/welcome/welcome.dart';
import 'package:flavor_house/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flavor House',
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Inter',
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute
    );
  }
}
