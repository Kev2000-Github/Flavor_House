import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/screens/search/search_skeleton.dart';
import 'package:flavor_house/services/post/http_post_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/conditional.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/post_recipe.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../common/popups/common.dart';
import '../../models/post/moment.dart';
import '../../models/post/recipe.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/paginated.dart';
import '../../services/post/post_service.dart';
import '../../services/user_info/http_user_info_service.dart';
import '../../utils/colors.dart';
import '../../widgets/post_moment.dart';
import '../../widgets/user_item.dart';

enum SearchType { moment, recipe, user }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  User user = User.initial();
  SearchType selectedSearch = SearchType.moment;
  Paginated results = Paginated.initial();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchFilled = false;
  bool _isInitialResultLoading = false;
  bool _loadingMore = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _searchController.addListener(onChangeSearchTextField);
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
  }

  void setInitialResultLoadingState(bool state) {
    setState(() {
      _isInitialResultLoading = state;
    });
  }

  void setLoadingModeState(bool state) {
    setState(() {
      _loadingMore = state;
    });
  }

  String getSearchHint() {
    switch(selectedSearch){
      case SearchType.moment:
        return 'Buscar por hastag';
      case SearchType.recipe:
        return 'Buscar por etiquetas';
      case SearchType.user:
        return 'Buscar por nombre de usuario';
      default:
        return 'Buscar';
    }
  }

  void getResults(Function(bool) setLoadingState, {bool reset = false}) async {
    if (user.isInitial()) return;
    String searchValue = _searchController.value.text;
    if (searchValue.isEmpty) return;
    if (mounted) {
      setLoadingState(true);
    }
    dartz.Either<Failure, Paginated> result;
    switch (selectedSearch) {
      case SearchType.moment:
        PostService postClient = HttpPost();
        result = await postClient.getMoments(
            search: searchValue,
            page: results.isNotEmpty && !reset ? results.page + 1 : 1
        );
        break;
      case SearchType.recipe:
        PostService postClient = HttpPost();
        List<String> searchTags = searchValue.split(' ');
        result = await postClient.getRecipes(
            tags: searchTags,
            page: results.isNotEmpty && !reset ? results.page + 1 : 1
        );
        break;
      case SearchType.user:
        UserInfoService userInfoService = HttpUserInfoService();
        result = await userInfoService.userSearch(
            searchTerm: searchValue,
            exclude: [user.id]
        );
        break;
    }

    result.fold((failure) {
      CommonPopup.alert(context, failure);
      if (mounted) {
        setLoadingState(false);
      }
    }, (newItems) {
      if (mounted) {
        setState(() {
          if (reset) results = Paginated.initial();
          results.addAll(newItems.getData());
        });
        setLoadingState(false);
      }
    });
  }

  void onChangeSearchTextField() {
    setState(() {
      _isSearchFilled = _searchController.value.text != "";
    });
  }

  void onChangeSearch(SearchType type) {
    setState(() {
      results = Paginated.initial();
      _searchController.value = TextEditingValue.empty;
      selectedSearch = type;
    });
  }

  void onDeletePost(String postId, String type) async {
    PostService postService = HttpPost();
    dartz.Either<Failure, bool> result = await postService.deletePost(postId, type);
    result.fold((l) => CommonPopup.alert(context, l), (r) {
      setState(() {
        results.removeWhere((element) => element.id == postId);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 10),
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          onChangeSearch(SearchType.moment);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: selectedSearch == SearchType.moment
                                ? const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 3, color: darkColor)))
                                : null,
                            child: Text(
                              "Momentos",
                              style: DesignTextTheme.get(
                                  type: TextThemeEnum.darkMedium),
                            ))),
                    GestureDetector(
                        onTap: () {
                          onChangeSearch(SearchType.recipe);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: selectedSearch == SearchType.recipe
                              ? const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 3, color: darkColor)))
                              : null,
                          child: Text("Recetas",
                              style: DesignTextTheme.get(
                                  type: TextThemeEnum.darkMedium)),
                        )),
                    GestureDetector(
                        onTap: () {
                          onChangeSearch(SearchType.user);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 5),
                          decoration: selectedSearch == SearchType.user
                              ? const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 3, color: darkColor)))
                              : null,
                          child: Text("Usuarios",
                              style: DesignTextTheme.get(
                                  type: TextThemeEnum.darkMedium)),
                        ))
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextFieldInput(
                  hintText: getSearchHint(),
                  onSubmitted: (String value) {
                    getResults(setInitialResultLoadingState, reset: true);
                  },
                  prefixICon: const Icon(Icons.search, color: blackColor),
                  suffixIcon: _isSearchFilled ? IconButton(
                    icon: const Icon(Icons.close, color: blackColor),
                    onPressed: () {
                      setState(() {
                        _searchController.value = TextEditingValue.empty;
                      });
                    },
                  ): null,
                  textInputType: TextInputType.text,
                  textEditingController: _searchController),
            ),
            Conditional(
                condition: _isInitialResultLoading,
                positive: SkeletonSearch(
                  items: 2,
                  type: selectedSearch,
                ),
                negative: Expanded(
                    child: Conditional(
                        condition: results.isNotEmpty,
                        positive: ListViewInfiniteLoader(
                          canLoadMore: results.page < results.totalPages,
                          setLoadingModeState: setLoadingModeState,
                          getMoreItems: getResults,
                          loadingState: _loadingMore,
                          children: List.generate(results.items, (index) {
                            if (results.getData()[index].runtimeType == Moment) {
                              return PostMoment(
                                isSameUser: results.getItem(index).userId == user.id,
                                post: results.getData()[index],
                                deletePost: onDeletePost,
                              );
                            }
                            if (results.getData()[index].runtimeType == Recipe) {
                              return PostRecipe(
                                isSameUser: results.getItem(index).userId == user.id,
                                post: results.getItem(index),
                                deletePost: onDeletePost,
                              );
                            }
                            if (results.getData()[index].runtimeType == UserItem) {
                              return UserItemWidget(
                                user: results.getItem(index),
                              );
                            }
                            return Container();
                          }),
                        )))),
          ],
        ));
  }
}
