import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/post/comment.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/post/dummy_post_service.dart';
import 'package:flavor_house/services/post/post_service.dart';
import 'package:flavor_house/utils/time.dart';
import 'package:flavor_house/widgets/Avatar.dart';
import 'package:flavor_house/widgets/button.dart';
import 'package:flavor_house/widgets/modal/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../providers/user_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_themes.dart';
import '../text_field.dart';

class CommentsModalContent extends StatefulWidget {
  final String recipeId;
  const CommentsModalContent({super.key, required this.recipeId});

  @override
  State<CommentsModalContent> createState() => _CommentsModalContentState();
}

class _CommentsModalContentState extends State<CommentsModalContent> {
  final double maxModalHeight = 0.8;
  final double minModalHeight = 0.5;
  final double avatarHeight = 55;
  final TextEditingController _commentController = TextEditingController();
  User? user;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
    getComments();
  }

  void getComments() async {
    PostService commentService = DummyPost();
    dartz.Either<Failure, List<Comment>> result =
        await commentService.getComments("postId");
    result.fold((l) => null, (List<Comment> comments) {
      setState(() {
        this.comments = comments;
      });
    });
  }

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) =>
            TextInputModalContent(onSend: (String comment) {
              //TODO: Beware Dummy Implementation!!
              setState(() {
                Comment newComment = Comment("1", user!.id, user!.username, user!.fullName, comment, DateTime.now(), user?.pictureURL);
                comments.add(newComment);
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: maxModalHeight,
        maxChildSize: maxModalHeight,
        minChildSize: minModalHeight,
        builder: (_, controller) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(height: 5, width: 40, color: gray03Color),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Comentarios",
                    style: DesignTextTheme.get(type: TextThemeEnum.darkMedium),
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(
                      height: 1,
                      thickness: 1,
                    )),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Avatar(pictureHeight: avatarHeight, borderSize: 2, image: user?.picture),
                      const SizedBox(width: 10,),
                      Expanded(child: Button(
                        onPressed: () {
                          onOpenTextInput(context);
                        },
                        text: "Agrega un comentario...",
                        borderSide: const BorderSide(color: gray01Color, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        size: const Size.fromHeight(45),
                        fontSize: 14,
                        textColor: gray03Color,
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                      children: List.generate(comments.length, (index) {
                    return Container(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Avatar(
                                pictureHeight: avatarHeight,
                                borderSize: 2,
                                image: comments[index].picture),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.end,
                                    spacing: 10,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(routes.other_user_profile,
                                              arguments: comments[index].userId);
                                        },
                                        child: Text(
                                          comments[index].fullName,
                                          style: DesignTextTheme.get(
                                              type: TextThemeEnum.darkSemiMedium),
                                        )
                                      ),
                                      Text(formatTimeAgo(comments[index].createdAt),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: gray04Color,
                                              fontSize: 12))
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(comments[index].comment, overflow: TextOverflow.clip,)
                                ],
                              )
                            )
                          ],
                        ));
                  })),
                ),
              ],
            ));
  }
}
