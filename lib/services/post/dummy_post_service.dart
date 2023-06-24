import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/post.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/sort/sort_config.dart';

import '../../common/error/failures.dart';
import '../../models/sort/sort_config.dart';
import './post_service.dart';
import 'constants.dart';

class DummyPost implements PostService {
  @override
  Future<Either<Failure, List<Moment>>> getMoments(SortConfig sort) async {
    List<Moment> posts = [
      Moment(
        "1",
        "ReyDeLaCocina",
        "Juan Toledo",
        "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
        "Es muy delicioso y esponjoso!",
        90,
        true,
        true,
        "https://cdn0.recetasgratis.net/es/posts/2/4/9/pastel_de_fresa_23942_orig.jpg",
      ),
      Moment(
        "2",
        "ReyDeLaCocina",
        "Juan Toledo",
        "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
        "Deliciosas galletas!",
        45,
        true,
        true,
        "https://cdn0.recetasgratis.net/es/posts/6/2/9/galletas_con_chispas_de_chocolate_caseras_35926_orig.jpg",
      )
    ];
    if(sort.value == SortConfig.oldest().value){
      return Right(posts.reversed.toList());
    }
    return Right(posts);
  }

  @override
  Future<Either<Failure, List<Recipe>>> getRecipes(SortConfig sort) async {
    List<Recipe> posts = [
      Recipe(
          "1",
          "ReyDeLaCocina",
          "Juan Toledo",
          "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
          "Es muy delicioso y esponjoso!",
          90,
          true,
          true,
          "https://cdn0.recetasgratis.net/es/posts/2/4/9/pastel_de_fresa_23942_orig.jpg",
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
          "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
          "Deliciosas galletas!",
          45,
          true,
          true,
          "https://cdn0.recetasgratis.net/es/posts/6/2/9/galletas_con_chispas_de_chocolate_caseras_35926_orig.jpg",
          "Pastel de chocolate",
          4, [
        Tag("dulce", const Color(0xFFD2D2D2)),
        Tag("galleta", const Color(0xFFD2D2D2)),
        Tag("chocolate", const Color(0xFFD2D2D2)),
      ])
    ];
    if(sort.value == SortConfig.oldest().value){
      return Right(posts.reversed.toList());
    }
    return Right(posts);
  }

  @override
  Future<Either<Failure, List>> getAll(SortConfig sort) async {
    List posts = [
      Moment(
        "1",
        "ReyDeLaCocina",
        "Juan Toledo",
        "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
        "Es muy delicioso y esponjoso!",
        90,
        true,
        true,
        "https://cdn0.recetasgratis.net/es/posts/2/4/9/pastel_de_fresa_23942_orig.jpg",
      ),
      Recipe(
          "1",
          "ReyDeLaCocina",
          "Juan Toledo",
          "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
          "Es muy delicioso y esponjoso!",
          90,
          true,
          true,
          "https://cdn0.recetasgratis.net/es/posts/2/4/9/pastel_de_fresa_23942_orig.jpg",
          "Pastel de chocolate",
          4, [
        Tag("dulce", const Color(0xFFD2D2D2)),
        Tag("pastel", const Color(0xFFD2D2D2)),
        Tag("chocolate", const Color(0xFFD2D2D2)),
      ])
    ];
    if(sort.value == SortConfig.oldest().value){
      return Right(posts.reversed.toList());
    }
    return Right(posts);
  }
}
