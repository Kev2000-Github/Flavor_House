

import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../common/config.dart';
import '../../common/error/failures.dart';
import '../../common/session.dart';
import '../../models/post/review.dart';
import '../paginated.dart';
import 'reviews_service.dart';

class HttpReviewService implements ReviewService {
  @override
  Future<Either<Failure, Review>> createReview(String postId, String content, int stars) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/reviews');
      var body = json.encode({
        'recipeId': postId,
        'content': content,
        'stars': stars
      });
      var response = await http.post(url, body: body, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        decodedResponse['data']['createdAt'] = DateTime.parse(decodedResponse['data']['createdAt']);
        String? avatar = decodedResponse['data']['User']['avatar'];
        if(avatar != null) decodedResponse['data']['User']['avatar'] = Config.imgURL(avatar);
        Review createdReview = Review.fromJson(decodedResponse['data']);
        return Right(createdReview);
      } else {
        return Left(ServerFailure(
            title: 'Reviews', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      print(e);
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Review>> deleteReview(String id) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/reviews/$id');
      var response = await http.delete(url, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        decodedResponse['data']['createdAt'] = DateTime.parse(decodedResponse['data']['createdAt']);
        String? avatar = decodedResponse['data']['User']['avatar'];
        if(avatar != null) decodedResponse['data']['User']['avatar'] = Config.imgURL(avatar);
        Review deletedReview = Review.fromJson(decodedResponse['data']);
        return Right(deletedReview);
      } else {
        return Left(ServerFailure(
            title: 'Reviews', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Paginated<Review>>> getReviews(String postId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/reviews/$postId');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Review> reviews = items.map((item) {
        item['createdAt'] = DateTime.parse(item['createdAt']);
        String? avatar = item['User']['avatar'];
        if(avatar != null) item['User']['avatar'] = Config.imgURL(avatar);
        return Review.fromJson(item);
      }).toList();
      final result = Paginated(reviews, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }
}