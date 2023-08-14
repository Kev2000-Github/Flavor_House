
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/recipe_preparation.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/config/sort_config.dart';

import '../../models/post/comment.dart';
import '../../models/post/moment.dart';
import '../../models/post/review.dart';

abstract class PostService {
  Future<Either<Failure, List<Moment>>> getMoments({SortConfig? sort, String? search});
  Future<Either<Failure, List<Recipe>>> getRecipes({SortConfig? sort, String? search, List<String>? tags});
  Future<Either<Failure, List>> getAll({SortConfig? sort, PostTypeConfig? postFilter});
  Future<Either<Failure, List>> getMyPosts({SortConfig? sort});
  Future<Either<Failure, List<Comment>>> getComments(String postId);
  Future<Either<Failure, List<Review>>> getReviews(String postId);
  Future<Either<Failure, List<Tag>>> getTags();
  Future<Either<Failure, List<RecipePreparationStep>>> getRecipePreparation(String recipeId);
  Future<Either<Failure, List<String>>> getIngredients(String recipeId);
}