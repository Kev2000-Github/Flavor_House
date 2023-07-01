import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/screens/recipes/skeleton_recipe.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/input_post.dart';
import '../../widgets/post_skeleton.dart';
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
  bool _isPostLoading = false;

  void getPosts() async {
    if (user == null) return;
    if (mounted) {
      setState(() => _isPostLoading = true);
    }
    PostService postClient = DummyPost();
    dartz.Either<Failure, List<Recipe>> result =
        await postClient.getRecipes(sort: selectedSort);
    result.fold((failure) {
      if (mounted) {
        setState(() => _isPostLoading = false);
      }
    }, (newPosts) {
      if (mounted) {
        setState(() {
          posts = newPosts;
          setState(() => _isPostLoading = false);
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(children: [
                user != null
                    ? InputPost(avatarURL: user?.picture ?? "")
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Sort(
                  selectedValue: selectedSort,
                  onChange: (val) {
                    setState(() {
                      selectedSort = val;
                    });
                    getPosts();
                  },
                ),
                _isPostLoading
                    ? const SkeletonWrapper(child: PostSkeleton(items: 2))
                    : Column(
                        children: List.generate(posts.length,
                            (index) => Helper.createRecipeWidget(posts[index])))
              ]),
            ))
        : const SingleChildScrollView(child: SkeletonRecipe(items: 2));
  }
}
