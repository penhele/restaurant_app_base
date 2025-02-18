import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app_base/provider/setting/dark_theme_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/notification_state_provider.dart';
import 'package:restaurant_app_base/provider/setting/shared_preferences_provider.dart';
import 'package:restaurant_app_base/screen/home/home_error_state_widget.dart';
import 'package:restaurant_app_base/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app_base/static/navigation_route.dart';
import 'package:restaurant_app_base/static/restaurant_list_result_state.dart';
import 'package:restaurant_app_base/utils/dark_theme_state.dart';
import 'package:restaurant_app_base/utils/notification_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _fetchRestaurantList() {
    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchRestaurantList();

    final darkThemeStateProvider = context.read<DarkThemeStateProvider>();
    final notificationStateProvider = context.read<NotificationStateProvider>();
    final sharedPreferencesProvider = context.read<SharedPreferencesProvider>();

    Future.microtask(() {
      context.read<RestaurantListProvider>().fetchRestaurantList();

      sharedPreferencesProvider.getSettingValue();
      final setting = sharedPreferencesProvider.setting;

      if (setting != null) {
        darkThemeStateProvider.darkThemeState = setting.darkThemeEnable
            ? DarkThemeState.enable
            : DarkThemeState.disable;
        notificationStateProvider.notificationState = setting.notificationEnable
            ? NotificationState.enable
            : NotificationState.disable;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant List"),
        centerTitle: true,
      ),
      body: Consumer<RestaurantListProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantListLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantListLoadedState(data: var restaurantList) =>
              ListView.builder(
                itemCount: restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];

                  return RestaurantCard(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id,
                      );
                    },
                  );
                },
              ),
            RestaurantListErrorState(error: var message) => HomeErrorState(
                errorMessage: message, onRetry: _fetchRestaurantList),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
