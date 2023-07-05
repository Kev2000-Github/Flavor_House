import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/services/auth/dummy_auth_service.dart';
import 'package:flavor_house/utils/cache.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/popups/login.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailFocus.dispose();
    _emailController.dispose();
    _passwordFocus.dispose();
    _passwordController.dispose();
  }

  void onLogin() async {
    String email = _emailController.value.text;
    String password = _passwordController.value.text;
    //TODO: Beware this is a dummy implementation!
    Auth auth = DummyAuth();
    dartz.Either<Failure, User> result = await auth.login(email, password);
    result.fold((failure) {
      if (failure.runtimeType == LoginFailure) {
        LoginPopup.alertLoginFailure(context);
      } else if (failure.runtimeType == LoginEmptyFailure) {
        LoginPopup.alertLoginEmptyFailure(context);
      }
    }, (user) async {
      await Provider.of<UserProvider>(context, listen: false).login(user);
      if (context.mounted) Navigator.of(context).pushNamed(routes.main_screen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
      onTap: () {
        _emailFocus.unfocus();
        _passwordFocus.unfocus();
      },
      child: Stack(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, size: 24)))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(children: [
                // svg image
                // text field input for email
                const SizedBox(height: 32),
                const Text(
                  "Inicio Sesion",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 32),
                TextFieldInput(
                    hintText: "Ingresa tu correo",
                    focusNode: _emailFocus,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController),
                const SizedBox(height: 24),
                // text field input for password
                TextFieldInput(
                  hintText: "Ingresa tu contraseña",
                  textInputType: TextInputType.text,
                  focusNode: _passwordFocus,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                Flexible(flex: 2, child: Container()),
                // button login
                Button(
                  text: "Iniciar Sesion",
                  onPressed: onLogin,
                  borderSide: null,
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  size: const Size.fromHeight(50),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(routes.forgotpassword);
                      },
                      child: const Text("¿Se te olvido la contraseña?",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15)),
                    )),
                const SizedBox(height: 24),
              ]))
        ],
      ),
    )));
  }
}
