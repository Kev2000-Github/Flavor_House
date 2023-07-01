import 'package:flutter/cupertino.dart';

import '../models/user/user.dart';
import '../utils/cache.dart';

class UserProvider extends ChangeNotifier {
  User user = User.initial();

  Future<void> login(User loggedUser) async {
    await setLocalUser(user);
    user = loggedUser;
    notifyListeners();
  }

  Future<void> update(User updatedUser) async {
    user = updatedUser;
    notifyListeners();
  }

  Future<void> logout() async {
    await removeLocalUser();
    user = User.initial();
    notifyListeners();
  }

  bool isUserLogged() {
    return user.id != User.initial().id;
  }
}