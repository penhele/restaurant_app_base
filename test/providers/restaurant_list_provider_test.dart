import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app_base/data/api/api_service.dart';
import 'package:restaurant_app_base/data/model/restaurant.dart';
import 'package:restaurant_app_base/data/model/restaurant_list_response.dart';
import 'package:restaurant_app_base/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app_base/static/restaurant_list_result_state.dart';

class MockApiServices extends Mock implements ApiServices {}

void main() {
  late MockApiServices apiServices;
  late RestaurantListProvider restaurantListProvider;

  setUp(() {
    apiServices = MockApiServices();
    restaurantListProvider = RestaurantListProvider(apiServices);
  });

  group('Testing RestaurantListProvider', () {
    test('Default state should be RestaurantListNoneState', () {
      expect(
          restaurantListProvider.resultState, isA<RestaurantListNoneState>());
    });

    test('Should successfully fetch restaurant list from API', () async {
      final testResponse = RestaurantListResponse(
        error: false,
        message: "Data fetched successfully",
        count: 10,
        restaurants: [
          Restaurant(
            id: "uewq1zg2zlskfw1e867",
            name: "Kafein",
            description: "Quisque rutrum. Aenean imperdiet...",
            pictureId: "15",
            city: "Aceh",
            rating: 4.6,
          ),
          Restaurant(
            id: "dwg2wt3is19kfw1e867",
            name: "Drinky Squash",
            description: "Lorem ipsum dolor sit amet...",
            pictureId: "18",
            city: "Surabaya",
            rating: 3.9,
          ),
        ],
      );

      when(() => apiServices.getRestaurantList()).thenAnswer(
        (_) async => testResponse,
      );

      await restaurantListProvider.fetchRestaurantList();

      expect(
          restaurantListProvider.resultState, isA<RestaurantListLoadedState>());
      final loadedState =
          restaurantListProvider.resultState as RestaurantListLoadedState;

      expect(loadedState.data.length, 2);
      expect(loadedState.data[0].name, "Kafein");
    });

    test('Should return error state when API request fails', () async {
      when(() => apiServices.getRestaurantList())
          .thenThrow(Exception("Failed to retrieve data"));

      await restaurantListProvider.fetchRestaurantList();

      expect(
          restaurantListProvider.resultState, isA<RestaurantListErrorState>());
      final errorState =
          restaurantListProvider.resultState as RestaurantListErrorState;

      expect(errorState.error, contains("Failed to retrieve data"));
    });
  });
}
