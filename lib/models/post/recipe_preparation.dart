import 'dart:io';

import 'package:flutter/material.dart';

class RecipePreparationStep {
  final String description;
  String? imageURL;

  RecipePreparationStep(this.description, this.imageURL);

  Image get picture {
    //TODO: change dummy implementation later
    if(imageURL != null){
      if(RegExp("^assets\/images").hasMatch(imageURL!)){
        return Image.asset(imageURL!);
      }
      else if(RegExp("^(http|https):").hasMatch(imageURL!)){
        return Image.network(imageURL!);
      }
      else{
        return Image.file(File(imageURL!));
      }
    }
    return Image.asset("assets/images/gray.png");
  }
}