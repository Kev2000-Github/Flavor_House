import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/services/post/constants.dart';
import 'package:flavor_house/services/post/post_service.dart';
import 'package:flavor_house/utils/cache.dart';
import 'package:flavor_house/widgets/input_post.dart';
import 'package:flavor_house/widgets/post_moment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/post/post.dart';
import '../../models/user.dart';
import '../../services/post/dummy_post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  List<Moment> posts = [];

  void getUser() async {
    User? localUser = await getLocalUser();
    if(localUser == null) CommonPopup.alertUserNotLogged(context);
    setState(() {
      user = localUser!;
    });
    getPosts(localUser!);
  }

  void getPosts(User user) async {
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result = await postClient.getMoments();
    result.fold((failure) => null, (newPosts) {
      setState(() {
        posts = newPosts as List<Moment>;
      });
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            user != null ? InputPost(avatarURL: user?.picture ?? "") : Container(),
            const SizedBox(
              height: 20,
            ),
            ...List.generate(posts!.length, (index) => PostMoment(
                fullName: posts[index].fullName,
                username: posts[index].username,
                description: posts[index].description,
                likes: posts[index].likes,
                isLiked: posts[index].isLiked,
                isFavorite: posts[index].isFavorite,
                avatarURL: posts[index].avatarURL ?? "",
                pictureURL: posts[index].pictureURL ?? ""))

          ]),
        ));
  }
}
