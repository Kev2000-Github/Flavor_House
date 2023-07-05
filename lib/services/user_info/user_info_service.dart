

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';

import '../../common/error/failures.dart';

abstract class UserInfoService {
  Future<Either<Failure, UserPublicationsInfo>> getInfo(String id);
  Future<Either<Failure, List>> userSearch({String? searchTerm});
}