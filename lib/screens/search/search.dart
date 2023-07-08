import 'package:dartz/dartz.dart' as dartz;
import 'package:flavor_house/models/user/user_item.dart';
import 'package:flavor_house/screens/search/search_skeleton.dart';
import 'package:flavor_house/services/user_info/dummy_user_info_service.dart';
import 'package:flavor_house/services/user_info/user_info_service.dart';
import 'package:flavor_house/utils/text_themes.dart';
import 'package:flavor_house/widgets/listview_infinite_loader.dart';
import 'package:flavor_house/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/error/failures.dart';
import '../../models/post/moment.dart';
import '../../models/post/recipe.dart';
import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../../services/post/dummy_post_service.dart';
import '../../services/post/post_service.dart';
import '../../utils/colors.dart';
import '../../utils/helpers.dart';

enum SearchType { moment, recipe, user }

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  User user = User.initial();
  SearchType selectedSearch = SearchType.moment;
  List results = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isInitialResultLoading = false;
  bool _loadingMore = false;

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

  void getResults(Function(bool) setLoadingState, {bool reset = false}) async {
    if (user == null) return;
    String searchValue = _searchController.value.text;
    if (searchValue.isEmpty) return;
    if (mounted) {
      setLoadingState(true);
    }
    dartz.Either<Failure, List> result;
    switch (selectedSearch) {
      case SearchType.moment:
        PostService postClient = DummyPost();
        result = await postClient.getMoments(search: searchValue);
        break;
      case SearchType.recipe:
        PostService postClient = DummyPost();
        result = await postClient.getRecipes(search: searchValue);
        break;
      case SearchType.user:
        UserInfoService userInfoService = DummyUserInfoService();
        result = await userInfoService.userSearch(searchTerm: searchValue);
        break;
    }

    result.fold((failure) {
      if (mounted) {
        setLoadingState(false);
      }
    }, (newItems) {
      if (mounted) {
        setState(() {
          if(reset) results = [];
          results.addAll(newItems);
        });
        setLoadingState(false);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        user = Provider.of<UserProvider>(context, listen: false).user;
      });
    }
  }

  void onChangeSearch(SearchType type) {
    setState(() {
      results = [];
      _searchController.value = TextEditingValue.empty;
      selectedSearch = type;
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
                  hintText: "Buscar",
                  onSubmitted: (String value) {
                    getResults(setInitialResultLoadingState, reset: true);
                  },
                  prefixICon: const Icon(Icons.search, color: blackColor),
                  textInputType: TextInputType.text,
                  textEditingController: _searchController),
            ),
            _isInitialResultLoading
                ? SkeletonSearch(
                    items: 2,
                    type: selectedSearch,
                  )
                : Expanded(
              child: results.isNotEmpty ? ListViewInfiniteLoader(
                setLoadingModeState: setLoadingModeState,
                getMoreItems: getResults,
                loadingState: _loadingMore,
                children: List.generate(results.length, (index) {
                  if (results[index].runtimeType == Moment) {
                    return Helper.createMomentWidget(results[index], user.id);
                  }
                  if (results[index].runtimeType == Recipe) {
                    return Helper.createRecipeWidget(results[index], user.id);
                  }
                  if (results[index].runtimeType == UserItem) {
                    return Helper.createUserItemWidget(results[index]);
                  }
                  return Container();
                }),
              ) : Container()
            )
          ],
        ));
  }
}
