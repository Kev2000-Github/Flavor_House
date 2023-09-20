import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/common/constants/routes.dart' as routes;
import 'package:flavor_house/models/user/user_publications_info.dart';
import 'package:flavor_house/screens/profile/skeleton_profile.dart';
import 'package:flavor_house/services/paginated.dart';
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/services/user_info/http_user_info_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/widgets/avatar.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../models/config/sort_config.dart';
import '../../models/post/moment.dart';
import '../../models/post/recipe.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';
import '../../utils/skeleton_wrapper.dart';
import '../../utils/text_themes.dart';
import '../../widgets/button.dart';
import '../../widgets/modal/sort.dart';
import '../../widgets/post_skeleton.dart';
import '../../widgets/sort.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = User.initial();
  UserPublicationsInfo? userInfo;
  Paginated posts = Paginated.initial();
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
    PostService postClient = HttpPost();
    dartz.Either<Failure, Paginated> result =
    await postClient.getAll(sort: selectedSort, isMine: true);
    result.fold((failure) {
      if (mounted) setLoadingState(false);
      CommonPopup.alert(context, failure);
    }, (newPosts) {
      if (mounted) {
        setState(() {
          if (reset) {
            posts = newPosts;
          } else {
            posts.addAll(newPosts.getData());
          }
        });
        setLoadingState(false);
      }
    });
  }

  void getUserInfo() async {
    if (user.isInitial()) return;
    UserInfoService userInfoService = HttpUserInfoService();
    dartz.Either<Failure, UserPublicationsInfo> result =
        await userInfoService.getInfo(user.id);
    result.fold((failure) => CommonPopup.alert(context, failure), (newUserPublicationsInfo) {
      if (mounted) {
        setState(() {
          userInfo = newUserPublicationsInfo;
        });
      }
    });
  }

  void getUser() async {
    UserInfoService userInfoService = HttpUserInfoService();
    dartz.Either<Failure, User> result =
    await userInfoService.getUser(widget.userId!);
    result.fold((failure) => null, (newUser) {
      if (mounted) {
        setState(() {
          user = newUser;
        });
        getPosts(setInitialPostLoadingState, reset: true);
        getUserInfo();
      }
    });
  }

  void onDeletePost(String postId, String type) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, bool> result = await postService.deletePost(postId, type);
    result.fold((l) => CommonPopup.alert(context, l), (r) {
      setState(() {
        posts.removeWhere((element) => element.id == postId);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        if(widget.userId == null){
          user = Provider.of<UserProvider>(context, listen: false).user;
          getPosts(setInitialPostLoadingState, reset: true);
          getUserInfo();
        }
        else{
          getUser();
        }
      });
    }
  }

  void onChange(val) {
    setState(() {
      selectedSort = val;
    });
    getPosts(setInitialPostLoadingState, reset: true);
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
                  user.username,
                  style: const TextStyle(
                      color: blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                leading: widget.userId != null ? IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: blackColor,
                    )) : Container(),
                )),
      body: Conditional(
        condition: !user.isInitial(),
        positive: Padding(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ListViewInfiniteLoader(
              canLoadMore: posts.page < posts.totalPages,
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
                                    image: user.picture),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    user.fullName,
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
                  child: widget.userId != null ? Button(
                    text: user.isFollowed != null && user.isFollowed == true ? "Dejar de seguir" : "Seguir",
                    onPressed: () async {
                      UserInfoService userInfoService = HttpUserInfoService();
                      dartz.Either<Failure,bool> result = await userInfoService.updateFollow(user.id, !user.isFollowed!);
                      result.fold((l) => CommonPopup.alert(context, l), (isFollow) {
                        setState(() {
                          user.isFollowed = isFollow;
                        });
                      });
                    },
                    borderSide: const BorderSide(style: BorderStyle.none),
                    backgroundColor: user?.isFollowed != null && user!.isFollowed == true ? redColor : primaryColor,
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
                  child: widget.userId != null ? Container() : Button(
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
                _isInitialPostLoading
                    ? const SkeletonWrapper(child: PostSkeleton(items: 2))
                    : Column(
                  children: List.generate(posts.items, (index) {
                    if (posts.getData()[index].runtimeType == Moment) {
                      return Helper.createMomentWidget(posts.getData()[index], user.id, onDeletePost);
                    }
                    if (posts.getData()[index].runtimeType == Recipe) {
                      return Helper.createRecipeWidget(posts.getData()[index], user.id, onDeletePost);
                    }
                    return Container();
                  }),
                )
              ],
            )),
        negative: const SingleChildScrollView(
            child: SkeletonProfile(
              items: 2,
            ))
      )
    );
  }
}
