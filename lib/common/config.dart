import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  static String locale = "es";
  static String backURL = dotenv.env['BACK_URL'] ?? '10.0.2.2:3000';
  static Map<String, String> headerInitial = {'Content-Type': 'application/json'};
  static Map<String, String> headerAuth(String token) {
    return {
      'Content-Type': 'application/json',
      'authorization': token
    };
  }
}