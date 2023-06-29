import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/services/register/dummy_register_step_one_service.dart';
import 'package:flavor_house/services/register/register_step_one_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
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
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            toolbarHeight: 80,
            flexibleSpace: Container(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Registro",
              style: TextStyle(
                  color: blackColor, fontSize: 32, fontWeight: FontWeight.w600),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, size: 24,color: blackColor,)),
          )
        ),
        body: SafeArea(
        child: GestureDetector(
          onTap: () {
            _emailFocus.unfocus();
            _passwordFocus.unfocus();
          },
          child: Stack(
            children: [
              Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Wrap(
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
                          RegisterStepOne register = DummyRegisterStepOne();
                          dartz.Either<Failure, User> result = await register
                              .register(username, fullName, email, password);
                          result.fold((failure) => print('failure: $failure'),
                                  (user) {
                                Navigator.of(context)
                                    .pushNamed(routes.register_two);
                              });
                        },
                        borderSide: null,
                        backgroundColor: primaryColor,
                        textColor: whiteColor,
                        size: const Size(300, 50),
                      ),
                      Container(
                          padding: const EdgeInsets.only(top: 20, bottom: 50),
                          child: const Text("¿Se te olvido la contraseña?",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15))),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  width: double.infinity,
                  child: Column(children: [
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
                    Flexible(child: Container(), flex: 2),
                  ]))
            ],
          ),
        )));
  }
}
