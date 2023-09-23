import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/common/popups/forgot_password.dart';
import 'package:flavor_house/services/auth/http_auth_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/Avatar.dart';
import '../../widgets/button.dart';

class ForgotPasswordNewScreen extends StatefulWidget {
  const ForgotPasswordNewScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordNewScreen> createState() =>
      _ForgotPasswordNewScreenState();
}

class _ForgotPasswordNewScreenState extends State<ForgotPasswordNewScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  late final _confirmNewPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User user = User.initial();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Avatar(pictureHeight: 80, borderSize: 2, image: user.picture),
              const SizedBox(height: 16.0),
              const Text(
                "La contraseña debe tener al menos seis caracteres e incluir una combinación de números, letras y caracteres especiales (!@%).",
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Contraseña vacia';
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmNewPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nueva Contraseña',
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Contraseña vacia';
                  if (val != _newPasswordController.text)
                    return 'Las contraseñas no coinciden';
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String password = _newPasswordController.value.text;
                    Auth auth = HttpAuth();
                    dartz.Either<Failure, bool> result =
                        await auth.newPassword(password);
                    result
                        .fold((failure) => CommonPopup.alert(context, failure),
                            (user) async {
                      ForgotPasswordPopup.Passwordsucessful(context, () {
                        Navigator.of(context).pushNamed(routes.main_screen);
                      });
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC5151), // Botón Rojo
                ),
                child: const Text('Cambiar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    )));
  }
}
