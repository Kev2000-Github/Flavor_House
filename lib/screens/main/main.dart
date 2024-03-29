import 'package:flavor_house/screens/favorite/favorite.dart';
import 'package:flavor_house/screens/home/home.dart';
import 'package:flavor_house/screens/profile/profile.dart';
import 'package:flavor_house/screens/recipes/recipe.dart';
import 'package:flavor_house/screens/search/search.dart';
import 'package:flavor_house/utils/colors.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: _pageController,
        children: const [
          HomeScreen(),
          RecipeScreen(),
          SearchScreen(),
          FavoriteScreen(),
          ProfileScreen()
        ],
        onPageChanged: (newPage) {
          setState(() {
            _page = newPage;
          });
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: _page,
        onTap: (index) {
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn);
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Inicio",
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              label: "Recetas",
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Buscar",
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              label: "Favoritos",
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Perfil",
              backgroundColor: primaryColor),
        ],
      ),
    );
  }
}
