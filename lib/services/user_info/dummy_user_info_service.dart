

import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/error/failures.dart';
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
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

  @override
  Future<Either<Failure, List>> userSearch({String? searchTerm}) async {
    try {
      List<UserItem> users = [
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
        UserItem("ReyDeLaCocina", "Juan Toledo", "Venezuela", "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg"),
      ];
      await Future.delayed(const Duration(seconds: 1));
      return Right(users);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}