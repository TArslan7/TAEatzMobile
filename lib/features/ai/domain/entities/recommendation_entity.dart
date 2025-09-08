import 'package:equatable/equatable.dart';

class RecommendationEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantImageUrl;
  final String reason;
  final double confidence;
  final RecommendationType type;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;

  const RecommendationEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantImageUrl,
    required this.reason,
    required this.confidence,
    required this.type,
    this.metadata,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    restaurantImageUrl,
    reason,
    confidence,
    type,
    metadata,
    createdAt,
  ];
}

enum RecommendationType {
  basedOnHistory,
  basedOnLocation,
  basedOnTime,
  basedOnWeather,
  basedOnTrending,
  basedOnSimilarUsers,
  basedOnDietaryPreferences,
  basedOnPriceRange,
  basedOnRating,
  basedOnNewRestaurants,
}

extension RecommendationTypeExtension on RecommendationType {
  String get displayName {
    switch (this) {
      case RecommendationType.basedOnHistory:
        return 'Based on your order history';
      case RecommendationType.basedOnLocation:
        return 'Near your location';
      case RecommendationType.basedOnTime:
        return 'Perfect for this time';
      case RecommendationType.basedOnWeather:
        return 'Great for this weather';
      case RecommendationType.basedOnTrending:
        return 'Trending in your area';
      case RecommendationType.basedOnSimilarUsers:
        return 'Users like you also ordered';
      case RecommendationType.basedOnDietaryPreferences:
        return 'Matches your dietary preferences';
      case RecommendationType.basedOnPriceRange:
        return 'Within your budget';
      case RecommendationType.basedOnRating:
        return 'Highly rated';
      case RecommendationType.basedOnNewRestaurants:
        return 'New restaurant';
    }
  }

  String get icon {
    switch (this) {
      case RecommendationType.basedOnHistory:
        return '📋';
      case RecommendationType.basedOnLocation:
        return '📍';
      case RecommendationType.basedOnTime:
        return '🕐';
      case RecommendationType.basedOnWeather:
        return '🌤️';
      case RecommendationType.basedOnTrending:
        return '🔥';
      case RecommendationType.basedOnSimilarUsers:
        return '👥';
      case RecommendationType.basedOnDietaryPreferences:
        return '🥗';
      case RecommendationType.basedOnPriceRange:
        return '💰';
      case RecommendationType.basedOnRating:
        return '⭐';
      case RecommendationType.basedOnNewRestaurants:
        return '🆕';
    }
  }
}

class UserPreferenceEntity extends Equatable {
  final String userId;
  final List<String> favoriteCuisines;
  final List<String> dietaryRestrictions;
  final double averageOrderValue;
  final List<String> preferredRestaurants;
  final Map<String, double> cuisinePreferences;
  final Map<String, double> timePreferences;
  final Map<String, double> pricePreferences;
  final DateTime lastUpdated;

  const UserPreferenceEntity({
    required this.userId,
    required this.favoriteCuisines,
    required this.dietaryRestrictions,
    required this.averageOrderValue,
    required this.preferredRestaurants,
    required this.cuisinePreferences,
    required this.timePreferences,
    required this.pricePreferences,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    userId,
    favoriteCuisines,
    dietaryRestrictions,
    averageOrderValue,
    preferredRestaurants,
    cuisinePreferences,
    timePreferences,
    pricePreferences,
    lastUpdated,
  ];
}

class SmartRecommendationEntity extends Equatable {
  final String id;
  final String userId;
  final List<RecommendationEntity> recommendations;
  final Map<String, dynamic> context;
  final DateTime generatedAt;
  final Duration validFor;

  const SmartRecommendationEntity({
    required this.id,
    required this.userId,
    required this.recommendations,
    required this.context,
    required this.generatedAt,
    required this.validFor,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    recommendations,
    context,
    generatedAt,
    validFor,
  ];
}
