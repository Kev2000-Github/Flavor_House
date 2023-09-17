import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/services/auth/dummy_auth_service.dart';
import 'package:flavor_house/services/auth/http_auth_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../models/user/user.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailFocus.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
      onTap: () {
        _emailFocus.unfocus();
      },
      child: Stack(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, size: 24)))),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              width: double.infinity,
              child: Column(children: [
                // svg image
                // text field input for email
                const SizedBox(height: 48),
                const Text(
                  "Recuperar Contraseña",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Introduce tu correo electronico para recuperar tu contrasena, enviaremos un email con el codigo",
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 32),
                TextFieldInput(
                    hintText: "Enter your email",
                    focusNode: _emailFocus,
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController),

                Flexible(flex: 2, child: Container()),
                // button sendemail
                Button(
                  text: "Enviar correo",
                  onPressed: () async {
                    String email = _emailController.value.text;
                    //TODO: Beware this is a dummy implementation!
                    Auth auth = HttpAuth();
                    dartz.Either<Failure, User> result =
                        await auth.forgotpassword(email);
                    result.fold(
                        (failure) => showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  title: const Text("Perdon!"),
                                  content: const Text(
                                      "Tu correo electronico está incorrecto, por favor ingreselo de nuevo"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text("ok"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )),
                        (user) => Navigator.of(context)
                            .pushNamed(routes.forgot_password_code));
                  },
                  borderSide: null,
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  size: const Size.fromHeight(50),
                ),

                const SizedBox(height: 24),
              ]))
        ],
      ),
    )));
  }
}
