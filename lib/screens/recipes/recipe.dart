import 'package:flavor_house/models/post/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../models/post/post.dart';
import '../../models/user.dart';
import '../../services/post/constants.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/cache.dart';
import '../../widgets/input_post.dart';
import '../../widgets/post_recipe.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  User? user;
  List<Recipe> posts = [];

  void getUser() async {
    User? localUser = await getLocalUser();
    if (localUser == null) CommonPopup.alertUserNotLogged(context);
    setState(() {
      user = localUser!;
    });
    getPosts(localUser!);
  }

  void getPosts(User user) async {
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result =
        await postClient.getRecipes();
    result.fold((failure) => null, (newPosts) {
      print(newPosts[0]);
      setState(() {
        posts = newPosts as List<Recipe>;
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
            user != null
                ? InputPost(avatarURL: user?.picture ?? "")
                : Container(),
            const SizedBox(
              height: 20,
            ),
            ...List.generate(
                posts.length,
                (index) => PostRecipe(
                      fullName: posts[index].fullName,
                      username: posts[index].username,
                      description: posts[index].description,
                      likes: posts[index].likes,
                      isLiked: posts[index].isLiked,
                      isFavorite: posts[index].isFavorite,
                      avatarURL: posts[index].avatarURL ?? "",
                      pictureURL: posts[index].pictureURL ?? "",
                      postTitle: posts[index].title,
                      rates: posts[index].stars,
                    ))
          ]),
        ));
  }
}
