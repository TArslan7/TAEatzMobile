import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> searchAll({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  });

  Future<List<SearchResultModel>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  });

  Future<List<SearchResultModel>> searchMenuItems({
    required String query,
    String? restaurantId,
    int? limit,
  });

  Future<List<String>> getSearchSuggestions({
    required String query,
    int? limit,
  });

  Future<List<String>> getPopularSearches({
    int? limit,
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  SearchRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<List<SearchResultModel>> searchAll({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  }) async {
    try {
      // Mock implementation - in real app this would call the API
      await Future.delayed(const Duration(milliseconds: 500));

      final List<SearchResultModel> results = [];

      // Mock restaurant results
      final restaurantResults = await _getMockRestaurantResults(query, limit: (limit ?? 20) ~/ 2);
      results.addAll(restaurantResults);

      // Mock menu item results
      final menuItemResults = await _getMockMenuItemResults(query, limit: (limit ?? 20) ~/ 2);
      results.addAll(menuItemResults);

      return results;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SearchResultModel>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return await _getMockRestaurantResults(query, limit: limit);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<SearchResultModel>> searchMenuItems({
    required String query,
    String? restaurantId,
    int? limit,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      return await _getMockMenuItemResults(query, limit: limit);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getSearchSuggestions({
    required String query,
    int? limit,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      final suggestions = [
        'Pizza',
        'Burger',
        'Sushi',
        'Chinese food',
        'Italian',
        'Mexican',
        'Indian',
        'Thai',
        'Fast food',
        'Desserts',
        'Healthy food',
        'Vegetarian',
        'Vegan',
        'Halal',
        'Kosher',
        'Pasta',
        'Salad',
        'Sandwich',
        'Chicken',
        'Beef',
        'Seafood',
        'Rice',
        'Noodles',
        'Soup',
        'Coffee',
        'Tea',
        'Juice',
        'Smoothie',
        'Ice cream',
        'Cake',
      ];

      return suggestions
          .where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase()))
          .take(limit ?? 10)
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<String>> getPopularSearches({
    int? limit,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      
      return [
        'Pizza',
        'Burger',
        'Sushi',
        'Chinese',
        'Italian',
        'Mexican',
        'Indian',
        'Thai',
        'Fast food',
        'Desserts',
      ].take(limit ?? 10).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<SearchResultModel>> _getMockRestaurantResults(String query, {int? limit}) async {
    final mockRestaurants = [
      {
        'id': '1',
        'title': 'Mario\'s Pizza Palace',
        'subtitle': 'Italian • 4.5 ⭐ • 25-35 min',
        'imageUrl': 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
        'type': 'restaurant',
        'rating': 4.5,
        'price': '€€',
        'tags': ['Pizza', 'Italian', 'Family-friendly'],
        'metadata': {
          'deliveryTime': '25-35 min',
          'deliveryFee': '€2.99',
          'minimumOrder': '€15.00',
        }
      },
      {
        'id': '2',
        'title': 'Burger King',
        'subtitle': 'Fast Food • 4.2 ⭐ • 15-25 min',
        'imageUrl': 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
        'type': 'restaurant',
        'rating': 4.2,
        'price': '€',
        'tags': ['Burger', 'Fast Food', 'American'],
        'metadata': {
          'deliveryTime': '15-25 min',
          'deliveryFee': '€1.99',
          'minimumOrder': '€10.00',
        }
      },
      {
        'id': '3',
        'title': 'Sushi Master',
        'subtitle': 'Japanese • 4.8 ⭐ • 30-45 min',
        'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd1871?w=400',
        'type': 'restaurant',
        'rating': 4.8,
        'price': '€€€',
        'tags': ['Sushi', 'Japanese', 'Fresh'],
        'metadata': {
          'deliveryTime': '30-45 min',
          'deliveryFee': '€3.99',
          'minimumOrder': '€25.00',
        }
      },
    ];

    return mockRestaurants
        .where((restaurant) =>
            restaurant['title']!.toString().toLowerCase().contains(query.toLowerCase()) ||
            restaurant['tags']!.toString().toLowerCase().contains(query.toLowerCase()))
        .take(limit ?? 10)
        .map((restaurant) => SearchResultModel.fromJson(restaurant))
        .toList();
  }

  Future<List<SearchResultModel>> _getMockMenuItemResults(String query, {int? limit}) async {
    final mockMenuItems = [
      {
        'id': 'menu_1',
        'title': 'Margherita Pizza',
        'subtitle': 'Mario\'s Pizza Palace • €12.99',
        'imageUrl': 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400',
        'type': 'menu_item',
        'rating': 4.6,
        'price': '€12.99',
        'tags': ['Pizza', 'Italian', 'Vegetarian'],
        'metadata': {
          'restaurantId': '1',
          'restaurantName': 'Mario\'s Pizza Palace',
          'category': 'Pizza',
          'description': 'Classic tomato sauce, mozzarella, and fresh basil',
        }
      },
      {
        'id': 'menu_2',
        'title': 'Chicken Burger',
        'subtitle': 'Burger King • €8.99',
        'imageUrl': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        'type': 'menu_item',
        'rating': 4.3,
        'price': '€8.99',
        'tags': ['Burger', 'Chicken', 'Fast Food'],
        'metadata': {
          'restaurantId': '2',
          'restaurantName': 'Burger King',
          'category': 'Burgers',
          'description': 'Grilled chicken breast with lettuce, tomato, and mayo',
        }
      },
      {
        'id': 'menu_3',
        'title': 'California Roll',
        'subtitle': 'Sushi Master • €15.99',
        'imageUrl': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd1871?w=400',
        'type': 'menu_item',
        'rating': 4.7,
        'price': '€15.99',
        'tags': ['Sushi', 'Japanese', 'Seafood'],
        'metadata': {
          'restaurantId': '3',
          'restaurantName': 'Sushi Master',
          'category': 'Sushi',
          'description': 'Crab, avocado, and cucumber roll',
        }
      },
    ];

    return mockMenuItems
        .where((item) =>
            item['title']!.toString().toLowerCase().contains(query.toLowerCase()) ||
            item['tags']!.toString().toLowerCase().contains(query.toLowerCase()))
        .take(limit ?? 10)
        .map((item) => SearchResultModel.fromJson(item))
        .toList();
  }
}
