import 'package:hive/hive.dart';
import '../../../../shared/models/restaurant_model.dart';

abstract class RestaurantLocalDataSource {
  Future<List<RestaurantModel>> getCachedRestaurants();
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants);
  Future<RestaurantModel?> getCachedRestaurantById(String id);
  Future<void> cacheRestaurant(RestaurantModel restaurant);
  Future<List<String>> getCachedCategories();
  Future<void> cacheCategories(List<String> categories);
  Future<List<String>> getCachedCuisineTypes();
  Future<void> cacheCuisineTypes(List<String> cuisineTypes);
}

class RestaurantLocalDataSourceImpl implements RestaurantLocalDataSource {
  static const String RESTAURANTS_BOX = 'restaurants';
  static const String CATEGORIES_BOX = 'categories';
  static const String CUISINE_TYPES_BOX = 'cuisine_types';
  
  @override
  Future<List<RestaurantModel>> getCachedRestaurants() async {
    try {
      final box = await Hive.openBox<Map>(RESTAURANTS_BOX);
      final restaurantsData = box.values.toList();
      return restaurantsData
          .map((data) => RestaurantModel.fromJson(Map<String, dynamic>.from(data)))
          .toList();
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<void> cacheRestaurants(List<RestaurantModel> restaurants) async {
    try {
      final box = await Hive.openBox<Map>(RESTAURANTS_BOX);
      await box.clear();
      
      for (int i = 0; i < restaurants.length; i++) {
        await box.put(i, restaurants[i].toJson());
      }
    } catch (e) {
      // Handle error silently for caching
    }
  }
  
  @override
  Future<RestaurantModel?> getCachedRestaurantById(String id) async {
    try {
      final box = await Hive.openBox<Map>(RESTAURANTS_BOX);
      final restaurantsData = box.values.toList();
      
      for (final data in restaurantsData) {
        final restaurant = RestaurantModel.fromJson(Map<String, dynamic>.from(data));
        if (restaurant.id == id) {
          return restaurant;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<void> cacheRestaurant(RestaurantModel restaurant) async {
    try {
      final box = await Hive.openBox<Map>(RESTAURANTS_BOX);
      await box.put(restaurant.id, restaurant.toJson());
    } catch (e) {
      // Handle error silently for caching
    }
  }
  
  @override
  Future<List<String>> getCachedCategories() async {
    try {
      final box = await Hive.openBox<String>(CATEGORIES_BOX);
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<void> cacheCategories(List<String> categories) async {
    try {
      final box = await Hive.openBox<String>(CATEGORIES_BOX);
      await box.clear();
      
      for (int i = 0; i < categories.length; i++) {
        await box.put(i, categories[i]);
      }
    } catch (e) {
      // Handle error silently for caching
    }
  }
  
  @override
  Future<List<String>> getCachedCuisineTypes() async {
    try {
      final box = await Hive.openBox<String>(CUISINE_TYPES_BOX);
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<void> cacheCuisineTypes(List<String> cuisineTypes) async {
    try {
      final box = await Hive.openBox<String>(CUISINE_TYPES_BOX);
      await box.clear();
      
      for (int i = 0; i < cuisineTypes.length; i++) {
        await box.put(i, cuisineTypes[i]);
      }
    } catch (e) {
      // Handle error silently for caching
    }
  }
}
