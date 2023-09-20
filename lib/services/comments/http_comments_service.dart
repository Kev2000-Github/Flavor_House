

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/services/comments/comments_service.dart';

import '../../common/config.dart';
import '../../common/error/failures.dart';
import 'package:http/http.dart' as http;

import '../../common/session.dart';
import '../../models/post/comment.dart';
import '../paginated.dart';

class HttpCommentService implements CommentService {
  @override
  Future<Either<Failure, Comment>> createComment(String postId, String content) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/comments');
      var body = json.encode({
        'postId': postId,
        'content': content,
      });
      var response = await http.post(url, body: body, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        String? avatar = decodedResponse['data']['User']['avatar'];
        decodedResponse['data']['createdAt'] = DateTime.parse(decodedResponse['data']['createdAt']);
        if(avatar != null) decodedResponse['data']['User']['avatar'] = Config.imgURL(avatar);
        Comment createdComment = Comment.fromJson(decodedResponse['data']);
        return Right(createdComment);
      } else {
        return Left(ServerFailure(
            title: 'Comments', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Comment>> deleteComment(String id) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/comments/$id');
      var response = await http.delete(url, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        String? avatar = decodedResponse['data']['User']['avatar'];
        if(avatar != null) decodedResponse['data']['User']['avatar'] = Config.imgURL(avatar);
        Comment deletedComment = Comment.fromJson(decodedResponse['data']);
        return Right(deletedComment);
      } else {
        return Left(ServerFailure(
            title: 'Comments', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Paginated<Comment>>> getComments(String postId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/comments/$postId');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Comment> comments = items.map((item) {
        String? avatar = item['User']['avatar'];
        if(avatar != null) item['User']['avatar'] = Config.imgURL(avatar);
        return Comment(
            item['id'],
            item['User']['id'],
            item['User']['fullName'],
            item['User']['username'],
            item['content'],
            DateTime.parse(item['createdAt']),
            item['User']['avatar']
        );
      }).toList();
      final result = Paginated(comments, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }
}