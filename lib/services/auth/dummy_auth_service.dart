import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class DummyAuth implements Auth {
  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      if (username == "" || password == "") return Left(LoginEmptyFailure());
      if (username != "test" || password != "test") return Left(LoginFailure());
      User actualUser = User('id', 'ReyDeLaCocina', 'Juan Toledo', 'pepe@gmail.com', 'Hombre',
          '4126451235', 'VEN', "assets/images/avatar.jpg", null);
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, User>> forgotpassword(String username) async {
    try {
      if (username == "") return Left(LoginEmptyFailure());
      if (username != "test") return Left(LoginFailure());
      User actualUser = User(
          'id',
          'test',
          'pepe',
          'pepe@gmail.com',
          'Hombre',
          '4126451235',
          'VEN',
          'assets/images/avatar.jpg',
          null);
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, User>> Code(String code) async {
    try {
      if (code == "") return Left(CodeEmptyFailure());
      if (code != "1234") return Left(CodeFailure());
      User actualUser = User(
          'id',
          'test',
          'pepe',
          'pepe@gmail.com',
          'Hombre',
          '4126451235',
          'VEN',
          'assets/images/avatar.jpg', null);
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure, User>> NewPassword(String Password) async {
    try {
      if (Password == "") return Left(PasswordEmpty());
      User actualUser = User(
          'id',
          'test',
          'pepe',
          'pepe@gmail.com',
          'Hombre',
          '4126451235',
          'VEN',
          'assets/images/avatar.jpg', null);
      return Right(actualUser);
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
