
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/comment.dart';
import 'package:flavor_house/services/comment/comment_service.dart';

class DummyCommentService implements CommentService {
  @override
  Future<Either<Failure, List<Comment>>> getComments(String postId) async {
    List<Comment> comments = [
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(minutes: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(hours: 1)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(hours: 12)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 1)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 2)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
      Comment("pepe", "papyrus", "Esto es increible!", DateTime.now().subtract(const Duration(days: 15)), null),
    ];
    return Right(comments);
  }

}