

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/services/paginated.dart';

import '../../common/error/failures.dart';
import '../../models/user/user.dart';

abstract class UserInfoService {
  Future<Either<Failure, UserPublicationsInfo>> getInfo(String id);
  Future<Either<Failure, Paginated>> userSearch({String? searchTerm});
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, bool>> updateFollow(String userId, bool follow);
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, bool>> updatePassword(String id, String pass);
}