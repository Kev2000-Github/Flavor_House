import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/modal/comments.dart';
import 'package:flavor_house/widgets/post_user.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../utils/colors.dart';
import '../utils/text_themes.dart';
import '../utils/time.dart';

class PostMoment extends StatelessWidget {
  final Moment post;
  final bool isSameUser;
  const PostMoment(
      {Key? key, required this.isSameUser, required this.post})
      : super(key: key);

  void onOpenComments(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => CommentsModalContent(
              recipeId: post.id,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                PostUser(fullName: post.fullName, username: post.username, avatar: post.avatar),
                const Spacer(),
                isSameUser && !hasOneDayPassed(post.createdAt) ? GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(routes.createpost, arguments: post);
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Text("editar", style: TextStyle(color: primaryColor),)
                  )
                ) : Container()
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: post.picture ?? Image.asset("assets/images/gray.png")),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Helper.createPostDescription(post.description)),
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Wrap(spacing: 10, children: [
                LikeButton(
                    isLiked: post.isLiked,
                    size: 28,
                    likeBuilder: (isTapped) {
                      return Icon(
                          isTapped ? Icons.favorite : Icons.favorite_outline,
                          color: isTapped ? redColor : gray03Color);
                    }),
                LikeButton(
                  isLiked: post.isFavorite,
                  size: 28,
                  likeBuilder: (isTapped) {
                    return Icon(
                        isTapped ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: isTapped ? primaryColor : gray03Color);
                  },
                ),
                GestureDetector(
                  onTap: () {
                    onOpenComments(context);
                  },
                  child: const Icon(Icons.mode_comment_outlined,
                      size: 26, color: gray03Color),
                )
              ]),
            ]),
            Padding(
                padding: const EdgeInsets.only(left: 5, top: 5),
                child: Text(
                  "${post.likes} Me gusta",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: darkColor),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 5, top: 8),
                child: Text(
                  formatTimeAgo(post.createdAt),
                  style: DesignTextTheme.get(type: TextThemeEnum.grayLight),
                ))
          ]),
        ));
  }
}
