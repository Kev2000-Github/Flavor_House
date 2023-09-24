
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/recipe_preparation.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/config/sort_config.dart';
import 'package:flavor_house/services/paginated.dart';

import '../../models/post/comment.dart';
import '../../models/post/moment.dart';
import '../../models/post/review.dart';

abstract class PostService {
  Future<Either<Failure, Paginated<Moment>>> getMoments({SortConfig? sort, String? search, int? page});
  Future<Either<Failure, Paginated<Recipe>>> getRecipes({SortConfig? sort, String? search, List<String>? tags, int? page});
  Future<Either<Failure, Paginated>> getAll({SortConfig? sort, PostTypeConfig? postFilter, bool? isFavorite, String? madeBy, int? page});
  Future<Either<Failure, List<Tag>>> getTags();
  Future<Either<Failure, Paginated<RecipePreparationStep>>> getRecipePreparation(String recipeId);
  Future<Either<Failure, Paginated<String>>> getIngredients(String recipeId);
  Future<Either<Failure, bool>> toggleLike(String id, bool isLiked);
  Future<Either<Failure, bool>> toggleFavorite(String id, bool isFavorite);
  Future<Either<Failure, Moment>> createMoment({required String description, String? imageURI});
  Future<Either<Failure, Moment>> updateMoment({required String id, String? description, String? imageURI});
  Future<Either<Failure, Recipe>> createRecipe({
      required String title,
      required String description,
      required List<String> ingredients,
      required List<RecipePreparationStep> stepsContent,
      required List<String> tags,
      String? imageURI
  });
  Future<Either<Failure, Recipe>> updateRecipe({
    required String recipeId,
    required String title,
    required String description,
    required List<String> ingredients,
    required List<RecipePreparationStep> stepsContent,
    required List<String> tags,
    String? imageURI
  });
  Future<Either<Failure, bool>> deletePost(String id, String type);
}