import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/post/comment.dart';
import 'package:flavor_house/models/user/user.dart';
import 'package:flavor_house/services/comments/comments_service.dart';
import 'package:flavor_house/utils/time.dart';
import 'package:flavor_house/widgets/Avatar.dart';
import 'package:flavor_house/widgets/button.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/modal/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../providers/user_provider.dart';
import '../../services/comments/http_comments_service.dart';
import '../../services/paginated.dart';
import '../../utils/colors.dart';
import '../../utils/text_themes.dart';
import '../conditional.dart';

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
  User? user;
  Paginated<Comment> comments = Paginated.initial();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
    getComments(setLoadingModeState);
  }

  void getComments(Function(bool) setLoadingState) async {
    CommentService commentService = HttpCommentService();
    dartz.Either<Failure, Paginated<Comment>> result =
        await commentService.getComments(
            widget.recipeId, comments.isNotEmpty ? comments.page + 1 : 1);
    result.fold((l) => null, (Paginated<Comment> comments) {
      setState(() {
        this.comments.addPage(comments);
      });
    });
  }

  void setLoadingModeState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  void createComment(String content) async {
    CommentService commentService = HttpCommentService();
    dartz.Either<Failure, Comment> result =
        await commentService.createComment(widget.recipeId, content);
    result.fold((l) => CommonPopup.alert(context, l), (comment) {
      setState(() {
        comments.insertFirst(comment);
      });
    });
  }

  void deleteComment(String id) async {
    CommentService commentService = HttpCommentService();
    dartz.Either<Failure, Comment> result =
    await commentService.deleteComment(id);
    result.fold((l) => CommonPopup.alert(context, l), (comment) {
      setState(() {
        comments.removeWhere((item) => item.id == id);
      });
    });
  }

  void onOpenTextInput(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => TextInputModalContent(onSend: (String comment) {
              createComment(comment);
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
                      Avatar(
                          pictureHeight: avatarHeight,
                          borderSize: 2,
                          image: user?.picture),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Button(
                        onPressed: () {
                          onOpenTextInput(context);
                        },
                        text: "Agrega un comentario...",
                        borderSide:
                            const BorderSide(color: gray01Color, width: 2),
                        borderRadius: BorderRadius.circular(10),
                        size: const Size.fromHeight(45),
                        fontSize: 14,
                        textColor: gray03Color,
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListViewInfiniteLoader(
                      setLoadingModeState: setLoadingModeState,
                      loadingState: _loadingMore,
                      getMoreItems: getComments,
                      canLoadMore: comments.page < comments.totalPages,
                      children: List.generate(comments.items, (index) {
                        return Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Avatar(
                                    pictureHeight: avatarHeight,
                                    borderSize: 2,
                                    image: comments.getItem(index).picture),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      spacing: 10,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  routes.other_user_profile,
                                                  arguments: comments
                                                      .getItem(index)
                                                      .userId);
                                            },
                                            child: Text(
                                              comments.getItem(index).fullName,
                                              style: DesignTextTheme.get(
                                                  type: TextThemeEnum
                                                      .darkSemiMedium),
                                            )),
                                        Text(
                                            formatTimeAgo(comments
                                                .getItem(index)
                                                .createdAt),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: gray04Color,
                                                fontSize: 12)),
                                        Conditional(
                                          condition: comments.getItem(index).userId == user?.id && !hasOneDayPassed(comments.getItem(index).createdAt),
                                          positive: GestureDetector(
                                            onTap: () {
                                              deleteComment(comments.getItem(index).id);
                                            },
                                            child: const Text(
                                                "Eliminar",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: redColor,
                                                    fontSize: 12)
                                            )
                                          )
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      comments.getItem(index).comment,
                                      overflow: TextOverflow.clip,
                                    )
                                  ],
                                ))
                              ],
                            ));
                      })),
                ),
              ],
            ));
  }
}
