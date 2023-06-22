import 'package:flavor_house/models/post/post.dart';
import 'package:flavor_house/models/post/tag.dart';

class Recipe extends Post {
  final String title;
  final double stars;
  final List<Tag> tags;

  Recipe(
      String id,
      String username,
      String fullName,
      String? avatarURL,
      String description,
      double likes,
      bool isLiked,
      bool isFavorite,
      String? pictureURL,
      this.title,
      this.stars,
      this.tags)
      : super(id, username, fullName, avatarURL, description, likes, isLiked, isFavorite, pictureURL);

}
