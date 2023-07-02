
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';

import '../../models/interest.dart';

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
          "assets/images/avatar.jpg");
      return Right(actualUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Interest>>> getInterests() async {
    List<Interest> interests = [
      Interest("1", "dulce", "assets/images/interest.jpg"),
      Interest("2", "BBQ", "assets/images/interest.jpg"),
      Interest("3", "Frutas", "assets/images/interest.jpg"),
      Interest("4", "Chocolate", "assets/images/interest.jpg"),
      Interest("5", "Proteinas", "assets/images/interest.jpg"),
      Interest("6", "China", "assets/images/interest.jpg"),
      Interest("7", "Japones", "assets/images/interest.jpg"),
      Interest("8", "Papas fritas", "assets/images/interest.jpg"),
    ];
    return Right(interests);
  }
}