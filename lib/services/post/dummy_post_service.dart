import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/recipe_preparation.dart';
import 'package:flavor_house/models/sort/sort_config.dart';

import '../../models/comment.dart';
import '../../models/review.dart';
import './post_service.dart';
import '../../common/error/failures.dart';
import 'package:flutter/material.dart';

class DummyPost implements PostService {
  @override
  Future<Either<Failure, List<Moment>>> getMoments({SortConfig? sort, String? search}) async {
    List<Moment> posts = [
      Moment(
        "1",
        "ReyDeLaCocina",
        "Juan Toledo",
        Image.asset("assets/images/avatar.jpg"),
        "Es muy delicioso y esponjoso!",
        90,
        true,
        true,
        Image.asset("assets/images/cake.jpg"),
      ),
      Moment(
        "2",
        "ReyDeLaCocina",
        "Juan Toledo",
        Image.asset("assets/images/avatar.jpg"),
        "Deliciosas galletas!",
        45,
        true,
        true,
        Image.asset("assets/images/cookies.jpg"),
      )
    ];
    await Future.delayed(const Duration(seconds: 1));
    if(sort != null && sort.value == SortConfig.oldest().value){
      return Right(posts.reversed.toList());
    }
    return Right(posts);
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes({SortConfig? sort, String? search}) async {
    List<Recipe> posts = [
      Recipe(
          "1",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "Es muy delicioso y esponjoso!",
          90,
          true,
          true,
          Image.asset("assets/images/cake.jpg"),
          "Pastel de chocolate",
          4, [
        Tag("dulce", const Color(0xFFD2D2D2)),
        Tag("pastel", const Color(0xFFD2D2D2)),
        Tag("chocolate", const Color(0xFFD2D2D2)),
      ]),
      Recipe(
          "2",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "Deliciosas galletas!",
          45,
          true,
          true,
          Image.asset("assets/images/cookies.jpg"),
          "Pastel de chocolate",
          4, [
        Tag("dulce", const Color(0xFFD2D2D2)),
        Tag("galleta", const Color(0xFFD2D2D2)),
        Tag("chocolate", const Color(0xFFD2D2D2)),
      ])
    ];
    await Future.delayed(const Duration(seconds: 1));
    if(sort != null && sort.value == SortConfig.oldest().value){
      return Right(posts.reversed.toList());
    }
    return Right(posts);
  }

  @override
  Future<Either<Failure, List>> getAll({SortConfig? sort}) async {
    List posts = [
      Moment(
        "1",
        "ReyDeLaCocina",
        "Juan Toledo",
        Image.asset("assets/images/avatar.jpg"),
        "Es muy delicioso y esponjoso!",
        90,
        true,
        true,
        Image.asset("assets/images/cake.jpg"),
      ),
      Recipe(
          "1",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "Es muy delicioso y esponjoso!",
          90,
          true,
          true,
          Image.asset("assets/images/cake.jpg"),
          "Pastel de chocolate",
          4, [
        Tag("dulce", const Color(0xFFD2D2D2)),
        Tag("pastel", const Color(0xFFD2D2D2)),
        Tag("chocolate", const Color(0xFFD2D2D2)),
      ])
    ];
    await Future.delayed(const Duration(seconds: 1));
    if(sort != null && sort.value == SortConfig.oldest().value){
      return Right(posts.reversed.toList());
    }
    return Right(posts);
  }

  @override
  Future<Either<Failure, List<RecipePreparationStep>>> getRecipePreparation(String recipeId) async {
    List<RecipePreparationStep> steps = [
      RecipePreparationStep("Precalentar el horno a 180°C.", null),
      RecipePreparationStep("En un tazón grande, mezclar la harina, azúcar, cacao en polvo, levadura en polvo, bicarbonato de sodio y sal.", null),
      RecipePreparationStep("Agregar los huevos, leche, aceite vegetal y extracto de vainilla a la mezcla seca y batir hasta obtener una masa suave", null),
      RecipePreparationStep("Incorporar el agua caliente y mezclar hasta que esté bien combinado", null),
      RecipePreparationStep("Verter la masa en un molde previamente engrasado", null),
      RecipePreparationStep("Hornear durante aproximadamente 30-35 minutos o hasta que al insertar un palillo en el centro del pastel, este salga limpio", null),
      RecipePreparationStep("Mientras tanto, preparar el glaseado mezclando el azúcar glas, cacao en polvo, mantequilla derretida, leche y extracto de vainilla hasta obtener una consistencia suave", null),
      RecipePreparationStep("Una vez que el pastel esté completamente enfriado, cubrir con el glaseado de chocolate", null),
      RecipePreparationStep("Decorar el pastel según tu preferencia y ¡disfrutar!", "assets/images/cake.jpg"),
    ];
    return Right(steps);
  }

  @override
  Future<Either<Failure, List<Comment>>> getComments(String postId) async {
    List<Comment> comments = [
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(minutes: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(hours: 1)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(hours: 12)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 1)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 2)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
    ];
    return Right(comments);
  }

  @override
  Future<Either<Failure, List<Review>>> getReviews(String postId) async {
    List<Review> reviews = [
      Review("Juan Toledo", "definitivamente uno de los mejores", DateTime.now(), 5),
      Review("Maduro", "hace falta un poco mas de azucar", DateTime.now().subtract(const Duration(minutes: 15)), 3),
      Review("Andrea Sammy", "ESTAN MATANDO ANIMALES!!!", DateTime.now().subtract(const Duration(minutes: 120)), 0),
      Review("Athena Gomez", "me encanta, lo probe ayer y fue increible", DateTime.now().subtract(const Duration(hours: 15)), 5),
      Review("Carlos Rodriguez", "la neta, esta de maravilla", DateTime.now().subtract(const Duration(days: 1)), 5),
      Review("Maria Castillo", "hace falta mas chocolate y azucar", DateTime.now().subtract(const Duration(days: 1)), 4),
      Review("Juana de Arco", "le falta sabor, pero se ve saludable", DateTime.now().subtract(const Duration(days: 2)), 4),
    ];
    return Right(reviews);
  }

  @override
  Future<Either<Failure, List<String>>> getIngredients(String recipeId) async {
    List<String> ingredients = [
      "2 tazas de harina",
      "2 tazas de azúcar",
      "3/4 taza de cacao en polvo",
      "2 cucharaditas de levadura en polvo",
      "1 1/2 cucharaditas de bicarbonato de sodio",
      "1 cucharadita de sal",
      "2 huevos",
      "1 taza de leche",
      "1/2 taza de aceite vegetal",
      "2 cucharaditas de extracto de vainilla",
      "1 taza de agua caliente",
      "1 1/2 tazas de azúcar glas",
      "1/4 taza de cacao en polvo",
      "1/4 taza de mantequilla derretida",
      "1/4 taza de leche",
      "1 cucharadita de extracto de vainilla"
    ];
    return Right(ingredients);
  }
}
