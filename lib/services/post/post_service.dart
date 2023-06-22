
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/post/post.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/services/post/constants.dart';

import '../../models/post/moment.dart';

abstract class PostService {
  Future<Either<Failure, List<Moment>>> getMoments();
  Future<Either<Failure, List<Recipe>>> getRecipes();
}