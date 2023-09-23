

import 'package:dartz/dartz.dart';

import '../../common/error/failures.dart';
import '../../models/post/comment.dart';
import '../paginated.dart';

abstract class CommentService {
  Future<Either<Failure, Comment>> createComment(String postId, String content);
  Future<Either<Failure, Comment>> deleteComment(String id);
  Future<Either<Failure, Paginated<Comment>>> getComments(String postId, int? page);
}