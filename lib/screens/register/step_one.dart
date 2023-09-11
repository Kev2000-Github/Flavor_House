import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/services/register/register_step_one_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/register/http_register_step_one_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _emailFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _repeatPasswordFocus = FocusNode();
  final TextEditingController _repeatPasswordController =
      TextEditingController();
  final FocusNode _fullNameFocus = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailFocus.dispose();
    _emailController.dispose();
    _passwordFocus.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _fullNameFocus.dispose();
    _fullNameController.dispose();
    _usernameFocus.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: AppBar(
              toolbarHeight: 80,
              flexibleSpace: Container(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Registro",
                style: TextStyle(
                    color: blackColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    size: 24,
                    color: blackColor,
                  )),
            )),
        body: SafeArea(
            child: GestureDetector(
          onTap: () {
            _emailFocus.unfocus();
            _passwordFocus.unfocus();
          },
          child: SizedBox(
              height: 500,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextFieldInput(
                        hintText: "Nombre de usuario",
                        focusNode: _usernameFocus,
                        textInputType: TextInputType.text,
                        textEditingController: _usernameController),
                    const SizedBox(height: 24),
                    TextFieldInput(
                        hintText: "Nombre completo",
                        focusNode: _fullNameFocus,
                        textInputType: TextInputType.text,
                        textEditingController: _fullNameController),
                    const SizedBox(height: 24),
                    TextFieldInput(
                        hintText: "Correo electronico",
                        focusNode: _emailFocus,
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      hintText: "Contraseña",
                      textInputType: TextInputType.text,
                      focusNode: _passwordFocus,
                      textEditingController: _passwordController,
                      isPass: true,
                    ),
                    const SizedBox(height: 24),
                    TextFieldInput(
                      hintText: "Repite Contraseña",
                      textInputType: TextInputType.text,
                      focusNode: _repeatPasswordFocus,
                      textEditingController: _repeatPasswordController,
                      isPass: true,
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Button(
                          text: "Registrarse",
                          onPressed: () async {
                            String email = _emailController.value.text;
                            String password = _passwordController.value.text;
                            String fullName = _fullNameController.value.text;
                            String username = _usernameController.value.text;
                            //TODO: Beware this is a dummy implementation!
                            RegisterStepOne register = HttpRegisterStepOne();
                            dartz.Either<Failure, User> result = await register
                                .register(username, fullName, email, password);
                            result.fold(
                                (failure) =>
                                    CommonPopup.alert(context, failure),
                                (user) async {
                              await Provider.of<UserProvider>(context,
                                      listen: false)
                                  .login(user);
                              if (context.mounted) {
                                Navigator.of(context)
                                    .pushNamed(routes.register_two);
                              }
                            });
                          },
                          borderSide: null,
                          backgroundColor: primaryColor,
                          textColor: whiteColor,
                          size: const Size(300, 50),
                        ),
                        const SizedBox(height: 90)
                      ],
                    ),
                    Flexible(flex: 2, child: Container()),
                  ]))),
        )));
  }
}
