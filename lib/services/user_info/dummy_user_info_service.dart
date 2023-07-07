

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flutter/material.dart';

import '../../models/user/user.dart';

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

  @override
  Future<Either<Failure, List>> userSearch({String? searchTerm}) async {
    try {
      List<UserItem> users = [
        UserItem("1", "ReyDeLaCocina", "Juan Toledo", "Venezuela", "assets/images/avatar.jpg", true),
        UserItem("2", "CocinaDelPirata", "Ben Torner", "España", "assets/images/avatar.jpg", false),
        UserItem("3", "ReyDeLaCocina", "Donald Trump", "USA", "assets/images/avatar.jpg", true),
        UserItem("4", "mexicazo", "Lopez Obrador", "Mexico", "assets/images/avatar.jpg", true),
        UserItem("5", "armando", "Armando", "Venezuela", "assets/images/avatar.jpg", true),
        UserItem("6", "ReyDeLaCocina", "Juan Toledo", "Venezuela", "assets/images/avatar.jpg", true),
        UserItem("7", "ReyDeLaCocina", "Juan Toledo", "Venezuela", "assets/images/avatar.jpg", true),
      ];
      await Future.delayed(const Duration(seconds: 1));
      return Right(users);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    User user = User('id', 'test', 'pepe', 'pepe@gmail.com', 'Hombre',
        '4126451235', 'VEN', "assets/images/avatar.jpg", false);
    return Right(user);
  }
}