
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';
import 'package:flutter/material.dart';

class DummyRegisterStepTwo implements RegisterStepTwo {
  @override
  Future<Either<Failure, User>> registerAditionalInfo(String countryId, String? genderId, List<String> interests) async {
    try {
      User actualUser = User(
          'id',
          'test',
          'pepe',
          'pepe@gmail.com',
          'Hombre',
          '4126451235',
          'VEN',
          Image.asset("assets/images/avatar.jpg"));
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}