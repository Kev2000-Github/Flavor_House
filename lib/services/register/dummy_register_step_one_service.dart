import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/register/register_step_one_service.dart';

class DummyRegisterStepOne implements RegisterStepOne {
  @override
  Future<Either<Failure, User>> register(
      String username, String fullName, String email, String password) async {
    try {
      User actualUser = User.basic('id', 'test', 'pepe', 'pepe@gmail.com');
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
