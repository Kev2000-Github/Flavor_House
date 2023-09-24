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
  final _formKey = GlobalKey<FormState>();

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

  InputDecoration getDecoration(String hintText) {
    final inputBorder =
    OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return InputDecoration(
      hintText: hintText,
      border: inputBorder,
      focusedBorder: inputBorder,
      enabledBorder: inputBorder,
      filled: true,
      contentPadding: const EdgeInsets.all(8),
    );
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
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    TextFormField(
                      controller: _usernameController,
                      focusNode: _usernameFocus,
                      validator: (val) {
                        if(val == null || val.isEmpty) return 'nombre de usuario vacio';
                        return null;
                      },
                      decoration: getDecoration("nombre de usuario"),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _fullNameController,
                      focusNode: _fullNameFocus,
                      validator: (val) {
                        if(val == null || val.isEmpty) return 'Nombre vacio';
                        return null;
                      },
                      decoration: getDecoration("Nombre completo"),
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      validator: (val) {
                        if(val == null || val.isEmpty) return 'Correo electronico vacio';
                        return null;
                      },
                      decoration: getDecoration("Correo electronico"),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      validator: (val) {
                        if(val == null || val.isEmpty) return 'contraseña vacia';
                        return null;
                      },
                      decoration: getDecoration("Contraseña"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _repeatPasswordController,
                      focusNode: _repeatPasswordFocus,
                      validator: (val) {
                        if(val == null || val.isEmpty) return 'contraseña vacia';
                        if(val != _passwordController.text) return 'Las contraseñas no coinciden';
                        return null;
                      },
                      decoration: getDecoration("Repite la contraseña"),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Button(
                          text: "Registrarse",
                          onPressed: () async {
                            if(!_formKey.currentState!.validate()) return;
                            String email = _emailController.value.text;
                            String password = _passwordController.value.text;
                            String fullName = _fullNameController.value.text;
                            String username = _usernameController.value.text;
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
                  ]))
          ),
        )));
  }
}
