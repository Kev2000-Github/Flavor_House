import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/providers/user_provider.dart';
import 'package:flavor_house/screens/home/skeleton_home.dart';
import 'package:flavor_house/services/post/post_service.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/utils/skeleton_wrapper.dart';
import 'package:flavor_house/widgets/input_post.dart';
import 'package:flavor_house/widgets/post_skeleton.dart';
import 'package:flavor_house/widgets/sort.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user.dart';
import '../../services/post/dummy_post_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  List<Moment> posts = [];
  SortConfig selectedSort = SortConfig.latest();
  bool _isPostLoading = false;

  void getPosts() async {
    if (user == null) return;
    if (mounted) {
      setState(() => _isPostLoading = true);
    }
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result =
        await postClient.getMoments(selectedSort);
    result.fold((failure) {
      if (mounted) {
        setState(() => _isPostLoading = false);
      }
    }, (newPosts) {
      if (mounted) {
        setState(() {
          posts = newPosts as List<Moment>;
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
                        children: List.generate(posts!.length,
                            (index) => Helper.createMomentWidget(posts[index])),
                      )
              ]),
            ))
        : const SingleChildScrollView(
            child: SkeletonHome(
            items: 2,
          ));
  }
}
