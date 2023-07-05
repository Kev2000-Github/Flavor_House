import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/screens/create_post/recipe/preparation_step.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/user/user.dart';
import '../../../utils/colors.dart';
import 'general_step.dart';
import 'ingredients_step.dart';

class CreatePostRecipeScreen extends StatefulWidget {
  const CreatePostRecipeScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostRecipeScreen> createState() => _CreatePostRecipeScreenState();
}

class _CreatePostRecipeScreenState extends State<CreatePostRecipeScreen> {
  int _currentStep = 0;
  bool isFinished = false;
  User? user;

  @override
  initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
  }

  List<Step> stepList() => [
        Step(
            title: const Text("General"),
            content: GeneralStep(
              user: user ?? User.initial(),
            ),
            state: StepState.editing,
            isActive: _currentStep >= 0),
        Step(
            title: const Text("Ingredientes"),
            content: IngredientStep(),
            state: StepState.editing,
            isActive: _currentStep >= 1),
        Step(
            title: const Text("Preparacion"),
            content: PreparationStep(),
            state: StepState.editing,
            isActive: _currentStep >= 2)
      ];

  bool isNotLastStep() {
    return _currentStep < (stepList().length - 1);
  }

  void onContinue() {
    if (isNotLastStep()) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void onPublish() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
                toolbarHeight: 50,
                flexibleSpace: Container(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Crear Receta",
                  style: TextStyle(
                      color: blackColor,
                      fontSize: 28,
                      fontWeight: FontWeight.w600),
                ),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: blackColor,
                    )),
                actions: isFinished
                    ? [
                        IconButton(
                            onPressed: () async {},
                            icon: const Icon(Icons.arrow_forward_ios,
                                size: 24, color: blackColor))
                      ]
                    : [])),
        body: Stepper(
            onStepContinue: () {
              if (_currentStep <= stepList().length) {
                _currentStep += 1;
              }
              setState(() {});
            },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep -= 1;
                }
              });
            },
            type: StepperType.horizontal,
            currentStep: _currentStep,
            steps: stepList(),
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _currentStep > 0 ? onBack : null,
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(5),
                        backgroundColor: gray04Color),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: whiteColor,
                      size: 20,
                    ),
                  ),
                  isNotLastStep()
                      ? ElevatedButton(
                          onPressed: onContinue,
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(5),
                              backgroundColor: primaryColor),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: whiteColor,
                            size: 20,
                          ),
                        ) :
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(primaryColor)),
                      onPressed: onPublish,
                      child: const Text(
                        "publicar",
                        style: TextStyle(color: whiteColor, fontSize: 18, fontWeight: FontWeight.w600),
                      ))
                ],
              );
            }));
  }
}
