import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/screens/home/skeleton_home.dart';
import 'package:flavor_house/services/post/post_service.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/utils/skeleton_wrapper.dart';
import 'package:flavor_house/widgets/input_post.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flavor_house/widgets/sort.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user/user.dart';
import '../../services/post/dummy_post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User user = User.initial();
  List<Moment> posts = [];
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
    dartz.Either<Failure, List<Moment>> result =
        await postClient.getMoments(sort: selectedSort);
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


  @override
  Widget build(BuildContext context) {
    return user != null
        ? Container(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ListViewInfiniteLoader(
              loadingState: _loadingMore,
              getMoreItems: getPosts,
              setLoadingModeState: setLoadingModeState,
              children: [
                user != null
                    ? InputPost(
                  avatar: user?.picture,
                  onPressed: () {
                    Navigator.pushNamed(context, routes.createpost);
                  },
                )
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
                    getPosts(setInitialPostLoadingState, reset: true);
                  },
                ),
                _isInitialPostLoading
                    ? const SkeletonWrapper(child: PostSkeleton(items: 2))
                    : Column(
                  children: List.generate(posts.length,
                          (index) => Helper.createMomentWidget(posts[index], user.id, onDeletePost)),
                ),
              ],
            ))
        : const SingleChildScrollView(
            child: SkeletonHome(
            items: 2,
          ));
  }
}
