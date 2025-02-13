import 'package:flutter/material.dart';
import 'package:restaurant_app_base/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app_base/screen/home/home_screen.dart';
import 'package:restaurant_app_base/screen/setting/setting_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _indexBottomNavBar = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: switch (_indexBottomNavBar) {
        0 => const HomeScreen(),
        1 => const FavoriteScreen(),
        _ => const SettingScreen()
      },
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indexBottomNavBar,
        onTap: (index) {
          setState(() {
            _indexBottomNavBar = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'Home', tooltip: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
              tooltip: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              tooltip: 'Settings'),
        ],
      ),
    );
  }
}
