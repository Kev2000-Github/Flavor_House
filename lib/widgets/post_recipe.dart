import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/modal/recipe_details/details.dart';
import 'package:flavor_house/widgets/post_user.dart';
import 'package:flavor_house/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../utils/time.dart';
import 'modal/comments.dart';

class PostRecipe extends StatelessWidget {
  final Recipe post;
  final bool isSameUser;
  const PostRecipe({
    Key? key,
    required this.post,
    required this.isSameUser,
  }) : super(key: key);

  void onOpenComments(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => CommentsModalContent(recipeId: post.id));
  }

  void onOpenDetails(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (context) => DetailsModalContent(
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
                PostUser(
                    fullName: post.fullName,
                    username: post.username,
                    avatar: post.avatar),
                const Spacer(),
                isSameUser && !hasOneDayPassed(post.createdAt)
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(routes.create_recipe, arguments: post);
                        },
                        child: const Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Text(
                              "editar",
                              style: TextStyle(color: primaryColor),
                            )))
                    : Container(),
                IconButton(
                    onPressed: () {
                      onOpenDetails(context);
                    },
                    iconSize: 33,
                    splashRadius: 22,
                    icon: const Icon(Icons.import_contacts,
                        color: secondaryColor))
              ],
            ),
            Wrap(
                spacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                        fontSize: 22,
                        color: darkColor,
                        fontWeight: FontWeight.bold),
                  ),
                ]),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: post.picture ?? Image.asset("assets/images/gray.png")),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Helper.createPostDescription(post.description)),
            Wrap(
              spacing: 10,
              children: List.generate(post.tags.length, (index) {
                return ChoiceChip(
                  label: Text(post.tags[index].name),
                  selected: true,
                  //selectedShadowColor: primaryColor,
                  selectedColor: post.tags[index].color,
                );
              }),
            ),
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
              const Spacer(),
              StarsRating(
                  onRate: (index) {},
                  rate: post.stars)
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
