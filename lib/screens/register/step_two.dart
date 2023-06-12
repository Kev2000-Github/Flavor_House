import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/screens/register/step_two_country.dart';
import 'package:flavor_house/screens/register/step_two_gender.dart';
import 'package:flavor_house/services/auth/dummy_auth_service.dart';
import 'package:flavor_house/services/register/dummy_register_step_one_service.dart';
import 'package:flavor_house/services/register/register_step_one_service.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/colors.dart';
import '../../widgets/button.dart';

class RegisterTwoScreen extends StatefulWidget {
  const RegisterTwoScreen({Key? key}) : super(key: key);

  @override
  State<RegisterTwoScreen> createState() => _RegisterTwoScreenState();
}

class _RegisterTwoScreenState extends State<RegisterTwoScreen> {
  int _currentStep = 0;
  late String? _gender;
  late String _country;
  late List<String?> _interests;

  void onGenderStepContinue(String? value) {
    _gender = value;
    onContinue();
  }

  void onCountryStepContinue(String val) {
    _country = val;
    onContinue();
  }

  void onInterestsUpdate(String id){
    if(_interests.contains(id)) _interests.remove(id);
    else _interests.add(id);

  }

  void onFinish() {

  }

  void onContinue() {
    if(_currentStep < (stepList().length - 1)){
      _currentStep += 1;
    }
    setState(() {

    });
  }

  void onReturn() {
    if(_currentStep > 0){
      _currentStep -= 1;
    }
    setState(() {

    });
  }

  List<Step> stepList() => [
        Step(
            title: Text("Genero"),
            content: StepGender(onGenderSelect: onGenderStepContinue),
            state: StepState.editing,
            isActive: _currentStep >= 0),
        Step(
            title: Text("Pais"),
            content: StepCountry(onCountrySelect: onCountryStepContinue,),
            state: StepState.editing,
            isActive: _currentStep >= 1),
        Step(
            title: Text("Intereses"),
            content: StepInterests(),
            state: StepState.editing,
            isActive: _currentStep >= 2)
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: blackColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600),
              ),
              leading: IconButton(
                  onPressed: () {
                    if(_currentStep == 0) Navigator.of(context).popUntil((route) => route.isFirst);
                    else onReturn();
                  },
                  icon: Icon(
                    (() => _currentStep == 0 ? Icons.close : Icons.arrow_back_ios)(),
                    size: 24,
                    color: blackColor,
                  )),
            )),
        body: Stepper(
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              children: [
                TextButton(onPressed: () {}, child: const Text("")),
                TextButton(onPressed: () {}, child: const Text(""))
              ],
            );
          },
          type: StepperType.horizontal,
          currentStep: _currentStep,
          steps: stepList(),
        ));
  }
}

class StepInterests extends StatelessWidget {
  const StepInterests({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "¡Bienvenido a Flavor House!",
          style: TextStyle(
              color: blackColor, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10,),
        Text(
          "¡cuentanos sobre tus intereses!",
          style: TextStyle(
              color: gray04Color, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        
      ],
    );
  }
}
