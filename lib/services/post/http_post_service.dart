import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/config/sort_config.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/recipe_preparation.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:http/http.dart' as http;

import './post_service.dart';
import '../../common/config.dart';
import '../../common/error/failures.dart';
import '../../common/session.dart';

class HttpPost implements PostService {
  @override
  Future<Either<Failure, Paginated<Moment>>> getMoments({SortConfig? sort, String? search, int? page}) async {
    String? sortFormatted = sort != null ? 'sort=${sort.value}' : null;
    String? searchFormatted = search != null ? 'search=$search' : null;
    String? pageFormatted = page != null ? 'page=$page' : null;
    List<String?> possibleQueryURLs = [searchFormatted, sortFormatted, pageFormatted];
    List<String?> applicableQueryURLs = possibleQueryURLs.where((el) => el != null).toList();
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
      final result = Paginated(posts, decodedResponse['page'], decodedResponse['totalPages']);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, Paginated<Recipe>>> getRecipes({SortConfig? sort, String? search, List<String>? tags, int? page}) async {
    String? tagsFormatted = tags != null ? 'tags=${tags.join(',')}' : null;
    String? sortFormatted = sort != null ? 'sort=${sort.value}' : null;
    String? searchFormatted = search != null ? 'search=$search' : null;
    String? pageFormatted = page != null ? 'page=$page' : null;
    List<String?> applicableQueryURLs = [pageFormatted, searchFormatted, tagsFormatted, sortFormatted].where((el) => el != null).toList();
    String queryURL = applicableQueryURLs.isNotEmpty ? '?${applicableQueryURLs.join('&')}' : '';
    String hostname = Config.backURL;
    String backURL = '$hostname/v1/posts/recipe$queryURL';
    Uri url = Uri.parse(backURL);
    try{
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
          item['stars'] = item['stars'].round();
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
              item['stars'],
              tags
          );
        }).toList();
        final result = Paginated(posts, decodedResponse['page'], decodedResponse['totalPages']);
        return Right(result);
      }
      else{
        return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
      }
    }
    catch(e) {
      return const Left(TimeOutFailure(title: 'Post'));
    }
  }

  @override
  Future<Either<Failure, Paginated>> getAll({SortConfig? sort, PostTypeConfig? postFilter, bool? isFavorite, bool? isMine, int? page}) async {
    String? sortFormatted = sort != null ? 'sort=${sort.value}' : null;
    String? postTypeFormatted = postFilter != null ? 'type=${postFilter.value}' : null;
    String? isFavoriteFormatted = isFavorite != null && isFavorite ? 'favorite=true' : null;
    String? isMineFormatted = isMine != null && isMine ? 'own=true' : null;
    String? pageFormatted = page != null ? 'page=$page' : null;
    List<String?> possibleQueryURLs = [pageFormatted, sortFormatted, postTypeFormatted, isFavoriteFormatted, isMineFormatted];
    List<String?> applicableQueryURLs = possibleQueryURLs.where((el) => el != null).toList();
    String queryURL = applicableQueryURLs.isNotEmpty ? '?${applicableQueryURLs.join('&')}' : '';
    String hostname = Config.backURL;
    String backURL = '$hostname/v1/posts$queryURL';
    Uri url = Uri.parse(backURL);
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List posts = items.map((item) {
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        if(item['type'] == 'MOMENT'){
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
        }
        else{
          List<Tag> tags = item['Tags'].map<Tag>((tag) => Tag(
              tag['id'],
              tag['name'],
              Helper.toColor(tag['color'])
          )).toList();
          item['stars'] = item['stars'].round();
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
              item['stars'],
              tags
          );
        }
      }).toList();
      final result = Paginated(posts, decodedResponse['page'], decodedResponse['totalPages']);
      return Right(result);
    }
    else{
      return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, Paginated<RecipePreparationStep>>> getRecipePreparation(String recipeId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/posts/recipe/steps/$recipeId');
    try{
      var response = await http.get(url, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if(response.statusCode == 200){
        List<dynamic> items = decodedResponse['data'];
        List<RecipePreparationStep> ingredients = items.map((item) {
          String? imageURL = Config.imgURL(item['image']);
          return RecipePreparationStep(item['description'], imageURL);
        }).toList();
        final result = Paginated(ingredients, 1, 1);
        return Right(result);
      }
      else{
        return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
      }
    }
    catch(e){
      print(e);
      return const Left(TimeOutFailure(title: 'Post'));
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
      List<String> ingredients = items.map((item) => (item['description'] as String)).toList();
      final result = Paginated(ingredients, decodedResponse['page'], decodedResponse['totalPages']);
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
      List<Tag> tags = items.map((item) {
        item['color'] = Helper.toColor(item['color']);
        return Tag.fromJson(item);
      }).toList();
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

  @override
  Future<Either<Failure, Moment>> createMoment({required String description, String? imageURI}) async {
    try {
      String hostname = Config.backURL;
      String url = '$hostname/v1/posts/moment';
      Map<String, dynamic> body = {
        'description': description
      };
      if(imageURI != null) {
        String fileName = imageURI.split('/').last;
        String ext = fileName.split('.').last;
        body['post'] = await Helper.getMultiPartFile(
            imageURI,
            filename: 'post.$ext',
        );
      }
      FormData formData = FormData.fromMap(body);
      var dio = Dio();
      dio.options.headers['authorization'] = Session().token;
      var response = await dio.post(url, data: formData);
      var decodedResponse = response.data;
      if(response.statusCode == 200){
        var item = decodedResponse['data'];
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        Moment createdMoment = Moment(
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
        return Right(createdMoment);
      }
      else{
        return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      print(e);
      return const Left(TimeOutFailure(title: 'Post'));
    }
  }

  @override
  Future<Either<Failure, Moment>> updateMoment({required String id, String? description, String? imageURI}) async {
    try {
      String hostname = Config.backURL;
      String url = '$hostname/v1/posts/moment/$id';
      Map<String, dynamic> body = {
        'description': description
      };
      if(imageURI != null) {
        String fileName = imageURI.split('/').last;
        String ext = fileName.split('.').last;
        body['post'] = await Helper.getMultiPartFile(
            imageURI,
            filename: 'post.$ext',
        );
      }
      FormData formData = FormData.fromMap(body);
      var dio = Dio();
      dio.options.headers['authorization'] = Session().token;
      var response = await dio.put(url, data: formData);
      var decodedResponse = response.data;
      if(response.statusCode == 200){
        var item = decodedResponse['data'];
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        Moment createdMoment = Moment(
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
        return Right(createdMoment);
      }
      else{
        return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      print(e);
      return const Left(TimeOutFailure(title: 'Post'));
    }
  }


  @override
  Future<Either<Failure, Recipe>> createRecipe({
    required String title,
    required String description,
    required List<String> ingredients,
    required List<RecipePreparationStep> stepsContent,
    required List<String> tags,
    String? imageURI
  }) async {
    try {
      String hostname = Config.backURL;
      String url = '$hostname/v1/posts/recipe';
      Map<String, dynamic> body = {
        'title': title,
        'description': description,
        'ingredients[]': ingredients,
        'tags[]': tags,
      };
      if(imageURI != null){
        String fileName = imageURI.split('/').last;
        String ext = fileName.split('.').last;
        body['post'] = await Helper.getMultiPartFile(
            imageURI,
            filename: 'post.$ext',
        );
      }
      List<String> formattedSteps = [];
      List<MultipartFile> stepImages = [];
      for(var i = 0; i < stepsContent.length; i++) {
        Map<String, String> formattedStep = {
          'description': stepsContent[i].description
        };
        if(stepsContent[i].imageURL != null){
          String fullFileName = stepsContent[i].imageURL!.split('/').last;
          String ext = fullFileName.split('.').last;
          formattedStep['id'] = 'step-$i';
          MultipartFile file = await Helper.getMultiPartFile(
              stepsContent[i].imageURL!,
              filename: 'step-$i.$ext'
          );
          stepImages.add(file);
        }
        formattedSteps.add(json.encode(formattedStep));
      }
      body['stepsContent[]'] = formattedSteps;
      body['steps'] = stepImages;
      FormData formData = FormData.fromMap(body);
      var dio = Dio();
      dio.options.headers['authorization'] = Session().token;
      var response = await dio.post(url, data: formData);
      var decodedResponse = response.data;
      if(response.statusCode == 200){
        var item = decodedResponse['data'];
        List<Tag> tags = item['Tags'].map<Tag>((tag) => Tag(
            tag['id'],
            tag['name'],
            Helper.toColor(tag['color'])
        )).toList();
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        item['stars'] = item['stars'].round();
        Recipe newRecipe = Recipe(
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
            item['stars'],
            tags
        );
        return Right(newRecipe);
      }
      else{
        return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      print((e as DioException).response);
      return const Left(TimeOutFailure(title: 'Post'));
    }
  }

  @override
  Future<Either<Failure, Recipe>> updateRecipe({
    required String recipeId,
    required String title,
    required String description,
    required List<String> ingredients,
    required List<RecipePreparationStep> stepsContent,
    required List<String> tags,
    String? imageURI
  }) async {
    try {
      String hostname = Config.backURL;
      String url = '$hostname/v1/posts/recipe/$recipeId';
      Map<String, dynamic> body = {
        'title': title,
        'description': description,
        'ingredients[]': ingredients,
        'tags[]': tags,
      };
      if(imageURI != null){
        String fileName = imageURI.split('/').last;
        String ext = fileName.split('.').last;
        body['post'] = await Helper.getMultiPartFile(
          imageURI,
          filename: 'post.$ext',
        );
      }
      List<String> formattedSteps = [];
      List<MultipartFile> stepImages = [];
      for(var i = 0; i < stepsContent.length; i++) {
        Map<String, String> formattedStep = {
          'description': stepsContent[i].description
        };
        if(stepsContent[i].imageURL != null){
          String fullFileName = stepsContent[i].imageURL!.split('/').last;
          String ext = fullFileName.split('.').last;
          formattedStep['id'] = 'step-$i';
          MultipartFile file = await Helper.getMultiPartFile(
              stepsContent[i].imageURL!,
              filename: 'step-$i.$ext'
          );
          stepImages.add(file);
        }
        formattedSteps.add(json.encode(formattedStep));
      }
      body['stepsContent[]'] = formattedSteps;
      body['steps'] = stepImages;
      FormData formData = FormData.fromMap(body);
      var dio = Dio();
      dio.options.headers['authorization'] = Session().token;
      var response = await dio.put(url, data: formData);
      var decodedResponse = response.data;
      if(response.statusCode == 200){
        var item = decodedResponse['data'];
        List<Tag> tags = item['Tags'].map<Tag>((tag) => Tag(
            tag['id'],
            tag['name'],
            Helper.toColor(tag['color'])
        )).toList();
        item['image'] = Config.imgURL(item['image']);
        item['madeBy']['avatar'] = Config.imgURL(item['madeBy']['avatar']);
        item['stars'] = item['stars'].round();
        Recipe newRecipe = Recipe(
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
            item['stars'],
            tags
        );
        return Right(newRecipe);
      }
      else{
        return Left(ServerFailure(title: 'Post', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      print((e as DioException).response);
      return const Left(TimeOutFailure(title: 'Post'));
    }
  }

  @override
  Future<Either<Failure, bool>> deletePost(String id, String type) async {
    try {
      String hostname = Config.backURL;
      String formattedType = type == 'Moment' ? 'moment' : 'recipe';
      Uri url = Uri.parse('$hostname/v1/posts/$formattedType/$id');
      var response = await http.delete(url, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        return const Right(true);
      } else {
        return Left(ServerFailure(
            title: 'Posts', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
