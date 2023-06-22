import 'package:equatable/equatable.dart';
import 'package:flavor_house/models/post/post.dart';

class Moment extends Post {
  Moment(
      String id,
      String username,
      String fullName,
      String? avatarURL,
      String description,
      double likes,
      bool isLiked,
      bool isFavorite,
      String? pictureURL)
      : super(id, username, fullName, avatarURL, description, likes, isLiked,
            isFavorite, pictureURL);

}
