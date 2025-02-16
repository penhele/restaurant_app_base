import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/data/model/restaurant_detail.dart';
import 'package:restaurant_app_base/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app_base/provider/favorite/local_database_provider.dart';

class FavoriteIconWidget extends StatefulWidget {
  final RestaurantDetail restaurant;

  const FavoriteIconWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  void initState() {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final favoriteIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() async {
      await localDatabaseProvider.loadRestaurantValueById(widget.restaurant.id);
      final restaurantInList =
          localDatabaseProvider.checkItemFavorite(widget.restaurant.id);
      favoriteIconProvider.isFavorited = restaurantInList;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final favoriteIconProvider = context.read<FavoriteIconProvider>();
        final isFavorited = favoriteIconProvider.isFavorited;

        if (!isFavorited) {
          await localDatabaseProvider.saveRestaurantValue(widget.restaurant);
        } else {
          await localDatabaseProvider
              .removeRestaurantValueById(widget.restaurant.id);
        }

        favoriteIconProvider.isFavorited = !isFavorited;
        localDatabaseProvider.loadAllRestaurantValue();
      },
      icon: Icon(
        context.watch<FavoriteIconProvider>().isFavorited
            ? Icons.favorite
            : Icons.favorite_outline,
        color: Colors.red,
      ),
    );
  }
}
