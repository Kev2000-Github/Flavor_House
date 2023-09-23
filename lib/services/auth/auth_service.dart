
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';

abstract class Auth {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> code(String email, String code);
  Future<Either<Failure, bool>> forgotPassword(String email);
  Future<Either<Failure, bool>> newPassword(String password);
  Future<Either<Failure, bool>> logout();
}