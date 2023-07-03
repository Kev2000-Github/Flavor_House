import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/comment.dart';
import 'package:flavor_house/models/user/user.dart';

abstract class CommentService {
  Future<Either<Failure, List<Comment>>> getComments(String postId);
}