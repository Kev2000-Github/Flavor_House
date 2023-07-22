import 'package:flavor_house/widgets/avatar.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _currentPasswordController = TextEditingController();
  late final _newPasswordController = TextEditingController();
  late final _confirmNewPasswordController = TextEditingController();

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
                const Avatar(pictureHeight: 80, borderSize: 2, image: null),
                const SizedBox(height: 16.0),
                Text(
                  "La contraseña debe tener al menos seis caracteres e incluir una combinación de números, letras y caracteres especiales (!@%).",
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _currentPasswordController,
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
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmNewPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Nueva Contraseña',
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Agregar lógica para cambiar la contraseña
                    }
                  },
                  child: const Text('Cambiar Contraseña'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFEC5151), // Botón Rojo
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
