
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';

abstract class Auth {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> Code(String code);
  Future<Either<Failure, User>> forgotpassword(String username);
  Future<Either<Failure, User>> NewPassword(String Password);
  Future<Either<Failure, bool>> logout();
}