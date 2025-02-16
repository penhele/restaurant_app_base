import 'package:flutter/material.dart';
import 'package:restaurant_app_base/data/model/restaurant_detail.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  final RestaurantDetail restaurant;

  const BodyOfDetailScreenWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag:
                  'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
              child: Image.network(
                'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox.square(dimension: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  restaurant.name,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox.square(
                      dimension: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          restaurant.city,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox.square(dimension: 16),
                        Text('|'),
                        const SizedBox.square(dimension: 16),
                        Text(
                          restaurant.address,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star_border_outlined),
                    SizedBox.square(
                      dimension: 8,
                    ),
                    Text(
                      restaurant.rating.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            ),
            const SizedBox.square(dimension: 16),
            Divider(),
            const SizedBox.square(dimension: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(color: Colors.amberAccent),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'Deskripsi',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 8),
              Text(
                restaurant.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ]),
            const SizedBox.square(dimension: 16),
            Divider(),
            const SizedBox.square(dimension: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                const SizedBox.square(dimension: 8),

                // membuat listview foods
                Text(
                  'Foods',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox.square(dimension: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurant.menus.foods.length,
                    itemBuilder: (context, index) {
                      final food = restaurant.menus.foods[index];
                      return Card(
                        color: Colors.lightGreenAccent,
                        shape: LinearBorder(),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            food.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox.square(dimension: 8),

                // membuat listview drinks
                Text(
                  'Drinks',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox.square(dimension: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: restaurant.menus.drinks.length,
                    itemBuilder: (context, index) {
                      final drink = restaurant.menus.drinks[index];
                      return Card(
                        color: Colors.lightGreenAccent,
                        shape: LinearBorder(),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            drink.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox.square(dimension: 16),
            Divider(),
            const SizedBox.square(dimension: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.amberAccent),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text(
                        'Ulasan',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox.square(dimension: 8),
                Row(
                  children: [
                    Text(
                      'Nama',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox.square(dimension: 16),
                    Text(
                      ':',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox.square(dimension: 8),
                    Text(
                      restaurant.customerReviews.isNotEmpty
                          ? restaurant.customerReviews[0].name
                          : 'No reviews available',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Ulasan',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox.square(dimension: 16),
                    Text(
                      ':',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox.square(dimension: 8),
                    Expanded(
                        child: Text(
                      restaurant.customerReviews.isNotEmpty
                          ? restaurant.customerReviews[0].review
                          : 'No reviews available',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Tanggal',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox.square(dimension: 16),
                    Text(
                      ':',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    SizedBox.square(dimension: 8),
                    Text(
                      restaurant.customerReviews.isNotEmpty
                          ? restaurant.customerReviews[0].date
                          : 'No reviews available',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
