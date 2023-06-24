import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/screens/recipes/skeleton_recipe.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../models/post/post.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/constants.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/cache.dart';
import '../../widgets/input_post.dart';
import '../../widgets/post_recipe.dart';
import '../../widgets/sort.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  User? user;
  List<Recipe> posts = [];
  SortConfig selectedSort = SortConfig.latest();

  void getPosts() async {
    if(user == null) return;
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result =
        await postClient.getRecipes(selectedSort);
    result.fold((failure) => null, (newPosts) {
      if(mounted){
        setState(() {
          posts = newPosts as List<Recipe>;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if(mounted){
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return posts.isNotEmpty ? Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            user != null
                ? InputPost(avatarURL: user?.picture ?? "")
                : Container(),
            const SizedBox(
              height: 20,
            ),
            Sort(selectedValue: selectedSort, onChange: (val) {
              setState(() {
                selectedSort = val;
              });
              getPosts();
            },),
            ...List.generate(
                posts.length,
                    (index) => Helper.createRecipeWidget(posts[index]))
          ]),
        )) : const SingleChildScrollView(child: SkeletonRecipe(items: 2));
  }
}
