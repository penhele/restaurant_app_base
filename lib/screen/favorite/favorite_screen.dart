import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/detail/favorite_list_provider.dart';
import 'package:restaurant_app_base/screen/favorite/favorite_card_widget.dart';
import 'package:restaurant_app_base/static/navigation_route.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Favorite List"),
        ),
        body: Consumer<FavoriteListProvider>(
          builder: (context, value, child) {
            final favoriteList = value.favoriteList;
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
