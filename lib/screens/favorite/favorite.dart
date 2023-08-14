import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/models/config/post_type_config.dart';
import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/screens/favorite/skeleton_favorite.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/modal/favorite_filtering.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/config/sort_config.dart';
import '../../models/post/recipe.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/sort.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  User user = User.initial();
  List posts = [];
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
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result =
    await postClient.getAll(sort: selectedSort, postFilter: selectedPostType);
    result.fold((failure) {
      if (mounted) setLoadingState(false);
    }, (newPosts) {
      if (mounted) {
        setState(() {
          if (reset) {
            posts = newPosts;
          } else {
            posts.addAll(newPosts);
          }
        });
        setLoadingState(false);
      }
    });
  }

  void onDeletePost(String postId){
    //TODO: Beware dummy implementation!
    setState(() {
      posts.removeWhere((element) => element.id == postId);
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
                    children: List.generate(posts.length, (index) {
                      if (posts[index].runtimeType == Moment) {
                        return Helper.createMomentWidget(posts[index], user.id, onDeletePost);
                      }
                      if (posts[index].runtimeType == Recipe) {
                        return Helper.createRecipeWidget(posts[index], user.id, onDeletePost);
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
