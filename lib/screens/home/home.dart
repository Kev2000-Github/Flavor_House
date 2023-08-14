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
import '../../models/config/sort_config.dart';
import '../../models/user/user.dart';
import '../../services/post/dummy_post_service.dart';
import '../../widgets/conditional.dart';
import '../../widgets/modal/sort.dart';

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
    if (user.isInitial()) return;
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

  void onDeletePost(String postId) {
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

  void onChange(val) {
    setState(() {
      selectedSort = val;
    });
    getPosts(setInitialPostLoadingState, reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Conditional(
        condition: user.id != User.initial().id,
        positive: Container(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ListViewInfiniteLoader(
              loadingState: _loadingMore,
              getMoreItems: getPosts,
              setLoadingModeState: setLoadingModeState,
              children: [
                InputPost(
                  avatar: user.picture,
                  onPressed: () {
                    Navigator.pushNamed(context, routes.createpost);
                  },
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
                Conditional(
                  condition: _isInitialPostLoading,
                  positive: const SkeletonWrapper(child: PostSkeleton(items: 2)),
                  negative: Column(
                    children: List.generate(
                        posts.length,
                            (index) => Helper.createMomentWidget(
                            posts[index], user.id, onDeletePost)),
                  )
                )
              ],
            )),
        negative: const SingleChildScrollView(
            child: SkeletonHome(
          items: 2,
        )));
  }
}
