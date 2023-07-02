import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/sort/sort_config.dart';

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
}
