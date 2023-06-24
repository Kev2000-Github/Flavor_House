import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/popups/common.dart';
import 'package:flavor_house/services/post/post_service.dart';
import 'package:flavor_house/utils/cache.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flavor_house/widgets/input_post.dart';
import 'package:flavor_house/widgets/post_moment.dart';
import 'package:flavor_house/widgets/sort.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user.dart';
import '../../services/post/dummy_post_service.dart';
import '../../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user;
  List<Moment> posts = [];
  SortConfig selectedSort = SortConfig.latest();

  void getUser() async {
    User? localUser = await getLocalUser();
    if (localUser == null) CommonPopup.alertUserNotLogged(context);
    setState(() {
      user = localUser!;
    });
    getPosts();
  }

  void getPosts() async {
    if(user == null) return;
    PostService postClient = DummyPost();
    dartz.Either<Failure, List> result = await postClient.getMoments(selectedSort);
    result.fold((failure) => null, (newPosts) {
      setState(() {
        posts = newPosts as List<Moment>;
      });
    });
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            ...List.generate(posts!.length,
                (index) => Helper.createMomentWidget(posts[index]))
          ]),
        ));
  }
}
