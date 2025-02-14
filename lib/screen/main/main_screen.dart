import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/main/index_nav_provider.dart';
import 'package:restaurant_app_base/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app_base/screen/home/home_screen.dart';
import 'package:restaurant_app_base/screen/setting/setting_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            1 => const FavoriteScreen(),
            2 => const SettingScreen(),
            _ => const HomeScreen()
          };
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
        onTap: (index) {
          context.read<IndexNavProvider>().setIndextBottomNavBar = index;
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
