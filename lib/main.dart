import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/api/api_service.dart';
import 'package:restaurant_app_base/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app_base/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app_base/screen/detail/detail_screen.dart';
import 'package:restaurant_app_base/screen/main/main_screen.dart';
import 'package:restaurant_app_base/screen/setting/setting_screen.dart';
import 'package:restaurant_app_base/static/navigation_route.dart';
import 'package:restaurant_app_base/style/theme/restaurant_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => ApiServices(),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantListProvider(
            context.read<ApiServices>()
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailProvider(
            context.read<ApiServices>()
          ),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: TourismTheme.lightTheme,
      darkTheme: TourismTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: NavigationRoute.mainRoute.name,
      routes: {
        NavigationRoute.mainRoute.name: (context) => const MainScreen(),
        NavigationRoute.detailRoute.name: (context) => DetailScreen(
              restaurantId: ModalRoute.of(context)?.settings.arguments as String,
            ),
        NavigationRoute.settingRoute.name: (context) => const SettingScreen()
      },
    );
  }
}
