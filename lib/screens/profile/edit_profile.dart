import 'dart:io';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/screens/profile/skeleton_profile.dart';
import 'package:flavor_house/services/register/http_register_step_two_service.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flavor_house/services/user_info/http_user_info_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/widgets/avatar.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/gender.dart';
import '../../utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Image? image;
  File? imageFile;
  User user = User.initial();
  List<Country> availableCountries = [];
  List<Gender> genders = [Gender.man(), Gender.woman(), Gender.none()];

  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: user.fullName);
  late final _usernameController = TextEditingController(text: user.username);
  late final _phoneController = TextEditingController(text: user.phoneNumber);
  late Country country;
  Gender selectedGender = Gender.none();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
        getCountries();
        selectedGender = Gender.fromString(user.gender ?? Gender.none().id);
        country = user.country ?? Country.initial();
      });
    }
  }

  void getCountries() async {
    RegisterStepTwo countryService = HttpRegisterStepTwo();
    dartz.Either<Failure, List<Country>> result = await countryService.getCountries();
    result.fold((failure) => null, (countries) => {
      setState(() {
        availableCountries.addAll(countries);
      })
    });
  }

  void editProfile() async {
    User newUserProfile = User(
      user.id,
      _usernameController.text,
      _nameController.text,
      user.email,
      selectedGender.id,
      _phoneController.text,
      country,
      user.pictureURL,
      user.isFollowed
    );
    UserInfoService userInfoService = HttpUserInfoService();
    dartz.Either<Failure, User> result = await userInfoService.updateUser(
        user: newUserProfile,
        imageFile: imageFile
    );
    result.fold((l) => CommonPopup.alert(context, l), (user) {
      Provider.of<UserProvider>(context, listen: false).login(user);
      Navigator.of(context).pop();
    });
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
                  editProfile();
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
                      image: image ?? user.picture),
                  TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      XFile? pickedFile = await picker.pickImage(
                          source: ImageSource.gallery);
                      if(pickedFile == null) return;
                      imageFile = File(pickedFile.path);
                      image = Image.file(File(pickedFile.path));
                      setState(() {});
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
                  DropdownButtonFormField<Gender>(
                    value: selectedGender,
                    decoration: const InputDecoration(
                      labelText: 'Género',
                    ),
                    items: List.generate(genders.length, (index) => DropdownMenuItem(
                      value: genders[index],
                      child: Text(genders[index].name),
                    )),
                    onChanged: (Gender? newValue) {
                      setState(() {
                        selectedGender = newValue ?? Gender.none();
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                      width: double.infinity,
                      child: ListTile(
                        shape: const Border(
                          bottom: BorderSide()
                        ),
                        title: Text(country.id == Country.initial().id ? "Pais" : country.name,
                            style: const TextStyle(
                                color: gray04Color,
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                        onTap: () async {
                          final selectedCountry = await Navigator.of(context).pushNamed(routes.select_country) as Country;
                          setState(() {
                            country = selectedCountry;
                          });
                        },
                      )),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Agregar lógica para navegar a la página de cambio de contraseña
                      Navigator.pushNamed(context, routes.change_password);
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
      ),
      negative: const SingleChildScrollView(
          child: SkeletonProfile(
            items: 2,
          ))
    );
  }
}
