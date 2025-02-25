import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_base/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app_base/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app_base/screen/detail/body_of_detail_screen_widget.dart';
import 'package:restaurant_app_base/screen/detail/detail_error_state_widget.dart';
import 'package:restaurant_app_base/screen/detail/favorite_icon_widget.dart';
import 'package:restaurant_app_base/static/restaurant_detail_result_state.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({super.key, required this.restaurantId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  void _fetchRestaurantDetail() {
    Future.microtask(() {
      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  void initState() {
    super.initState();

    _fetchRestaurantDetail();

    Future.microtask(() {
      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Detail"),
        centerTitle: true,
        actions: [
          ChangeNotifierProvider(
            create: (context) => FavoriteIconProvider(),
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantDetailLoadedState(data: var restaurant) =>
                    FavoriteIconWidget(restaurant: restaurant),
                  _ => const SizedBox()
                };
              },
            ),
          ),
        ],
      ),
      body: Consumer<RestaurantDetailProvider>(
        builder: (context, value, child) {
          return switch (value.resultState) {
            RestaurantDetailLoadingState() => const Center(
                child: CircularProgressIndicator(),
              ),
            RestaurantDetailLoadedState(data: var restaurant) =>
              BodyOfDetailScreenWidget(restaurant: restaurant),
            RestaurantDetailErrorState(error: var message) => DetailErrorState(
                errorMessage: message, onRetry: _fetchRestaurantDetail),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }
}
