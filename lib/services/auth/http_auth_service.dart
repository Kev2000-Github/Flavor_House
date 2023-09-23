import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flavor_house/common/config.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/auth/auth_service.dart';
import 'package:http/http.dart' as http;

import '../../common/session.dart';
import '../../models/country.dart';

class HttpAuth implements Auth {
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/logins');
      var body = json.encode({
        'email': email,
        'password': password,
      });
      var response = await http.post(url, body: body, headers: Config.headerInitial);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (response.statusCode == 200) {
        User user =  User.fromJson(decodedResponse['data']);
        user.token = decodedResponse['token'];
        return Right(user);
      } else {
        return Left(ServerFailure(
            title: 'Login', message: decodedResponse['error']['message']));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> forgotPassword(String email) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/OTP/$email');
      await http.get(url, headers: Config.headerInitial);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> code(String email, String code) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/OTP');
      var body = json.encode({
        'email': email,
        'code': code,
      });
      var response = await http.post(url, body: body, headers: Config.headerInitial);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      User user =  User.fromJson(decodedResponse['data']);
      user.token = decodedResponse['token'];
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> newPassword(String password) async {
    try {
      String hostname = Config.backURL;
      Uri url = Uri.parse('$hostname/v1/users/OTP');
      var body = json.encode({
        'password': password,
      });
      await http.put(url, body: body, headers: Config.headerInitial);
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      return const Right(true);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
