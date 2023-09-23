

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/services/paginated.dart';

import '../../common/error/failures.dart';
import '../../models/user/user.dart';

abstract class UserInfoService {
  Future<Either<Failure, UserPublicationsInfo>> getInfo(String id);
  Future<Either<Failure, Paginated>> userSearch({String? searchTerm, int? page});
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, bool>> updateFollow(String userId, bool follow);
  Future<Either<Failure, User>> updateUser({required User user, File? imageFile});
  Future<Either<Failure, bool>> updatePassword(String id, String pass);
}