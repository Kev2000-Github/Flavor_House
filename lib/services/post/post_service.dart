
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/recipe_preparation.dart';
import 'package:flavor_house/models/sort/sort_config.dart';

import '../../models/comment.dart';
import '../../models/post/moment.dart';
import '../../models/review.dart';

abstract class PostService {
  Future<Either<Failure, List<Moment>>> getMoments({SortConfig? sort, String? search});
  Future<Either<Failure, List<Recipe>>> getRecipes({SortConfig? sort, String? search});
  Future<Either<Failure, List>> getAll({SortConfig? sort});
  Future<Either<Failure, List<Comment>>> getComments(String postId);
  Future<Either<Failure, List<Review>>> getReviews(String postId);
  Future<Either<Failure, List<RecipePreparationStep>>> getRecipePreparation(String recipeId);
  Future<Either<Failure, List<String>>> getIngredients(String recipeId);
}