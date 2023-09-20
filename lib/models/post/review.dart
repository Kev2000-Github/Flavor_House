
class Review {
  final String id;
  final String userId;
  final String fullName;
  final String review;
  final int stars;
  final DateTime createdAt;

  Review(this.id, this.userId, this.fullName, this.review, this.createdAt, this.stars);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(json['id'], json['User']['id'], json['User']['fullName'], json['content'], json['createdAt'], json['stars']);
  }
}