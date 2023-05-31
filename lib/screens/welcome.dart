import 'package:flavor_house/utils/colors.dart';
import 'package:flavor_house/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                      SvgPicture.asset('assets/images/logo.svg',
                          height: 150, semanticsLabel: "logo"),
                      const SizedBox(height: 64),
                      const Button(text: "Iniciar Sesion"),
                      const SizedBox(height: 24),
                      const Button(
                        text: "Registrarse",
                        borderSide: null,
                        backgroundColor: primaryColor,
                        textColor: whiteColor,
                      ),
                      const SizedBox(height: 24),
                      Flexible(flex: 2, child: Container()),
                    ]))));
  }
}
