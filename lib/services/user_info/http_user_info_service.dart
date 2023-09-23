import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../../common/config.dart';
import '../../common/session.dart';
import '../../models/user/user.dart';

class HttpUserInfoService implements UserInfoService {
  @override
  Future<Either<Failure, UserPublicationsInfo>> getInfo(String id) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/$id?additionalInfo=true');
      var response = await http.get(
        url,
        headers: Config.headerAuth(Session().token),
      );
      var decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        UserPublicationsInfo userInfo =
            UserPublicationsInfo.fromJson(decodedResponse['data']);
        return Right(userInfo);
      } else {
        return Left(
            ServerFailure(message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return const Left(TimeOutFailure(title: 'Usuario'));
    }
  }

  @override
  Future<Either<Failure, Paginated>> userSearch(
      {String? searchTerm, int? page}) async {
    try {
      String hostname = Config.backURL;
      String? pageFormatted = page != null ? 'page=$page' : null;
      String checkFollow = 'checkFollow=true';
      String search = 'search=$searchTerm';
      List<String?> possibleQueryURLs = [search, pageFormatted, checkFollow];
      List<String?> applicableQueryURLs = possibleQueryURLs.where((el) => el != null).toList();
      String queryURL = applicableQueryURLs.isNotEmpty ? '?${applicableQueryURLs.join('&')}' : '';
      Uri url = Uri.parse('$hostname/v1/users$queryURL');
      var response = await http.get(url, headers: Config.headerAuth(Session().token));
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        List<dynamic> items = decodedResponse['data'];
        List<UserItem> userItems = items.map((item) {
          UserItem user = UserItem.fromJson(item);
          return user;
        }).toList();
        final result = Paginated<UserItem>(userItems,
            decodedResponse['page'], decodedResponse['totalPages']);
        return Right(result);
      } else {
        return Left(ServerFailure(
            title: 'Registro', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return const Left(TimeOutFailure(title: 'Usuario'));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse(
        '$hostname/v1/users/$userId?checkFollow=true&additionalInfo=true');
    var response =
        await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (response.statusCode == 200) {
      decodedResponse['data']['avatar'] = Config.imgURL(decodedResponse['data']['avatar']);
      User user = User.fromJson(decodedResponse['data']);
      return Right(user);
    } else {
      return Left(ServerFailure(message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, bool>> updateFollow(String userId, bool follow) async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/users/follow/$userId');
    var body = json.encode({
      "follow": follow
    });
    var response =
        await http.post(url, body: body, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (response.statusCode == 200) {
      return Right(decodedResponse['data']['follow']);
    } else {
      return Left(ServerFailure(message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser({required User user, File? imageFile}) async {
    try {
      String hostname = Config.backURL;
      String url = '$hostname/v1/users/${user.id}';
      Map<String, dynamic> body = {
        'username': user.username,
        'email': user.email,
        'fullName': user.fullName,
      };
      if(user.gender != "") body['sex'] = user.gender!;
      if(user.country?.id != "") body['countryId'] = user.country!.id;
      if(user.phoneNumber != "") body['phoneNumber'] = user.phoneNumber!;
      if(imageFile != null) {
          String fileName = imageFile.path.split('/').last;
          String ext = fileName.split('.').last;
          body['avatar'] = await MultipartFile.fromFile(
          imageFile.path,
          filename: 'avatar.$ext',
            contentType: MediaType("image", ext)
        );
      }
      FormData formData = FormData.fromMap(body);
      var dio = Dio();
      dio.options.headers['authorization'] = Session().token;
      var response = await dio.put(url, data: formData);
      var decodedResponse = response.data;
      if(response.statusCode == 200){
        Session session = Session();
        var avatar = decodedResponse['data']['avatar'];
        if(avatar != null){
          decodedResponse['data']['avatar'] = Config.imgURL(avatar);
        }
        User user = User.fromJson(decodedResponse['data']);
        user.token = session.token;
        return Right(user);
      }
      else{
        return Left(ServerFailure(title: 'Inicio Sesión', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return const Left(TimeOutFailure(title: 'Inicio Sesión'));
    }
  }

  @override
  Future<Either<Failure, bool>> updatePassword(String id, String pass) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/$id');
      var response = await http.put(
          url,
          headers: Config.headerAuth(Session().token),
          body: {
            "password": pass
          }
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if(response.statusCode == 200){
        return const Right(true);
      }
      else{
        return Left(ServerFailure(title: 'Actualizar Usuario', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return const Left(TimeOutFailure(title: 'Actualizar Usuario'));
    }
  }
}
