

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user_publications_info.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';

class DummyUserInfoService implements UserInfoService {
  @override
  Future<Either<Failure, UserPublicationsInfo>> getInfo(String id) async {
    try {
      UserPublicationsInfo userInfo = UserPublicationsInfo(1521,2635,10, "ReyDeLaCocina", "Juan Toledo");
      return Right(userInfo);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

}