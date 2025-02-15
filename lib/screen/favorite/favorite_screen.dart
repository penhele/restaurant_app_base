import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app_base/screen/favorite/favorite_card_widget.dart';
import 'package:restaurant_app_base/static/navigation_route.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<LocalDatabaseProvider>().loadAllRestaurantValue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favorite List"),
        ),
        body: Consumer<LocalDatabaseProvider>(
          builder: (context, value, child) {
            final favoriteList = value.restaurantList;
            return switch (favoriteList.isNotEmpty) {
              true => ListView.builder(
                  itemCount: favoriteList.length,
                  itemBuilder: (context, index) {
                    final restaurant = favoriteList[index];

                    return FavoriteCard(
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
              _ => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No Favorited"),
                    ],
                  ),
                ),
            };
          },
        ));
  }
}
