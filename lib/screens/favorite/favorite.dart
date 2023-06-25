import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/screens/favorite/skeleton_favorite.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/post/recipe.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user.dart';
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
  User? user;
  List posts = [];
  SortConfig selectedSort = SortConfig.latest();
  bool _isPostLoading = false;

  void getPosts() async {
    if (user == null) return;
    if(mounted){
      setState(() => _isPostLoading = true);
    }
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result = await postClient.getAll(selectedSort);
    result.fold((failure) {
      if(mounted){
        setState(() => _isPostLoading = false);
      }
    }, (newPosts) {
      if (mounted) {
        setState(() {
          posts = newPosts;
          _isPostLoading = false;
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
                        children: List.generate(posts.length, (index) {
                          if (posts[index].runtimeType == Moment) {
                            return Helper.createMomentWidget(posts[index]);
                          }
                          if (posts[index].runtimeType == Recipe) {
                            return Helper.createRecipeWidget(posts[index]);
                          } else {
                            var type = posts[index].runtimeType;
                            print("Failure: $type Not Implemented");
                          }
                          return Container();
                        }),
                      )
              ]),
            ))
        : const SingleChildScrollView(
            child: SkeletonFavorite(
            items: 2,
          ));
  }
}
