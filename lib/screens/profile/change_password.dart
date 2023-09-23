import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/services/user_info/http_user_info_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  User user = User.initial();
  final _formKey = GlobalKey<FormState>();
  late final _currentPasswordController = TextEditingController();
  late final _newPasswordController = TextEditingController();
  late final _confirmNewPasswordController = TextEditingController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cambiar Contraseña',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
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
                  controller: _currentPasswordController,
                  validator: (val) {
                    if(val == null || val.isEmpty) return 'Contraseña vacia';
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Contraseña Actual',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Nueva Contraseña',
                  ),
                  validator: (val) {
                    if(val == null || val.isEmpty) return 'Contraseña vacia';
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
                    if(val == null || val.isEmpty) return 'Contraseña vacia';
                    if(val != _newPasswordController.text) return 'Las contraseñas no coinciden';
                    return null;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      UserInfoService userInfoService = HttpUserInfoService();
                      dartz.Either<Failure, bool> result = await userInfoService.updatePassword(user.id, _newPasswordController.text);
                      result.fold((l) => CommonPopup.alert(context, l), (r) {
                        Navigator.pop(context);
                        Navigator.pop(context);
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
      ),
    );
  }
}
