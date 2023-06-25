import 'package:flutter/cupertino.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User user = User.initial();

  void login(User loggedUser){
    user = loggedUser;
    notifyListeners();
  }

  void update(User updatedUser){
    user = updatedUser;
    notifyListeners();
  }

  void logout(){
    user = User.initial();
    notifyListeners();
  }

  bool isUserLogged() {
    return user.id != User.initial().id;
  }
}