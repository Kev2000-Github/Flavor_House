
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/interest.dart';
import 'package:flavor_house/models/user/user.dart';

abstract class RegisterStepTwo {
  Future<Either<Failure, User>> registerAdditionalInfo(String countryId, String? genderId, List<String> interests);
  Future<Either<Failure, List<Interest>>> getInterests();
}