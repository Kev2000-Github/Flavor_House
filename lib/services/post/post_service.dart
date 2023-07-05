
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/sort/sort_config.dart';

import '../../models/post/moment.dart';

abstract class PostService {
  Future<Either<Failure, List<Moment>>> getMoments({SortConfig? sort, String? search});
  Future<Either<Failure, List<Recipe>>> getRecipes({SortConfig? sort, String? search});
  Future<Either<Failure, List>> getAll({SortConfig? sort});
}