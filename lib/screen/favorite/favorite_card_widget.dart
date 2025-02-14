import 'package:flutter/material.dart';
import 'package:restaurant_app_base/data/model/restaurant_detail.dart';

class FavoriteCard extends StatelessWidget {
  final RestaurantDetail restaurant;
  final Function() onTap;

  const FavoriteCard({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox.square(dimension: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox.square(dimension: 6),
                  Row(
                    children: [
                      const Icon(Icons.pin_drop),
                      const SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          restaurant.city,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox.square(dimension: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                      ),
                      const SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
