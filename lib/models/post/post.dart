

abstract class Post {
  final String id;
  final String username;
  final String fullName;
  final String? avatarURL;
  final String description;
  final double likes;
  final bool isLiked;
  final bool isFavorite;
  final String? pictureURL;

  Post(this.id, this.username, this.fullName, this.avatarURL, this.description, this.likes,
      this.isLiked, this.isFavorite, this.pictureURL);
}