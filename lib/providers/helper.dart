
import 'package:flavor_house/common/config.dart';
import 'package:flavor_house/common/session.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user/user.dart';
import '../utils/cache.dart';

class ProviderHelper {
  static Future<User?> getLoggedUser(BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    Session session = Session();
    if (userProvider.isUserLogged()){
      session.token = userProvider.user.token ?? '';
      return userProvider.user;
    }
    User? loggedUser = await getLocalUser();
    print(loggedUser?.token);
    if(loggedUser == null) return null;
    userProvider.update(loggedUser);
    session.token = loggedUser.token ?? '';
    return userProvider.user;
  }
}