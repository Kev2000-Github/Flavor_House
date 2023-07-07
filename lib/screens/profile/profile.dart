import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/screens/profile/skeleton_profile.dart';
import 'package:flavor_house/services/user_info/dummy_user_info_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/widgets/avatar.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/post/recipe.dart';
import '../../models/sort/sort_config.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../utils/text_themes.dart';
import '../../widgets/button.dart';
import '../../widgets/post_skeleton.dart';
import '../../widgets/sort.dart';
import 'dart:developer';

class ProfileScreen extends StatefulWidget {
  final UserItem? user;
  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;
  UserPublicationsInfo? userInfo;
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

  void getUserInfo() async {
    if (user == null) return;
    UserInfoService userInfoService = DummyUserInfoService();
    dartz.Either<Failure, UserPublicationsInfo> result =
        await userInfoService.getInfo(user!.id);
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
        if(widget.user == null){
          user = Provider.of<UserProvider>(context, listen: false).user;
        }
        else{
          user = User.fromUserItem(widget.user as UserItem);
        }
      });
    }
    getPosts(setInitialPostLoadingState, reset: true);
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: AppBar(
                flexibleSpace: Container(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  user?.username ?? "",
                  style: const TextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                leading: widget.user != null ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: blackColor,
                    )) : null,
                )),
      body: user != null
          ? Padding(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: ListViewInfiniteLoader(
            loadingState: _loadingMore,
            getMoreItems: getPosts,
            setLoadingModeState: setLoadingModeState,
            children: [
              userInfo != null
                  ? Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Avatar(
                                  pictureHeight: 60,
                                  borderSize: 2,
                                  image: user?.picture),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  user!.fullName,
                                  textAlign: TextAlign.center,
                                  style: DesignTextTheme.get(
                                      type: TextThemeEnum.darkSemiMedium),
                                  overflow: TextOverflow.clip,
                                ),
                              )
                            ],
                          )
                      ),
                      Expanded(flex: 8, child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ Column(
                        children: [
                          Text(userInfo!.publications.toString(),
                              style: const TextStyle(
                                  color: gray04Color, fontSize: 20)),
                          const Text("publicaciones",
                              style: TextStyle(
                                  color: gray04Color, fontSize: 14))
                        ],
                      ),
                        Column(
                          children: [
                            Text(userInfo!.followers.toString(),
                                style: const TextStyle(
                                    color: gray04Color, fontSize: 20)),
                            const Text("seguidores",
                                style: TextStyle(
                                    color: gray04Color, fontSize: 14))
                          ],
                        ),
                        Column(
                          children: [
                            Text(userInfo!.followed.toString(),
                                style: const TextStyle(
                                    color: gray04Color, fontSize: 20)),
                            const Text("seguidos",
                                style: TextStyle(
                                    color: gray04Color, fontSize: 14))
                          ],
                        )]))
                    ]),
              )
                  : Container(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: widget.user != null ? Button(
                  text: widget.user!.isFollowed ? "Dejar de seguir" : "Seguir",
                  onPressed: () {},
                  borderSide: const BorderSide(style: BorderStyle.none),
                  backgroundColor: widget.user!.isFollowed ? redColor : primaryColor,
                  textColor: whiteColor,
                  size: const Size.fromHeight(40),
                  fontSize: 20,
                ) : Button(
                  text: "Editar Perfil",
                  onPressed: () {
                    Navigator.pushNamed(context, routes.edit_profile);
                  },
                  borderSide: null,
                  backgroundColor: primaryColor,
                  textColor: whiteColor,
                  size: const Size.fromHeight(40),
                  fontSize: 20,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                child: widget.user != null ? Container() : Button(
                  text: "Salir sesion",
                  onPressed: () async {
                    await Provider.of<UserProvider>(context, listen: false)
                        .logout();
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
                  getPosts(setLoadingModeState, reset: true);
                },
              ),
              _isInitialPostLoading
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
            ],
          ))
          : const SingleChildScrollView(
          child: SkeletonProfile(
            items: 2,
          ))
    );
  }
}
