import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/providers/helper.dart';
import 'package:flavor_house/utils/colors.dart';
import 'package:flavor_house/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/user/user.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    verifyLoggedUser();
    super.initState();
  }

  void verifyLoggedUser() async {
    User? loggedUser = await ProviderHelper.getLoggedUser(context);
    if(loggedUser == null) return;
    if(mounted) Navigator.pushNamed(context, routes.main_screen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(flex: 2, child: Container()),
                      Image.asset('assets/images/logo.png', height: 150),
                      const SizedBox(height: 64),
                      Button(
                        text: "Iniciar Sesion",
                        onPressed: () {
                          Navigator.of(context).pushNamed(routes.login);
                        },
                      ),
                      const SizedBox(height: 24),
                      Button(
                        text: "Registrarse",
                        borderSide: null,
                        backgroundColor: primaryColor,
                        textColor: whiteColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed(routes.register);
                        },
                      ),
                      const SizedBox(height: 24),
                      Flexible(flex: 2, child: Container()),
                    ]))));
  }
}
