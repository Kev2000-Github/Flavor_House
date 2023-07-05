import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/screens/register/step_two_country.dart';
import 'package:flavor_house/screens/register/step_two_gender.dart';
import 'package:flavor_house/screens/register/step_two_interests.dart';
import 'package:flavor_house/services/register/dummy_register_step_two_service.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../utils/colors.dart';

class RegisterTwoScreen extends StatefulWidget {
  const RegisterTwoScreen({Key? key}) : super(key: key);

  @override
  State<RegisterTwoScreen> createState() => _RegisterTwoScreenState();
}

class _RegisterTwoScreenState extends State<RegisterTwoScreen> {
  int _currentStep = 0;
  late String? _gender;
  late String _country;
  final List<String> _interests = [];
  bool isFinished = false;

  void onGenderStepContinue(String? value) {
    _gender = value;
    onContinue();
  }

  void onCountryStepContinue(String val) {
    _country = val;
    onContinue();
  }

  void onInterestsUpdate(String id) {
    if (_interests.contains(id))
      _interests.remove(id);
    else
      _interests.add(id);
  }

  void onFinish(bool _isFinished) {
    isFinished = _isFinished;
    setState(() {});
  }

  void onContinue() {
    if (_currentStep < (stepList().length - 1)) {
      _currentStep += 1;
    }
    setState(() {});
  }

  void onReturn() {
    if (_currentStep > 0) {
      _currentStep -= 1;
    }
    setState(() {});
  }

  List<Step> stepList() => [
        Step(
            title: Text("Genero"),
            content: StepGender(onGenderSelect: onGenderStepContinue),
            state: StepState.editing,
            isActive: _currentStep >= 0),
        Step(
            title: Text("Pais"),
            content: StepCountry(
              onCountrySelect: onCountryStepContinue,
            ),
            state: StepState.editing,
            isActive: _currentStep >= 1),
        Step(
            title: Text("Intereses"),
            content: StepInterests(
              onFinish: onFinish,
            ),
            state: StepState.editing,
            isActive: _currentStep >= 2)
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      if (_currentStep == 0)
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      else
                        onReturn();
                    },
                    icon: Icon(
                      (() => _currentStep == 0
                          ? Icons.close
                          : Icons.arrow_back_ios)(),
                      size: 24,
                      color: blackColor,
                    )),
                actions: isFinished
                    ? [
                        IconButton(
                            onPressed: () async {
                              RegisterStepTwo register = DummyRegisterStepTwo();
                              dartz.Either<Failure, User> result = await register.registerAdditionalInfo(_country, _gender, _interests);
                              result.fold((l) => null, (User user) async {
                                await Provider.of<UserProvider>(context, listen: false).login(user);
                                if(context.mounted) Navigator.of(context).pushNamed(routes.main_screen);
                              });
                            },
                            icon: const Icon(Icons.arrow_forward_ios,
                                size: 24, color: blackColor))
                      ]
                    : [])),
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
