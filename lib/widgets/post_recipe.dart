import 'package:dartz/dartz.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/models/post/tag.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/modal/recipe_details/details.dart';
import 'package:flavor_house/widgets/post_user.dart';
import 'package:flavor_house/widgets/stars.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

import '../common/error/failures.dart';
import '../common/popups/common.dart';
import '../services/post/http_post_service.dart';
import '../services/post/post_service.dart';
import '../utils/colors.dart';
import '../utils/helpers.dart';
import '../utils/time.dart';
import 'conditional.dart';
import 'modal/comments.dart';

class PostRecipe extends StatelessWidget {
  final Recipe post;
  final bool isSameUser;
  final Function(String, String)? deletePost;
  final Function(String, String)? editPost;
  const PostRecipe({
    Key? key,
    required this.post,
    required this.isSameUser,
    this.deletePost, this.editPost,
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
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(routes.other_user_profile,
                          arguments: post.userId);
                    },
                    child: PostUser(
                        fullName: post.fullName,
                        username: post.username,
                        avatar: post.avatar)),
                const Spacer(),
                Conditional(
                    condition: isSameUser && !hasOneDayPassed(post.createdAt),
                    positive: IconButton(
                        onPressed: () {
                          if(editPost != null){
                            editPost!(post.id, 'Recipe');
                          }
                          else{
                            Navigator.of(context)
                                .pushNamed(routes.create_recipe, arguments: post);
                          }
                        },
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.edit,
                          color: primaryColor,
                        ))),
                Conditional(
                    condition: isSameUser && !hasOneDayPassed(post.createdAt),
                    positive: IconButton(
                        onPressed: () {
                          CommonPopup.deletePost(context, onConfirm: () {
                            if (deletePost != null) {
                              deletePost!(post.id, 'Recipe');
                            }
                            Navigator.of(context).pop();
                          });
                        },
                        splashRadius: 20,
                        icon: const Icon(
                          Icons.delete,
                          color: redColor,
                        ))),
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
            const SizedBox(height: 10),
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
            Conditional(
              condition: post.pictureURL != null,
              positive: ClipRRect(
                  borderRadius: BorderRadius.circular(20), child: post.picture),
            ),
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
                    isLiked: post.isFavorite,
                    size: 28,
                    onTap: (isFavorite) async {
                      PostService postService = HttpPost();
                      Either<Failure, bool> result = await postService.toggleFavorite(post.id, !isFavorite);
                      return result.fold((failure) {
                        CommonPopup.alert(context, failure);
                        return isFavorite;
                      }, (returnedFav) {
                        return returnedFav;
                      });
                    },
                    likeBuilder: (isTapped) {
                      return Icon(
                          isTapped ? Icons.favorite : Icons.favorite_outline,
                          color: isTapped ? redColor : gray03Color);
                    }),
                LikeButton(
                  isLiked: post.isLiked,
                  size: 28,
                  onTap: (isLiked) async {
                    PostService postService = HttpPost();
                    Either<Failure, bool> result = await postService.toggleLike(post.id, !isLiked);
                    return result.fold((failure) {
                      CommonPopup.alert(context, failure);
                      return isLiked;
                    }, (returnedLike) {
                      return returnedLike;
                    });
                  },
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
              StarsRating(onRate: (index) {}, rate: post.stars)
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
