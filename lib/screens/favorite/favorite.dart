import 'package:flavor_house/models/post/moment.dart';
import 'package:flavor_house/utils/helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:dartz/dartz.dart' as dartz;

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../models/post/recipe.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/cache.dart';
import '../../widgets/input_post.dart';
import '../../widgets/post_recipe.dart';
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
    dartz.Either<Failure, List> result = await postClient.getAll(selectedSort);
    result.fold((failure) => null, (newPosts) {
      setState(() {
        posts = newPosts;
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
            Sort(selectedValue: selectedSort, onChange: (val) {
              setState(() {
                selectedSort = val;
              });
              getPosts();
            },),
            ...List.generate(posts.length, (index) {
                if(posts[index].runtimeType == Moment){
                  return Helper.createMomentWidget(posts[index]);
                }
                if(posts[index].runtimeType == Recipe){
                  return Helper.createRecipeWidget(posts[index]);
                }
                else{
                  var type = posts[index].runtimeType;
                  print("Failure: $type Not Implemented");
                }
                return Container();
            })
          ]),
        ));
  }
}
