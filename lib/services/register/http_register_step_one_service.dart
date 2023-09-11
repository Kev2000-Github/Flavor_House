import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/register/register_step_one_service.dart';
import 'package:http/http.dart' as http;

import '../../common/config.dart';
import '../../common/session.dart';

class HttpRegisterStepOne implements RegisterStepOne {
  @override
  Future<Either<Failure, User>> register(
      String username, String fullName, String email, String password) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users');
      var body = json.encode({
        'username': username,
        'email': email,
        'password': password,
        'fullName': fullName
      });
      var response = await http.post(
          url,
          headers: Config.headerInitial,
          body: body
      );
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if(response.statusCode == 200){
        Session session = Session();
        User user = User.fromJson(decodedResponse['data']);
        user.token = decodedResponse['token'];
        session.token = user.token ?? '';
        return Right(user);
      }
      else{
        return Left(ServerFailure(title: 'Inicio Sesión', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return const Left(TimeOutFailure(title: 'Inicio Sesión'));
    }
  }
}
