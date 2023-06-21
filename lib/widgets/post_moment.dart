import 'package:flavor_house/widgets/post_user.dart';
import 'package:flavor_house/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../utils/colors.dart';

class PostMoment extends StatelessWidget {
  final String fullName;
  final String username;
  final String avatarURL;
  final String postTitle;
  final String description;
  final String pictureURL;
  final int likes;
  final int rates;
  final bool isLiked;
  final bool isFavorite;
  const PostMoment(
      {Key? key,
      required this.fullName,
      required this.username,
      required this.postTitle,
      required this.description,
      required this.likes,
      required this.rates,
      required this.isLiked,
      required this.isFavorite,
      required this.pictureURL,
      required this.avatarURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
             PostUser(
                fullName: fullName,
                username: username,
                avatarURL: avatarURL),
             Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    postTitle,
                    style: const TextStyle(
                        fontSize: 22,
                        color: darkColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const Icon(Icons.import_contacts, color: secondaryColor, size: 33)
                ]),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(pictureURL)),
             Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(description,
                    style: const TextStyle(color: gray04Color))),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Wrap(spacing: 10, children: [
                LikeButton(
                  isLiked: isLiked,
                    size: 28,
                    likeBuilder: (isTapped) {
                      return Icon(
                          isTapped ? Icons.favorite : Icons.favorite_outline,
                          color: isTapped ? redColor : gray03Color);
                    }),
                LikeButton(
                  isLiked: isFavorite,
                  size: 28,
                  likeBuilder: (isTapped) {
                    return Icon(
                        isTapped ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: isTapped ? primaryColor : gray03Color);
                  },
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.mode_comment_outlined,
                      size: 26, color: gray03Color),
                )
              ]),
              const Spacer(),
              StarsRating(
                  onRate: (index) {
                    print(index + 1);
                  },
                  rate: rates)
            ]),
             Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  "$likes Me gusta",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: darkColor),
                ))
          ]),
        ));
    ;
  }
}