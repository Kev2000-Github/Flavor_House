

import 'package:dartz/dartz.dart';

import '../../common/error/failures.dart';
import '../../models/post/review.dart';
import '../paginated.dart';

abstract class ReviewService {
  Future<Either<Failure, Review>> createReview(String postId, String content, int stars);
  Future<Either<Failure, Review>> deleteReview(String id);
  Future<Either<Failure, Paginated<Review>>> getReviews(String postId, int? page);
}