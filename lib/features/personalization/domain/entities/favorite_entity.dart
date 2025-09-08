import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantImageUrl;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantImageUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    restaurantImageUrl,
    createdAt,
  ];
}

class RecommendationEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String? restaurantImageUrl;
  final String reason;
  final double score;
  final DateTime createdAt;

  const RecommendationEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    this.restaurantImageUrl,
    required this.reason,
    required this.score,
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
    score,
    createdAt,
  ];
}
