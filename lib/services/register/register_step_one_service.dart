
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user.dart';

abstract class RegisterStepOne {
  Future<Either<Failure, User>> register(String username, String fullName, String email, String password);
}