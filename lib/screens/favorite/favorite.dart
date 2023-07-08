import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/screens/favorite/skeleton_favorite.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/post/recipe.dart';
import '../../models/sort/sort_config.dart';
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
    if (user == null) return;
    if (mounted) setLoadingState(true);
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result =
    await postClient.getAll(sort: selectedSort);
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

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ListViewInfiniteLoader(
              setLoadingModeState: setLoadingModeState,
              getMoreItems: getPosts,
              loadingState: _loadingMore,
              children:  [
                Sort(
                  selectedValue: selectedSort,
                  onChange: (val) {
                    setState(() {
                      selectedSort = val;
                    });
                    getPosts(setInitialPostLoadingState, reset: true);
                  },
                ),
                _isInitialPostLoading
                    ? const SkeletonWrapper(child: PostSkeleton(items: 2))
                    : Column(
                  children: List.generate(posts.length, (index) {
                    if (posts[index].runtimeType == Moment) {
                      return Helper.createMomentWidget(posts[index], user.id);
                    }
                    if (posts[index].runtimeType == Recipe) {
                      return Helper.createRecipeWidget(posts[index], user.id);
                    }
                    return Container();
                  }),
                )
              ],
            ))
        : const SingleChildScrollView(
            child: SkeletonFavorite(
            items: 2,
          ));
  }
}
