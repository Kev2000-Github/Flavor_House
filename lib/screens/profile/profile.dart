import 'package:flavor_house/models/user_publications_info.dart';
import 'package:flavor_house/screens/profile/skeleton_profile.dart';
import 'package:flavor_house/services/user_info/dummy_user_info_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/utils/cache.dart';
import 'package:flavor_house/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/post/recipe.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../widgets/button.dart';
import '../../widgets/post_skeleton.dart';
import '../../widgets/sort.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  UserPublicationsInfo? userInfo;
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

  void getUserInfo() async {
    if (user == null) return;
    UserInfoService userInfoService = DummyUserInfoService();
    dartz.Either<Failure, UserPublicationsInfo> result = await userInfoService.getInfo(user!.id);
    result.fold((failure) => null, (newUserPublicationsInfo) {
      if (mounted) {
        setState(() {
          userInfo = newUserPublicationsInfo;
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
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            userInfo != null ?
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Avatar(pictureHeight: 60, borderSize: 2, imageURL: user?.picture ?? ""),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(user!.fullName, style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: darkColor),),
                            )
                          ],
                        ),
                        Wrap(
                            spacing: 18,
                            children: [
                              Column(
                                children: [
                                  Text(userInfo!.publications.toString(),
                                      style: const TextStyle(color: gray04Color, fontSize: 20)),
                                  const Text("publicaciones", style: TextStyle(color: gray04Color, fontSize: 14))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(userInfo!.followers.toString(),
                                      style: const TextStyle(color: gray04Color, fontSize: 20)),
                                  const Text("seguidores", style: TextStyle(color: gray04Color, fontSize: 14))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(userInfo!.followed.toString(),
                                      style: const TextStyle(color: gray04Color, fontSize: 20)),
                                  const Text("seguidos", style: TextStyle(color: gray04Color, fontSize: 14))
                                ],
                              )
                            ]
                        )
                      ]
                  ),
                )
            :
                Container(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Button(
                text: "Editar Perfil",
                onPressed: () {},
                borderSide: null,
                backgroundColor: primaryColor,
                textColor: whiteColor,
                size: const Size.fromHeight(40),
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Button(
                text: "Salir sesion",
                onPressed: () async {
                  await Provider.of<UserProvider>(context, listen: false).logout();
                  Navigator.pushNamed(context, routes.welcome);
                },
                borderSide: const BorderSide(color: redColor),
                backgroundColor: redColor,
                textColor: whiteColor,
                size: const Size.fromHeight(40),
                fontSize: 20,
              ),
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
              children: List.generate(posts.length, (index) {
                if (posts[index].runtimeType == Moment) {
                  return Helper.createMomentWidget(posts[index]);
                }
                if (posts[index].runtimeType == Recipe) {
                  return Helper.createRecipeWidget(posts[index]);
                }
                return Container();
              }),
            )
          ]),
        ))
        : const SingleChildScrollView(
        child: SkeletonProfile(
          items: 2,
        ));
  }
}
