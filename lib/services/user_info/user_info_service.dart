

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';

import '../../common/error/failures.dart';
import '../../models/user/user.dart';

abstract class UserInfoService {
  Future<Either<Failure, UserPublicationsInfo>> getInfo(String id);
  Future<Either<Failure, List>> userSearch({String? searchTerm});
  Future<Either<Failure, User>> getUser(String userId);
}