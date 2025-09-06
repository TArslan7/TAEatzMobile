import '../../../../core/errors/exceptions.dart';
import '../../../../shared/models/restaurant_model.dart';

abstract class RestaurantRemoteDataSource {
  Future<List<RestaurantModel>> getRestaurants({
    double? latitude,
    double? longitude,
    double? radius,
    String? category,
    String? searchQuery,
    int? page,
    int? limit,
  });
  
  Future<RestaurantModel> getRestaurantById(String id);
  
  Future<List<RestaurantModel>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
  });
  
  Future<List<String>> getRestaurantCategories();
  
  Future<List<String>> getCuisineTypes();
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  // Temporarily removed ApiClient dependency for testing
  
  RestaurantRemoteDataSourceImpl();
  
  @override
  Future<List<RestaurantModel>> getRestaurants({
    double? latitude,
    double? longitude,
    double? radius,
    String? category,
    String? searchQuery,
    int? page,
    int? limit,
  }) async {
    try {
      // Mock data for now - in real app this would come from API
      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
      
      return [
        RestaurantModel(
          id: '1',
          name: 'Pizza Palace',
          description: 'Authentic Italian pizza with fresh ingredients',
          imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
          imageUrls: ['https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400'],
          address: '123 Main Street',
          city: 'Amsterdam',
          postalCode: '1012 AB',
          country: 'Netherlands',
          latitude: 52.3676,
          longitude: 4.9041,
          phoneNumber: '+31 20 123 4567',
          email: 'info@pizzapalace.nl',
          website: 'https://pizzapalace.nl',
          categories: ['Pizza', 'Italian'],
          cuisineTypes: ['European'],
          rating: 4.5,
          reviewCount: 128,
          deliveryFee: 2.99,
          deliveryTimeMin: 25,
          deliveryTimeMax: 35,
          minimumOrderAmount: 15.00,
          isOpen: true,
          isDeliveryAvailable: true,
          isPickupAvailable: true,
          openingHours: [],
          acceptedPaymentMethods: [
            PaymentMethodModel(id: '1', name: 'card', type: 'credit_card', isEnabled: true),
            PaymentMethodModel(id: '2', name: 'cash', type: 'cash', isEnabled: true),
          ],
          deliveryAreas: [
            DeliveryAreaModel(
              id: '1',
              name: 'Amsterdam Center',
              deliveryFee: 2.99,
              deliveryTimeMin: 25,
              deliveryTimeMax: 35,
              minimumOrderAmount: 15.00,
              polygon: [],
            ),
          ],
          settings: RestaurantSettingsModel(
            allowPreOrders: true,
            allowScheduledOrders: true,
            maxAdvanceOrderDays: 7,
            requirePhoneVerification: false,
            allowGuestOrders: true,
            enableReviews: true,
            enableRatings: true,
            enableLoyaltyProgram: false,
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        ),
        RestaurantModel(
          id: '2',
          name: 'Sushi Master',
          description: 'Fresh sushi and Japanese cuisine',
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400',
          imageUrls: ['https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400'],
          address: '456 Canal Street',
          city: 'Amsterdam',
          postalCode: '1013 AB',
          country: 'Netherlands',
          latitude: 52.3676,
          longitude: 4.9041,
          phoneNumber: '+31 20 234 5678',
          email: 'info@sushimaster.nl',
          website: 'https://sushimaster.nl',
          categories: ['Sushi', 'Japanese'],
          cuisineTypes: ['Asian'],
          rating: 4.8,
          reviewCount: 89,
          deliveryFee: 3.50,
          deliveryTimeMin: 30,
          deliveryTimeMax: 45,
          minimumOrderAmount: 20.00,
          isOpen: true,
          isDeliveryAvailable: true,
          isPickupAvailable: true,
          openingHours: [],
          acceptedPaymentMethods: [
            PaymentMethodModel(id: '1', name: 'card', type: 'credit_card', isEnabled: true),
            PaymentMethodModel(id: '2', name: 'cash', type: 'cash', isEnabled: true),
          ],
          deliveryAreas: [
            DeliveryAreaModel(
              id: '1',
              name: 'Amsterdam Center',
              deliveryFee: 2.99,
              deliveryTimeMin: 25,
              deliveryTimeMax: 35,
              minimumOrderAmount: 15.00,
              polygon: [],
            ),
          ],
          settings: RestaurantSettingsModel(
            allowPreOrders: true,
            allowScheduledOrders: true,
            maxAdvanceOrderDays: 7,
            requirePhoneVerification: false,
            allowGuestOrders: true,
            enableReviews: true,
            enableRatings: true,
            enableLoyaltyProgram: false,
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now(),
        ),
        RestaurantModel(
          id: '3',
          name: 'Burger King',
          description: 'Flame-grilled burgers and crispy fries',
          imageUrl: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400',
          imageUrls: ['https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400'],
          address: '789 Market Square',
          city: 'Amsterdam',
          postalCode: '1014 AB',
          country: 'Netherlands',
          latitude: 52.3676,
          longitude: 4.9041,
          phoneNumber: '+31 20 345 6789',
          email: 'info@burgerking.nl',
          website: 'https://burgerking.nl',
          categories: ['Burgers', 'Fast Food'],
          cuisineTypes: ['American'],
          rating: 4.2,
          reviewCount: 256,
          deliveryFee: 1.99,
          deliveryTimeMin: 20,
          deliveryTimeMax: 30,
          minimumOrderAmount: 10.00,
          isOpen: true,
          isDeliveryAvailable: true,
          isPickupAvailable: true,
          openingHours: [],
          acceptedPaymentMethods: [
            PaymentMethodModel(id: '1', name: 'card', type: 'credit_card', isEnabled: true),
            PaymentMethodModel(id: '2', name: 'cash', type: 'cash', isEnabled: true),
          ],
          deliveryAreas: [
            DeliveryAreaModel(
              id: '1',
              name: 'Amsterdam Center',
              deliveryFee: 2.99,
              deliveryTimeMin: 25,
              deliveryTimeMax: 35,
              minimumOrderAmount: 15.00,
              polygon: [],
            ),
          ],
          settings: RestaurantSettingsModel(
            allowPreOrders: true,
            allowScheduledOrders: true,
            maxAdvanceOrderDays: 7,
            requirePhoneVerification: false,
            allowGuestOrders: true,
            enableReviews: true,
            enableRatings: true,
            enableLoyaltyProgram: false,
          ),
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          updatedAt: DateTime.now(),
        ),
      ];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      // Mock data for now - in real app this would come from API
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return the first restaurant as mock data
      return RestaurantModel(
        id: id,
        name: 'Pizza Palace',
        description: 'Authentic Italian pizza with fresh ingredients',
        imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
        imageUrls: ['https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400'],
        address: '123 Main Street',
        city: 'Amsterdam',
        postalCode: '1012 AB',
        country: 'Netherlands',
        latitude: 52.3676,
        longitude: 4.9041,
        phoneNumber: '+31 20 123 4567',
        email: 'info@pizzapalace.nl',
        website: 'https://pizzapalace.nl',
        categories: ['Pizza', 'Italian'],
        cuisineTypes: ['European'],
        rating: 4.5,
        reviewCount: 128,
        deliveryFee: 2.99,
        deliveryTimeMin: 25,
        deliveryTimeMax: 35,
        minimumOrderAmount: 15.00,
        isOpen: true,
        isDeliveryAvailable: true,
        isPickupAvailable: true,
        openingHours: [],
        acceptedPaymentMethods: [
          PaymentMethodModel(id: '1', name: 'card', type: 'credit_card', isEnabled: true),
          PaymentMethodModel(id: '2', name: 'cash', type: 'cash', isEnabled: true),
        ],
        deliveryAreas: [
          DeliveryAreaModel(
            id: '1',
            name: 'Amsterdam Center',
            deliveryFee: 2.99,
            deliveryTimeMin: 25,
            deliveryTimeMax: 35,
            minimumOrderAmount: 15.00,
            polygon: [],
          ),
        ],
        settings: RestaurantSettingsModel(
          allowPreOrders: true,
          allowScheduledOrders: true,
          maxAdvanceOrderDays: 7,
          requirePhoneVerification: false,
          allowGuestOrders: true,
          enableReviews: true,
          enableRatings: true,
          enableLoyaltyProgram: false,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<RestaurantModel>> searchRestaurants({
    required String query,
    double? latitude,
    double? longitude,
    double? radius,
  }) async {
    try {
      // Mock data for now - in real app this would come from API
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Filter mock restaurants based on query
      final allRestaurants = await getRestaurants(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      );
      
      return allRestaurants.where((restaurant) =>
        restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
        restaurant.description.toLowerCase().contains(query.toLowerCase()) ||
        restaurant.categories.any((category) => 
          category.toLowerCase().contains(query.toLowerCase())
        )
      ).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<String>> getRestaurantCategories() async {
    try {
      // Mock data for now - in real app this would come from API
      return [
        'Pizza',
        'Burgers',
        'Sushi',
        'Chinese',
        'Italian',
        'Mexican',
        'Indian',
        'Thai',
        'Fast Food',
        'Desserts',
        'Healthy',
        'Vegetarian',
        'Vegan',
        'Halal',
        'Kosher',
      ];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  
  @override
  Future<List<String>> getCuisineTypes() async {
    try {
      // Mock data for now - in real app this would come from API
      return [
        'European',
        'Asian',
        'American',
        'Middle Eastern',
        'African',
        'Latin American',
        'Mediterranean',
      ];
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
