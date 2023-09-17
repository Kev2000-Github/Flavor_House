import 'dart:convert';
import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/models/post/recipe_preparation.dart';
import 'package:flavor_house/models/config/sort_config.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/utils/colors.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/session.dart';
import '../../models/post/comment.dart';
import '../../models/post/review.dart';
import './post_service.dart';
import '../../common/error/failures.dart';
import 'package:flutter/material.dart';

class HttpPost implements PostService {
  @override
  Future<Either<Failure, Paginated<Moment>>> getMoments({SortConfig? sort, String? search}) async {
    String? sortFormatted = sort != null ? 'sort=${sort.value}' : null;
    String? searchFormatted = search != null ? 'search=$search' : null;
    List<String?> applicableQueryURLs = [searchFormatted, sortFormatted].where((el) => el != null).toList();
    String queryURL = applicableQueryURLs.isNotEmpty ? '?${applicableQueryURLs.join('&')}' : '';
    String hostname = Config.backURL;
    String backURL = '$hostname/v1/posts/moment$queryURL';
    Uri url = Uri.parse(backURL);
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Moment> posts = items.map((item) {
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        return Moment(
            item['id'],
            item['madeBy']['id'],
            item['madeBy']['username'],
            item['madeBy']['fullName'],
            item['madeBy']['avatar'],
            item['description'],
            item['likes'],
            item['isLiked'],
            item['isFavorite'],
            item['image'],
            DateTime.parse(item['createdAt']),
        );
      }).toList();
      final result = Paginated(posts, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, Paginated<Recipe>>> getRecipes({SortConfig? sort, String? search, List<String>? tags}) async {
    String? tagsFormatted = tags != null ? 'tags=${tags.join(',')}' : null;
    String? sortFormatted = sort != null ? 'sort=${sort.value}' : null;
    String? searchFormatted = search != null ? 'search=$search' : null;
    List<String?> applicableQueryURLs = [searchFormatted, tagsFormatted, sortFormatted].where((el) => el != null).toList();
    String queryURL = applicableQueryURLs.isNotEmpty ? '?${applicableQueryURLs.join('&')}' : '';
    String hostname = Config.backURL;
    String backURL = '$hostname/v1/posts/recipe$queryURL';
    Uri url = Uri.parse(backURL);
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Recipe> posts = items.map((item) {
        List<Tag> tags = item['Tags'].map<Tag>((tag) => Tag(
            tag['id'],
            tag['name'],
            Helper.toColor(tag['color'])
        )).toList();
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        return Recipe(
            item['id'],
            item['madeBy']['id'],
            item['madeBy']['username'],
            item['madeBy']['fullName'],
            item['madeBy']['avatar'],
            item['description'],
            item['likes'],
            item['isLiked'],
            item['isFavorite'],
            item['image'],
            DateTime.parse(item['createdAt']),
            item['title'],
            item['stars'].toDouble(),
            tags
        );
      }).toList();
      final result = Paginated(posts, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, Paginated>> getAll({SortConfig? sort, PostTypeConfig? postFilter}) async {
    List posts = [
      Moment(
          "1",
          "id2",
          "alegarcia17",
          "Alejandro Garcia",
          null,
          "¡Recuerdos de cumpleaños inolvidables! Hoy comparto esta foto donde me hundieron la cabeza en la torta. ¡Fue un momento de diversión y risas! Gracias a todos los que hicieron de ese día un cumpleaños épico. ¡No hay mejor manera de celebrar la vida que con amigos y torta en la cara! 🎉🎂 #RecuerdosFelices #CumpleañosInolvidable #AmigosDivertidos",
          90,
          true,
          true,
          "assets/images/tortazo.jpg",
          DateTime.now()
      ),
      Recipe(
          "1",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          "assets/images/avatar.jpg",
          "¡El postre perfecto! Sorprende a todos con este tentador pastel. Esponjoso, indulgente y decorado a la perfección. ¡Prepárate para deleitarte!",
          90,
          true,
          true,
          "assets/images/cake.jpg",
          DateTime.now(),
          "Pastel de fresas y chocolate",
          4, [
        Tag("1", "dulce", const Color(0xFFff6961).withOpacity(0.5)),
        Tag("2", "pastel", const Color(0xFFfdcae1).withOpacity(0.5)),
        Tag("3", "chocolate", primaryColor.withAlpha(90)),
      ])
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    if(sort != null && sort.value == SortConfig.oldest().value){
      final result = Paginated(posts.reversed.toList(), 1, 1);
      return Right(result);
    }
    final result = Paginated(posts, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated>> getMyPosts({SortConfig? sort}) async {
    List posts = [
      Moment(
          "2",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          "assets/images/avatar.jpg",
          "¡Descubriendo nuevos sabores! Hoy probé este exquisito plato y quedé fascinado. Cada bocado era una explosión de sabores y texturas. ¡No puedo esperar para compartir esta joya culinaria con ustedes! Si eres amante de la buena comida, no te lo puedes perder. ¿Alguien más se anima a probarlo? #DeliciasGastronómicas #SorprendentesSabores #ExperienciaCulinaria",
          45,
          false,
          false,
          "assets/images/sushi.jpg",
          DateTime.now().subtract(const Duration(hours: 5))
      ),
      Recipe(
          "1",
          "id",
          "ReyDeLaCocina",
          "Juan Toledo",
          "assets/images/avatar.jpg",
          "¡El postre perfecto! Sorprende a todos con este tentador pastel. Esponjoso, indulgente y decorado a la perfección. ¡Prepárate para deleitarte!",
          90,
          true,
          true,
          "assets/images/cake.jpg",
          DateTime.now(),
          "Pastel de fresas y chocolate",
          4, [
        Tag("1", "dulce", const Color(0xFFff6961).withOpacity(0.5)),
        Tag("2", "pastel", const Color(0xFFfdcae1).withOpacity(0.5)),
        Tag("3", "chocolate", primaryColor.withAlpha(90)),
      ])
    ];
    await Future.delayed(const Duration(milliseconds: 500));
    if(sort != null && sort.value == SortConfig.oldest().value){
      final result = Paginated(posts.reversed.toList(), 1, 1);
      return Right(result);
    }
    final result = Paginated(posts, 1, 1);
    return Right(result);
  }

  @override
  Future<Either<Failure, Paginated<RecipePreparationStep>>> getRecipePreparation(String recipeId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/posts/recipe/steps/$recipeId');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<RecipePreparationStep> ingredients = items.map((item) => RecipePreparationStep(item['description'], item['image'])).toList();
      final result = Paginated(ingredients, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
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

  @override
  Future<Either<Failure, Paginated<Review>>> getReviews(String postId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/comments/$postId');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Review> comments = items.map((item) {
        return Review(
            item['id'],
            item['User']['id'],
            item['User']['fullName'],
            item['content'],
            DateTime.parse(item['createdAt']),
            item['stars']
        );
      }).toList();
      final result = Paginated(comments, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, Paginated<String>>> getIngredients(String recipeId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/posts/recipe/ingredients/$recipeId');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<String> ingredients = items.map((item) => item.descrition).cast<String>().toList();
      final result = Paginated(ingredients, 1, 1);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, List<Tag>>> getTags() async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/interests');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Tag> tags = items.map((item) => Tag.fromJson(item)).toList();
      return Right(tags);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleLike(String id, bool isLiked) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/posts/like/$id');
    var body = json.encode({
      "isLiked": isLiked
    });
    var response = await http.post(url, body: body, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      bool isLiked = decodedResponse['data'];
      return Right(isLiked);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String id, bool isFavorite) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/posts/favorite/$id');
    var body = json.encode({
      "isFavorite": isFavorite
    });
    var response = await http.post(url, body: body, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      bool isFavorite = decodedResponse['data'];
      return Right(isFavorite);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }
}
