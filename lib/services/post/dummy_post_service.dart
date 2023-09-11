import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/post/recipe_preparation.dart';
import 'package:flavor_house/models/config/sort_config.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/utils/colors.dart';

import '../../models/post/comment.dart';
import '../../models/post/review.dart';
import './post_service.dart';
import '../../common/error/failures.dart';
import 'package:flutter/material.dart';

class DummyPost implements PostService {
  @override
  Future<Either<Failure, Paginated<Moment>>> getMoments({SortConfig? sort, String? search}) async {
    List<Moment> posts = [
      Moment(
        "1",
        "id2",
        "alegarcia17",
        "Alejandro Garcia",
        null,
        "¡Recuerdos de cumpleaños inolvidables! Hoy comparto esta foto donde me hundieron la cabeza en la torta. ¡Fue un momento de diversión y risas! Gracias a todos los que hicieron de ese día un cumpleaños épico. ¡No hay mejor manera de celebrar la vida que con amigos y torta en la cara! 🎉🎂 #RecuerdosFelices #CumpleañosInolvidable #AmigosDivertidos",
        90,
        true,
        true,
        Image.asset("assets/images/tortazo.jpg"),
          DateTime.now()
      ),
      Moment(
        "2",
          "id",
        "ReyDeLaCocina",
        "Juan Toledo",
        Image.asset("assets/images/avatar.jpg"),
        "¡Descubriendo nuevos sabores! Hoy probé este exquisito plato y quedé fascinado. Cada bocado era una explosión de sabores y texturas. ¡No puedo esperar para compartir esta joya culinaria con ustedes! Si eres amante de la buena comida, no te lo puedes perder. ¿Alguien más se anima a probarlo? #DeliciasGastronómicas #SorprendentesSabores #ExperienciaCulinaria",
        45,
        false,
        false,
        Image.asset("assets/images/sushi.jpg"),
        DateTime.now().subtract(const Duration(hours: 5))
      )
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    if(sort != null && sort.value == SortConfig.oldest().value){
      final result = Paginated<Moment>(posts.reversed.toList(), posts.length, 1, 1);
      return Right(result);
    }
    final result = Paginated<Moment>(posts, posts.length, 1, 2);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated<Recipe>>> getRecipes({SortConfig? sort, String? search, List<String>? tags}) async {
    List<Recipe> posts = [
      Recipe(
          "1",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "¡El postre perfecto! Sorprende a todos con este tentador pastel. Esponjoso, indulgente y decorado a la perfección. ¡Prepárate para deleitarte!",
          90,
          true,
          true,
          Image.asset("assets/images/cake.jpg"),
          DateTime.now(),
          "Pastel de fresas y chocolate",
          4, [
        Tag("1", "dulce", const Color(0xFFff6961).withOpacity(0.5)),
        Tag("2", "pastel", const Color(0xFFfdcae1).withOpacity(0.5)),
        Tag("3", "chocolate", primaryColor.withAlpha(90)),
      ]),
      Recipe(
          "2",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "¡Dulzura irresistible! Prepara estas deliciosas galletas con chispas de chocolate. Crujientes por fuera, suaves por dentro. ¡El placer de cada mordisco!",
          45,
          true,
          true,
          Image.asset("assets/images/cookies.jpg"),
          DateTime.now().subtract(const Duration(hours: 24)),
          "Galletas de Chispas de Chocolate",
          4, [
        Tag("1", "dulce", const Color(0xFFff6961).withOpacity(0.5)),
        Tag("2", "galleta", const Color(0xFFc57d56).withOpacity(0.5)),
        Tag("3", "chocolate", primaryColor.withAlpha(90)),
      ])
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    if(sort != null && sort.value == SortConfig.oldest().value){
      final result = Paginated<Recipe>(posts.reversed.toList(), posts.length, 1, 1);
      return Right(result);
    }
    final result = Paginated<Recipe>(posts, posts.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated>> getAll({SortConfig? sort, PostTypeConfig? postFilter}) async {
    List posts = [
      Moment(
          "1",
          "id2",
          "alegarcia17",
          "Alejandro Garcia",
          null,
          "¡Recuerdos de cumpleaños inolvidables! Hoy comparto esta foto donde me hundieron la cabeza en la torta. ¡Fue un momento de diversión y risas! Gracias a todos los que hicieron de ese día un cumpleaños épico. ¡No hay mejor manera de celebrar la vida que con amigos y torta en la cara! 🎉🎂 #RecuerdosFelices #CumpleañosInolvidable #AmigosDivertidos",
          90,
          true,
          true,
          Image.asset("assets/images/tortazo.jpg"),
          DateTime.now()
      ),
      Recipe(
          "1",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "¡El postre perfecto! Sorprende a todos con este tentador pastel. Esponjoso, indulgente y decorado a la perfección. ¡Prepárate para deleitarte!",
          90,
          true,
          true,
          Image.asset("assets/images/cake.jpg"),
          DateTime.now(),
          "Pastel de fresas y chocolate",
          4, [
        Tag("1", "dulce", const Color(0xFFff6961).withOpacity(0.5)),
        Tag("2", "pastel", const Color(0xFFfdcae1).withOpacity(0.5)),
        Tag("3", "chocolate", primaryColor.withAlpha(90)),
      ])
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    if(sort != null && sort.value == SortConfig.oldest().value){
      final result = Paginated(posts.reversed.toList(), posts.length, 1, 1);
      return Right(result);
    }
    final result = Paginated(posts, posts.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated>> getMyPosts({SortConfig? sort}) async {
    List posts = [
      Moment(
          "2",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "¡Descubriendo nuevos sabores! Hoy probé este exquisito plato y quedé fascinado. Cada bocado era una explosión de sabores y texturas. ¡No puedo esperar para compartir esta joya culinaria con ustedes! Si eres amante de la buena comida, no te lo puedes perder. ¿Alguien más se anima a probarlo? #DeliciasGastronómicas #SorprendentesSabores #ExperienciaCulinaria",
          45,
          false,
          false,
          Image.asset("assets/images/sushi.jpg"),
          DateTime.now().subtract(const Duration(hours: 5))
      ),
      Recipe(
          "1",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          Image.asset("assets/images/avatar.jpg"),
          "¡El postre perfecto! Sorprende a todos con este tentador pastel. Esponjoso, indulgente y decorado a la perfección. ¡Prepárate para deleitarte!",
          90,
          true,
          true,
          Image.asset("assets/images/cake.jpg"),
          DateTime.now(),
          "Pastel de fresas y chocolate",
          4, [
        Tag("1", "dulce", const Color(0xFFff6961).withOpacity(0.5)),
        Tag("2", "pastel", const Color(0xFFfdcae1).withOpacity(0.5)),
        Tag("3", "chocolate", primaryColor.withAlpha(90)),
      ])
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    if(sort != null && sort.value == SortConfig.oldest().value){
      final result = Paginated(posts.reversed.toList(), posts.length, 1, 1);
      return Right(result);
    }
    final result = Paginated(posts, posts.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated<RecipePreparationStep>>> getRecipePreparation(String recipeId) async {
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
    final result = Paginated(steps, steps.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated<Comment>>> getComments(String postId) async {
    List<Comment> comments = [
      Comment("id", "userId", "María López", "marialopez94LAVELADA3FUEUNROBOOOOO", "¡Qué divertido momento de cumpleaños! 🎉🎂", DateTime.now().subtract(const Duration(minutes: 15)), null),
      Comment("id", "userId", "Alejandro García", "alegarcia17", "Jajaja, eso es tener amigos de verdad. 😄", DateTime.now().subtract(const Duration(hours: 1)), null),
      Comment("id", "userId", "Ana Torres", "anatorres22", "¡Aplastando el pastel con estilo! 🍰💥", DateTime.now().subtract(const Duration(hours: 12)), null),
      Comment("id", "userId", "Carlos Ramírez", "cramirez87", "¡Nada como un poco de diversión en tu día especial! 😅", DateTime.now().subtract(const Duration(days: 1)), null),
      Comment("id", "userId", "Sofía Medina", "sofiamedina15", "¡El mejor pastelazo de cumpleaños! 🎉🎂", DateTime.now().subtract(const Duration(days: 2)), null),
      Comment("id", "userId", "Juan Morales", "juanmora78", "Momentos inolvidables con amigos traviesos. 😂", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("id", "userId", "Laura Vargas", "lauravargas91", "¡Ese pastel quedó hecho añicos! 💥😄", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("id", "userId", "José Hernández", "josehdez34", "Jajaja, ¡te vengarás en su cumpleaños! 😉", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("id", "userId", "Valentina Silva", "valentinasilva19", "¡Qué manera tan divertida de celebrar! 🎉🍰", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("id", "userId", "Eduardo Ríos", "erios55", "Esa foto captura la esencia de la amistad. ❤️", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("id", "userId", "Andrea Castro", "andreacastro82", "¡Feliz cumpleaños lleno de risas y buenos recuerdos! 🎉😂", DateTime.now().subtract(const Duration(days: 15)), null),
    ];
    final result = Paginated(comments, comments.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated<Review>>> getReviews(String postId) async {
    List<Review> reviews = [
      Review("id", "userId", "Juan Toledo", "definitivamente uno de los mejores", DateTime.now(), 5),
      Review("id", "userId", "Maduro", "hace falta un poco mas de azucar", DateTime.now().subtract(const Duration(minutes: 15)), 3),
      Review("id", "userId", "Andrea Sammy", "ESTAN MATANDO ANIMALES!!!", DateTime.now().subtract(const Duration(minutes: 120)), 0),
      Review("id", "userId", "Athena Gomez", "me encanta, lo probe ayer y fue increible", DateTime.now().subtract(const Duration(hours: 15)), 5),
      Review("id", "userId", "Carlos Rodriguez", "la neta, esta de maravilla", DateTime.now().subtract(const Duration(days: 1)), 5),
      Review("id", "userId", "Maria Castillo", "hace falta mas chocolate y azucar", DateTime.now().subtract(const Duration(days: 1)), 4),
      Review("id", "userId", "Juana de Arco", "le falta sabor, pero se ve saludable", DateTime.now().subtract(const Duration(days: 2)), 4),
    ];
    final result = Paginated(reviews, reviews.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated<String>>> getIngredients(String recipeId) async {
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
    final result = Paginated(ingredients, ingredients.length, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, List<Tag>>> getTags() async {
    List<Tag> interests = [
      Tag("1", "dulce", primaryColor.withAlpha(90)),
      Tag("2", "BBQ", primaryColor.withAlpha(90)),
      Tag("3", "Frutas", primaryColor.withAlpha(90)),
      Tag("4", "Chocolate", primaryColor.withAlpha(90)),
      Tag("5", "Proteinas", primaryColor.withAlpha(90)),
      Tag("6", "China", primaryColor.withAlpha(90)),
      Tag("7", "Japones", primaryColor.withAlpha(90)),
      Tag("8", "Papas fritas", primaryColor.withAlpha(90)),
    ];
    return Right(interests);
  }
}
