import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

String userData = "userData";

Future<void> setLocalUser(User loggedUser) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String fomattedUser = jsonEncode(loggedUser.toJson());
  await pref.setString(userData, fomattedUser);
}

Future<User?> getLocalUser() async {
  try{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? stringUser = pref.getString(userData);
    if(stringUser == null) return null;
    Map<String, dynamic> mappedUser = jsonDecode(stringUser);
    User localUser = User.fromJson(mappedUser);

    return localUser;
  }
  catch(e){
    return null;
  }
}
