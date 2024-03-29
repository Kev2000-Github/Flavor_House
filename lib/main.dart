import 'package:flavor_house/common/routes/route_generator.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => UserProvider())
    ], child: const MyApp())
  );
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
