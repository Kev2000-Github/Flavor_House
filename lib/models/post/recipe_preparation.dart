import 'package:flutter/material.dart';

class RecipePreparationStep {
  final String description;
  final String? imageURL;

  RecipePreparationStep(this.description, this.imageURL);

  Image get picture {
    //TODO: change dummy implementation later
    if(imageURL != null) return Image.asset(imageURL!);
    return Image.asset("assets/images/gray.png");
  }
}