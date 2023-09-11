import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/session.dart';
import '../../models/interest.dart';

class HttpRegisterStepTwo implements RegisterStepTwo {
  @override
  Future<Either<Failure, User>> registerAdditionalInfo(
      String userId, String countryId, String? genderId, List<String> interests) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/$userId');
      var body = json.encode({
        'countryId': countryId,
        'sex': genderId,
        'interests': interests
      });
      var response = await http.put(
          url,
          headers: Config.headerAuth(Session().token),
          body: body
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if(response.statusCode == 200){
        User user = User.fromJson(decodedResponse['data']);
        user.token = Session().token;
        return Right(user);
      }
      else{
        return Left(ServerFailure(title: 'Registro', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      print(e);
      return const Left(TimeOutFailure(title: 'Registro'));
    }
  }

  @override
  Future<Either<Failure, List<Interest>>> getInterests() async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/interests');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Interest> interests = items.map((item) => Interest.fromJson(item)).toList();
      return Right(interests);
    }
    else{
      return Left(ServerFailure(title: 'Registro', message: decodedResponse['error']['message']));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    String hostname = Config.backURL;
    Uri url = Uri.parse('$hostname/v1/countries');
    var response = await http.get(url, headers: Config.headerAuth(Session().token));
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if(response.statusCode == 200){
      List<dynamic> items = decodedResponse['data'];
      List<Country> countries = items.map((item) => Country.fromJson(item)).toList();
      return Right(countries);
    }
    else{
      return Left(ServerFailure(title: 'Registro', message: decodedResponse['error']['message']));
    }
  }
}
