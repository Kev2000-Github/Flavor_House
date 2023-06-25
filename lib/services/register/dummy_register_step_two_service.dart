
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';

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
          'https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg');
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}