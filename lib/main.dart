import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/api/api_service.dart';
import 'package:restaurant_app_base/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app_base/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app_base/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app_base/provider/main/index_nav_provider.dart';
import 'package:restaurant_app_base/provider/setting/dark_theme_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app_base/screen/detail/detail_screen.dart';
import 'package:restaurant_app_base/screen/main/main_screen.dart';
import 'package:restaurant_app_base/screen/setting/setting_screen.dart';
import 'package:restaurant_app_base/services/local_notification_service.dart';
import 'package:restaurant_app_base/services/shared_preferences_service.dart';
import 'package:restaurant_app_base/services/sqlite_service.dart';
import 'package:restaurant_app_base/static/navigation_route.dart';
import 'package:restaurant_app_base/style/theme/restaurant_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        // navigasi
        ChangeNotifierProvider(
          create: (context) => IndexNavProvider(),
        ),

        Provider(
          create: (context) => ApiServices(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantListProvider(context.read<ApiServices>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RestaurantDetailProvider(context.read<ApiServices>()),
        ),

        ChangeNotifierProvider(
          create: (context) => DarkThemeStateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => NotificationStateProvider(),
        ),

        Provider(
          create: (context) => SharedPreferencesService(prefs),
        ),
        ChangeNotifierProvider(
          create: (context) => SharedPreferencesProvider(
              context.read<SharedPreferencesService>()),
        ),

        // sqlite
        Provider(
          create: (context) => SqliteService(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              LocalDatabaseProvider(context.read<SqliteService>()),
        ),

        // notifikasi
        Provider(
          create: (context) => LocalNotificationService()
            ..init()
            ..configureLocalTimeZone(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalNotificationProvider(
            context.read<LocalNotificationService>(),
          )..requestPermissions(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeStateProvider>(
      builder: (_, value, __) {
        return MaterialApp(
          title: 'Restaurant App',
          theme: RestaurantTheme.lightTheme,
          darkTheme: RestaurantTheme.darkTheme,
          themeMode:
              value.darkThemeState.isEnable ? ThemeMode.light : ThemeMode.dark,
          initialRoute: NavigationRoute.mainRoute.name,
          routes: {
            NavigationRoute.mainRoute.name: (context) => const MainScreen(),
            NavigationRoute.detailRoute.name: (context) => DetailScreen(
                  restaurantId:
                      ModalRoute.of(context)?.settings.arguments as String,
                ),
            NavigationRoute.settingRoute.name: (context) =>
                const SettingScreen()
          },
        );
      },
    );
  }
}
