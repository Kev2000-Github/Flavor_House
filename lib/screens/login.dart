import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
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
                      hintText: "Enter your email",
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController),
                  const SizedBox(height: 24),
                  // text field input for password
                  TextFieldInput(
                    hintText: "Enter your password",
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                  ),
                  Flexible(child: Container(), flex: 2),
                  // button login
                  const Button(
                    text: "Iniciar Sesion",
                    borderSide: null,
                    backgroundColor: primaryColor,
                    textColor: whiteColor,
                    size: Size.fromHeight(50)
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: const Text("¿Se te olvido la contraseña?",
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 15))),
                  const SizedBox(height: 24),
                ]))));
  }
}
