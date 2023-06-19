
import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user.dart';
import 'package:flavor_house/services/auth/auth_service.dart';

class DummyAuth implements Auth {
  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try{
      if(username != "test" || password != "test") return Left(LoginFailure());
      User actualUser = User('id', 'test', 'pepe', 'pepe@gmail.com', 'Hombre', '4126451235', 'VEN', 'picture');
      return Right(actualUser);
    }
    catch(e){
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try{
      return const Right(true);
    }
    catch(e){
      return Left(CacheFailure());
    }
  }
  
}