import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/screens/create_post/recipe/preparation_step.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/error/failures.dart';
import '../../../models/post/recipe_preparation.dart';
import '../../../models/post/tag.dart';
import '../../../models/user/user.dart';
import '../../../services/paginated.dart';
import '../../../services/post/http_post_service.dart';
import '../../../services/post/post_service.dart';
import '../../../utils/colors.dart';
import 'general_step.dart';
import 'ingredients_step.dart';

class CreatePostRecipeScreen extends StatefulWidget {
  final Recipe? recipe;
  const CreatePostRecipeScreen({Key? key, this.recipe}) : super(key: key);

  @override
  State<CreatePostRecipeScreen> createState() => _CreatePostRecipeScreenState();
}

class _CreatePostRecipeScreenState extends State<CreatePostRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> selectedTags = [];
  List<String> ingredients = [];
  List<RecipePreparationStep> preparationSteps = [];
  String? imageURI;
  String? errorMsg;

  int _currentStep = 0;
  bool isFinished = false;
  User? user;
  String? title;
  List<Tag> tags = [];

  void getTags() async {
    PostService service = HttpPost();
    dartz.Either<Failure, List<Tag>> result = await service.getTags();
    result.fold((l) => null, (List<Tag> interests) {
      setState(() {
        tags = interests;
      });
    });
  }

  void getIngredients(String recipeId) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Paginated<String>> result =
        await postService.getIngredients(recipeId);
    result.fold((l) => null, (ingredients) {
      setState(() {
        this.ingredients.addAll(ingredients.getData());
      });
    });
  }

  void getPreparationSteps(String recipeId) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Paginated<RecipePreparationStep>> result =
        await postService.getRecipePreparation(recipeId);
    result.fold((l) => null, (steps) {
      setState(() {
        preparationSteps.addAll(steps.getData());
      });
    });
  }

  @override
  initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
        _titleController.text = widget.recipe?.title ?? "";
        _descriptionController.text = widget.recipe?.description ?? "";
        if (widget.recipe != null) {
          Iterable<String> recipeTagNames =
              (widget.recipe?.tags ?? []).map((Tag e) => e.id);
          selectedTags.addAll(recipeTagNames);
          getIngredients(widget.recipe!.id);
          getPreparationSteps(widget.recipe!.id);
        }
      });
      getTags();
    }
  }

  List<Step> stepList() => [
        Step(
            title: const Text("General"),
            content: Form(
              key: _formKey,
              child: GeneralStep(
                user: user ?? User.initial(),
                titleController: _titleController,
                descriptionController: _descriptionController,
                selectedTags: selectedTags,
                tags: tags,
                postImage: imageURI,
                onSelectTags: (List<String> newTags) {
                  setState(() {
                    selectedTags = newTags;
                  });
                },
                onSelectImage: (String postImage) {
                  setState(() {
                    imageURI = postImage;
                  });
                },
              )
            ),
            state: StepState.editing,
            isActive: _currentStep >= 0),
        Step(
            title: const Text("Ingredientes"),
            content: IngredientStep(
              ingredients: ingredients,
              onChangeIngredients: (List<String> updatedIngredients) {
                setState(() {
                  errorMsg = null;
                  ingredients = updatedIngredients;
                });
              },
            ),
            state: StepState.editing,
            isActive: _currentStep >= 1),
        Step(
            title: const Text("Preparacion"),
            content: PreparationStep(
              preparationSteps: preparationSteps,
              updatePreparationSteps: (List<RecipePreparationStep> steps) {
                setState(() {
                  preparationSteps = steps;
                });
              },
            ),
            state: StepState.editing,
            isActive: _currentStep >= 2)
      ];

  bool isNotLastStep() {
    return _currentStep < (stepList().length - 1);
  }

  void onContinue() {
    if(isNotLastStep()){
      if(_currentStep == 0){
        FormState? currentForm = _formKey.currentState;
        if(currentForm != null && currentForm.validate()){
          setState(() => _currentStep += 1);
        }
      }
      else if(_currentStep == 1){
        if(ingredients.isNotEmpty){
          setState(() {
            _currentStep += 1;
          });
        }
        else{
          setState(() {
            errorMsg = 'Debe ingresar minimo 1 ingrediente';
          });
        }
      }
    }
  }

  void onBack() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  void createRecipe() async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Recipe> result = await postService.createRecipe(
        imageURI: imageURI,
        title: _titleController.text,
        description: _descriptionController.text,
        tags: selectedTags,
        ingredients: ingredients,
        stepsContent: preparationSteps);
    result.fold((l) => CommonPopup.alert(context, l), (recipe) {
      Navigator.of(context).pop(recipe);
    });
  }

  void updateRecipe() async {
    PostService postService = HttpPost();
    dartz.Either<Failure, Recipe> result = await postService.updateRecipe(
        recipeId: widget.recipe!.id,
        imageURI: imageURI,
        title: _titleController.text,
        description: _descriptionController.text,
        tags: selectedTags,
        ingredients: ingredients,
        stepsContent: preparationSteps);
    result.fold((l) => CommonPopup.alert(context, l), (recipe) {
      Navigator.of(context).pop(recipe);
    });
  }

  Function() onPublish() {
    return widget.recipe != null ? updateRecipe : createRecipe;
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
              return Column(
                children: [
                  Conditional(
                    condition: errorMsg != null,
                    positive: Text(
                      errorMsg ?? '',
                      style: const TextStyle(
                          color: redColor
                      ),
                    )
                  ),
                  const SizedBox(height: 10),
                  Row(
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
                      ElevatedButton(
                        onPressed: isNotLastStep() ? onContinue : null,
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5),
                            backgroundColor: primaryColor),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: whiteColor,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              preparationSteps.isEmpty ? gray02Color : primaryColor
                          )),
                      onPressed: preparationSteps.isEmpty ? null : onPublish(),
                      child: Text(
                        widget.recipe != null ? "Editar" : "publicar",
                        style: const TextStyle(
                            color: whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ))
                ]
              );
            }));
  }
}
