import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:http/http.dart' as http;

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
      {String? searchTerm}) async {
    try {
      String hostname = Config.backURL;
      Uri url =
          Uri.parse('$hostname/v1/users?search=$searchTerm&checkFollow=true');
      var response =
          await http.get(url, headers: Config.headerAuth(Session().token));
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
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/${user.id}');
      Map<String, dynamic> body = {
        'username': user.username,
        'email': user.email,
        'fullName': user.fullName,
      };
      if(user.gender != "") body['sex'] = user.gender;
      if(user.country?.id != "") body['countryId'] = user.country?.id;
      if(user.phoneNumber != "") body['phoneNumber'] = user.phoneNumber;
      var response = await http.put(
          url,
          headers: Config.headerAuth(Session().token),
          body: body
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if(response.statusCode == 200){
        Session session = Session();
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
