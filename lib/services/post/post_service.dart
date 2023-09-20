
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
  Future<Either<Failure, Paginated<Moment>>> getMoments({SortConfig? sort, String? search});
  Future<Either<Failure, Paginated<Recipe>>> getRecipes({SortConfig? sort, String? search, List<String>? tags});
  Future<Either<Failure, Paginated>> getAll({SortConfig? sort, PostTypeConfig? postFilter, bool? isFavorite, bool? isMine});
  Future<Either<Failure, List<Tag>>> getTags();
  Future<Either<Failure, Paginated<RecipePreparationStep>>> getRecipePreparation(String recipeId);
  Future<Either<Failure, Paginated<String>>> getIngredients(String recipeId);
  Future<Either<Failure, bool>> toggleLike(String id, bool isLiked);
  Future<Either<Failure, bool>> toggleFavorite(String id, bool isFavorite);
  Future<Either<Failure, bool>> createMoment({required String description, File? imageFile});
  Future<Either<Failure, bool>> createRecipe({
      required String title,
      required String description,
      required List<String> ingredients,
      required List<StepContent> stepsContent,
      File? imageFile
  });
  Future<Either<Failure, bool>> deletePost(String id, String type);
}

class StepContent {
  final String id;
  final String description;
  final File? imageFile;

  StepContent(this.id, this.description, this.imageFile);
}