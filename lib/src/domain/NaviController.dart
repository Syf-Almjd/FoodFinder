import 'package:flutter/material.dart';
import 'package:foodfinder/src/config/utils/styles/app_colors.dart';
import 'package:foodfinder/src/presentation/Modules/Favourite/FavouritesPage.dart';

import '../presentation/Modules/Home/home.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(
      isWeb: false,
    ),
    const FavouritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        unselectedItemColor: AppColors.black,
        selectedItemColor: AppColors.primaryColor,
        enableFeedback: true,
        backgroundColor: Colors.transparent,
        iconSize: 22,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outlined),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) async {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
