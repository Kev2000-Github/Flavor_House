import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/screens/profile/skeleton_profile.dart';
import 'package:flavor_house/widgets/avatar.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  User user = User.initial();

  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: user.fullName);
  late final _usernameController = TextEditingController(text: user.username);
  late final _phoneController = TextEditingController(text: user.phoneNumber);
  late final _countryController = TextEditingController(text: user.countryId);
  late final _genderController = TextEditingController(text: user.gender);

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
    return Conditional(
      condition: !user.isInitial(),
      positive:Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Editar perfil',
            style:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Guardar la información de perfil
                  // ...
                  // Y luego navega de vuelta a la pantalla de perfil.
                  // Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Avatar(
                      pictureHeight: 80,
                      borderSize: 2,
                      image: user.picture),
                  TextButton(
                    onPressed: () {
                      // Agregar lógica para seleccionar un archivo
                    },
                    child: const Text(
                      'Editar Foto',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Teléfono',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: null,
                    decoration: const InputDecoration(
                      labelText: 'País',
                    ),
                    items: <String>['Pais1', 'Pais2', 'Pais3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _countryController.text = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: null,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                    ),
                    items: <String>['Hombre', 'Mujer', 'Otro']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _genderController.text = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Agregar lógica para navegar a la página de cambio de contraseña
                      Navigator.pushNamed(context, routes.change_password);
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
      ),
      negative: const SingleChildScrollView(
          child: SkeletonProfile(
            items: 2,
          ))
    );
  }
}
