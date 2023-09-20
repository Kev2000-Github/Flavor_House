import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/models/post/recipe.dart';
import 'package:flavor_house/screens/recipes/skeleton_recipe.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../models/config/sort_config.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/input_post.dart';
import '../../widgets/modal/sort.dart';
import '../../widgets/post_skeleton.dart';
import '../../widgets/sort.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  User user = User.initial();
  Paginated<Recipe> posts = Paginated.initial();
  SortConfig selectedSort = SortConfig.latest();
  bool _isInitialPostLoading = false;
  bool _loadingMore = false;

  void setInitialPostLoadingState(bool state) {
    setState(() {
      _isInitialPostLoading = state;
    });
  }

  void setLoadingModeState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  void getPosts(Function(bool) setLoadingState, {bool reset = false}) async {
    if (user.isInitial()) return;
    if (mounted) setLoadingState(true);
    PostService postClient = HttpPost();
    dartz.Either<Failure, Paginated<Recipe>> result =
    await postClient.getRecipes(sort: selectedSort);
    result.fold((failure) {
      if (mounted) setLoadingState(false);
      CommonPopup.alert(context, failure);
    }, (newPosts) {
      if (mounted) {
        setState(() {
          if (reset) {
            posts = newPosts;
          } else {
            posts.addAll(newPosts.getData());
          }
        });
        setLoadingState(false);
      }
    });
  }

  void onDeletePost(String postId, String type) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, bool> result = await postService.deletePost(postId, type);
    result.fold((l) => CommonPopup.alert(context, l), (r) {
      setState(() {
        posts.removeWhere((element) => element.id == postId);
      });
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
    getPosts(setInitialPostLoadingState, reset: true);
  }

  void onChange(val) {
    setState(() {
      selectedSort = val;
    });
    getPosts(setInitialPostLoadingState, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return !user.isInitial()
        ? Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ListViewInfiniteLoader(
              canLoadMore: posts.page < posts.totalPages,
              loadingState: _loadingMore,
              getMoreItems: getPosts,
              setLoadingModeState: setLoadingModeState,
              children: [
                Conditional(
                  condition: !user.isInitial(),
                  positive: InputPost(avatar: user.picture, onPressed: () {
                    Navigator.of(context).pushNamed(routes.create_recipe);
                  },),
                  negative: Container(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Sort(
                  builder: (context) => SortModalContent(
                    selectedValue: selectedSort,
                    onApply: (selectedConfig) {
                      onChange(selectedConfig);
                    },
                    onCancel: () {
                      onChange(SortConfig.latest());
                    },
                  ),
                ),
                _isInitialPostLoading
                    ? const SkeletonWrapper(child: PostSkeleton(items: 2))
                    : Column(
                    children: List.generate(posts.items,
                            (index) => Helper.createRecipeWidget(posts.getData()[index], user.id, onDeletePost)))
              ]
            ))
        : const SingleChildScrollView(child: SkeletonRecipe(items: 2));
  }
}
