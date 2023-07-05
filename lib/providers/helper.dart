
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user/user.dart';
import '../utils/cache.dart';

class ProviderHelper {
  static Future<User?> getLoggedUser(BuildContext context) async {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.isUserLogged()) return userProvider.user;
    User? loggedUser = await getLocalUser();
    if(loggedUser == null) return null;
    userProvider.update(loggedUser);
    return userProvider.user;
  }
}