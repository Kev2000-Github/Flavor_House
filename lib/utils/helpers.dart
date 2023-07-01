import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/user/user_item.dart' as userItemModel;
import 'package:flavor_house/widgets/post_moment.dart';
import 'package:flavor_house/widgets/post_recipe.dart';
import 'package:flavor_house/widgets/user_item.dart';

class Helper {
  static PostMoment createMomentWidget(Moment post) {
    return PostMoment(
        fullName: post.fullName,
        username: post.username,
        description: post.description,
        likes: post.likes,
        isLiked: post.isLiked,
        isFavorite: post.isFavorite,
        avatarURL: post.avatarURL ?? "",
        pictureURL: post.pictureURL ?? "");
  }

  static PostRecipe createRecipeWidget(Recipe recipe) {
    return PostRecipe(
      fullName: recipe.fullName,
      username: recipe.username,
      description: recipe.description,
      likes: recipe.likes,
      isLiked: recipe.isLiked,
      isFavorite: recipe.isFavorite,
      avatarURL: recipe.avatarURL ?? "",
      pictureURL: recipe.pictureURL ?? "",
      postTitle: recipe.title,
      rates: recipe.stars,
    );
  }

  static UserItem createUserItemWidget(userItemModel.UserItem userInfo) {
    return UserItem(
        fullName: userInfo.fullName,
        username: userInfo.username,
        avatarURL: userInfo.imageURL ?? "https://images.ctfassets.net/hrltx12pl8hq/3Mz6t2p2yHYqZcIM0ic9E2/3b7037fe8871187415500fb9202608f7/Man-Stock-Photos.jpg",
        location: userInfo.location);
  }
}
