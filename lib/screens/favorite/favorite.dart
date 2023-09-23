import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/screens/favorite/skeleton_favorite.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/modal/favorite_filtering.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../models/config/sort_config.dart';
import '../../models/post/recipe.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/post_service.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/post_moment.dart';
import '../../widgets/post_recipe.dart';
import '../../widgets/sort.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  User user = User.initial();
  Paginated posts = Paginated.initial();
  SortConfig selectedSort = SortConfig.latest();
  PostTypeConfig selectedPostType = PostTypeConfig.All();
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
    dartz.Either<Failure, Paginated> result =
    await postClient.getAll(
        sort: selectedSort,
        postFilter: selectedPostType,
        isFavorite: true,
        page: posts.isNotEmpty && !reset ? posts.page + 1 : 1
    );
    result.fold((failure) {
      if (mounted) setLoadingState(false);
    }, (newPosts) {
      if (mounted) {
        setState(() {
          if (reset) {
            posts = newPosts;
          } else {
            posts.addPage(newPosts);
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

  void onEditPost(String postId, String type) async {
    String route = type == 'Moment' ? routes.createpost : routes.create_recipe;
    var post = await Navigator.of(context).pushNamed(route,
        arguments: posts.findItem((post) => post.id == postId));
    if(post != null){
      getPosts(setInitialPostLoadingState, reset: true);
    }
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

  void onChange(sort, postType) {
    setState(() {
      selectedSort = sort;
      selectedPostType = postType;
    });
    getPosts(setInitialPostLoadingState, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Conditional(
      condition: !user.isInitial(),
      positive: Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: ListViewInfiniteLoader(
            canLoadMore: posts.page < posts.totalPages,
            setLoadingModeState: setLoadingModeState,
            getMoreItems: getPosts,
            loadingState: _loadingMore,
            children:  [
              Sort(
                builder: (context) => FavoriteModalContent(
                  selectedPostType: selectedPostType,
                  selectedValue: selectedSort,
                  onApply: (selectedConfig, selectedPostType) {
                    onChange(selectedConfig, selectedPostType);
                  },
                  onCancel: () {
                    onChange(SortConfig.latest(), PostTypeConfig.All());
                  },
                ),
              ),
              Conditional(
                  condition: _isInitialPostLoading,
                  positive: const SkeletonWrapper(child: PostSkeleton(items: 2)),
                  negative: Column(
                    children: List.generate(posts.items, (index) {
                      if (posts.getData()[index].runtimeType == Moment) {
                        return PostMoment(
                          isSameUser: posts.getItem(index).userId == user.id,
                          post: posts.getData()[index],
                          deletePost: onDeletePost,
                          editPost: onEditPost,
                        );
                      }
                      if (posts.getData()[index].runtimeType == Recipe) {
                        return PostRecipe(
                          isSameUser: posts.getItem(index).userId == user.id,
                          post: posts.getItem(index),
                          deletePost: onDeletePost,
                          editPost: onEditPost,
                        );
                      }
                      return Container();
                    }),
                  )
              ),
            ],
          )),
      negative:const SingleChildScrollView(
          child: SkeletonFavorite(
            items: 2,
          ))
    );
  }
}
