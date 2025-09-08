import 'package:equatable/equatable.dart';
import '../entities/recommendation_entity.dart';

abstract class AIRecommendationService {
  Future<List<RecommendationEntity>> getPersonalizedRecommendations(String userId);
  Future<List<RecommendationEntity>> getTrendingRecommendations(String userId);
  Future<List<RecommendationEntity>> getLocationBasedRecommendations(String userId, double latitude, double longitude);
  Future<List<RecommendationEntity>> getTimeBasedRecommendations(String userId);
  Future<List<RecommendationEntity>> getWeatherBasedRecommendations(String userId);
  Future<List<RecommendationEntity>> getSimilarUserRecommendations(String userId);
  Future<UserPreferenceEntity> analyzeUserPreferences(String userId);
  Future<void> updateUserPreferences(String userId, Map<String, dynamic> preferences);
  Future<SmartRecommendationEntity> getSmartRecommendations(String userId, Map<String, dynamic> context);
}

// AI Recommendation Engine Implementation
class AIRecommendationEngine implements AIRecommendationService {
  @override
  Future<List<RecommendationEntity>> getPersonalizedRecommendations(String userId) async {
    // Mock AI-powered personalized recommendations
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      RecommendationEntity(
        id: 'rec_1',
        userId: userId,
        restaurantId: 'restaurant_1',
        restaurantName: 'Pizza Palace',
        restaurantImageUrl: 'https://example.com/pizza.jpg',
        reason: 'You ordered pizza 3 times this month',
        confidence: 0.85,
        type: RecommendationType.basedOnHistory,
        metadata: {
          'orderCount': 3,
          'lastOrder': '2024-01-15',
          'averageRating': 4.5,
        },
        createdAt: DateTime.now(),
      ),
      RecommendationEntity(
        id: 'rec_2',
        userId: userId,
        restaurantId: 'restaurant_2',
        restaurantName: 'Sushi Master',
        restaurantImageUrl: 'https://example.com/sushi.jpg',
        reason: 'Similar to your favorite Japanese restaurants',
        confidence: 0.78,
        type: RecommendationType.basedOnSimilarUsers,
        metadata: {
          'similarityScore': 0.78,
          'userCount': 150,
          'averageRating': 4.7,
        },
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<RecommendationEntity>> getTrendingRecommendations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      RecommendationEntity(
        id: 'trend_1',
        userId: userId,
        restaurantId: 'restaurant_3',
        restaurantName: 'Burger King',
        restaurantImageUrl: 'https://example.com/burger.jpg',
        reason: 'Trending in your area with 200+ orders today',
        confidence: 0.92,
        type: RecommendationType.basedOnTrending,
        metadata: {
          'trendingScore': 0.92,
          'ordersToday': 200,
          'growthRate': 0.15,
        },
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<RecommendationEntity>> getLocationBasedRecommendations(String userId, double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return [
      RecommendationEntity(
        id: 'loc_1',
        userId: userId,
        restaurantId: 'restaurant_4',
        restaurantName: 'Nearby Cafe',
        restaurantImageUrl: 'https://example.com/cafe.jpg',
        reason: '0.5km away, 4.8 rating',
        confidence: 0.88,
        type: RecommendationType.basedOnLocation,
        metadata: {
          'distance': 0.5,
          'rating': 4.8,
          'deliveryTime': 15,
        },
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<RecommendationEntity>> getTimeBasedRecommendations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final hour = DateTime.now().hour;
    String reason;
    double confidence;
    
    if (hour >= 6 && hour < 11) {
      reason = 'Perfect breakfast spot';
      confidence = 0.85;
    } else if (hour >= 11 && hour < 15) {
      reason = 'Great lunch option';
      confidence = 0.90;
    } else if (hour >= 15 && hour < 18) {
      reason = 'Ideal for afternoon snack';
      confidence = 0.75;
    } else {
      reason = 'Perfect for dinner';
      confidence = 0.88;
    }
    
    return [
      RecommendationEntity(
        id: 'time_1',
        userId: userId,
        restaurantId: 'restaurant_5',
        restaurantName: 'Time-based Restaurant',
        reason: reason,
        confidence: confidence,
        type: RecommendationType.basedOnTime,
        metadata: {
          'currentHour': hour,
          'timeSlot': _getTimeSlot(hour),
        },
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<RecommendationEntity>> getWeatherBasedRecommendations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Mock weather data
    final weather = 'sunny'; // This would come from a weather API
    String reason;
    double confidence;
    
    switch (weather) {
      case 'sunny':
        reason = 'Perfect for outdoor dining';
        confidence = 0.80;
        break;
      case 'rainy':
        reason = 'Great for cozy indoor meals';
        confidence = 0.85;
        break;
      case 'cold':
        reason = 'Warm comfort food recommended';
        confidence = 0.90;
        break;
      default:
        reason = 'Weather-appropriate dining';
        confidence = 0.75;
    }
    
    return [
      RecommendationEntity(
        id: 'weather_1',
        userId: userId,
        restaurantId: 'restaurant_6',
        restaurantName: 'Weather Restaurant',
        reason: reason,
        confidence: confidence,
        type: RecommendationType.basedOnWeather,
        metadata: {
          'weather': weather,
          'temperature': 22,
        },
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<RecommendationEntity>> getSimilarUserRecommendations(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return [
      RecommendationEntity(
        id: 'similar_1',
        userId: userId,
        restaurantId: 'restaurant_7',
        restaurantName: 'Similar User Restaurant',
        reason: 'Users with similar taste also ordered from here',
        confidence: 0.82,
        type: RecommendationType.basedOnSimilarUsers,
        metadata: {
          'similarUserCount': 45,
          'similarityScore': 0.82,
          'commonPreferences': ['Italian', 'Vegetarian'],
        },
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<UserPreferenceEntity> analyzeUserPreferences(String userId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return UserPreferenceEntity(
      userId: userId,
      favoriteCuisines: ['Italian', 'Japanese', 'Mexican'],
      dietaryRestrictions: ['Vegetarian'],
      averageOrderValue: 25.50,
      preferredRestaurants: ['restaurant_1', 'restaurant_2'],
      cuisinePreferences: {
        'Italian': 0.8,
        'Japanese': 0.7,
        'Mexican': 0.6,
        'Chinese': 0.4,
        'Indian': 0.3,
      },
      timePreferences: {
        'breakfast': 0.2,
        'lunch': 0.4,
        'dinner': 0.8,
        'snack': 0.3,
      },
      pricePreferences: {
        'budget': 0.1,
        'moderate': 0.6,
        'premium': 0.3,
      },
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<void> updateUserPreferences(String userId, Map<String, dynamic> preferences) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Update user preferences in database
  }

  @override
  Future<SmartRecommendationEntity> getSmartRecommendations(String userId, Map<String, dynamic> context) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Combine multiple recommendation types
    final personalized = await getPersonalizedRecommendations(userId);
    final trending = await getTrendingRecommendations(userId);
    final timeBased = await getTimeBasedRecommendations(userId);
    
    final allRecommendations = [
      ...personalized,
      ...trending,
      ...timeBased,
    ];
    
    // Sort by confidence score
    allRecommendations.sort((a, b) => b.confidence.compareTo(a.confidence));
    
    return SmartRecommendationEntity(
      id: 'smart_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      recommendations: allRecommendations.take(10).toList(),
      context: context,
      generatedAt: DateTime.now(),
      validFor: const Duration(hours: 2),
    );
  }

  String _getTimeSlot(int hour) {
    if (hour >= 6 && hour < 11) return 'breakfast';
    if (hour >= 11 && hour < 15) return 'lunch';
    if (hour >= 15 && hour < 18) return 'afternoon';
    return 'dinner';
  }
}
