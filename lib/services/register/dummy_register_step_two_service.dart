
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/country.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/register/register_step_two_service.dart';

import '../../models/interest.dart';

class DummyRegisterStepTwo implements RegisterStepTwo {
  @override
  Future<Either<Failure, User>> registerAdditionalInfo(String countryId, String? genderId, List<String> interests) async {
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

  @override
  Future<Either<Failure, List<Country>>> getCountries() async {
    List<Country> countries = [
      Country("1", "Afganistán"),
      Country("2", "Albania"),
      Country("3", "Alemania"),
      Country("4", "Andorra"),
      Country("5", "Angola"),
      Country("6", "Antigua y Barbuda"),
      Country("7", "Arabia Saudita"),
      Country("8", "Argelia"),
      Country("9", "Argentina"),
      Country("10", "Armenia"),
      Country("11", "Australia"),
      Country("12", "Austria"),
      Country("13", "Azerbaiyán"),
      Country("14", "Bahamas"),
      Country("15", "Bahrein"),
      Country("16", "Bangladesh"),
      Country("17", "Barbados"),
      Country("18", "Bélgica"),
      Country("19", "Belice"),
      Country("20", "Benín"),
      Country("21", "Bhután"),
      Country("22", "Bolivia"),
      Country("23", "Bosnia y Herzegovina"),
      Country("24", "Botsuana"),
      Country("25", "Brasil"),
      Country("26", "Brunéi"),
      Country("27", "Bulgaria"),
      Country("28", "Burkina Faso"),
      Country("29", "Burundi"),
      Country("30", "Cabo Verde"),
      Country("31", "Camboya"),
      Country("32", "Camerún"),
      Country("33", "Canada"),
      Country("34", "Chad"),
      Country("35", "Chile"),
      Country("36", "China"),
      Country("37", "Chipre"),
      Country("38", "Colombia"),
      Country("39", "Costa Rica"),
      Country("40", "Croacia")
    ];
    return Right(countries);
  }
}