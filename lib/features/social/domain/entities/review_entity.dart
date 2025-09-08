import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String restaurantId;
  final String restaurantName;
  final double rating;
  final String comment;
  final List<String> imageUrls;
  final List<String> tags;
  final int helpfulCount;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final ReviewStatus status;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.restaurantId,
    required this.restaurantName,
    required this.rating,
    required this.comment,
    this.imageUrls = const [],
    this.tags = const [],
    this.helpfulCount = 0,
    this.isVerified = false,
    required this.createdAt,
    this.updatedAt,
    this.status = ReviewStatus.published,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userAvatarUrl,
    restaurantId,
    restaurantName,
    rating,
    comment,
    imageUrls,
    tags,
    helpfulCount,
    isVerified,
    createdAt,
    updatedAt,
    status,
  ];
}

enum ReviewStatus {
  pending,
  published,
  hidden,
  reported,
}

class RatingEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final double rating;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const RatingEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.rating,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    rating,
    createdAt,
    updatedAt,
  ];
}

class SocialStatsEntity extends Equatable {
  final String restaurantId;
  final double averageRating;
  final int totalReviews;
  final int totalRatings;
  final Map<int, int> ratingDistribution; // rating -> count
  final List<String> topTags;
  final int helpfulReviewsCount;
  final double responseRate;
  final DateTime lastUpdated;

  const SocialStatsEntity({
    required this.restaurantId,
    required this.averageRating,
    required this.totalReviews,
    required this.totalRatings,
    required this.ratingDistribution,
    required this.topTags,
    required this.helpfulReviewsCount,
    required this.responseRate,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    restaurantId,
    averageRating,
    totalReviews,
    totalRatings,
    ratingDistribution,
    topTags,
    helpfulReviewsCount,
    responseRate,
    lastUpdated,
  ];
}

class ShareEntity extends Equatable {
  final String id;
  final String type; // 'restaurant', 'dish', 'review', 'order'
  final String contentId;
  final String contentTitle;
  final String? contentDescription;
  final String? contentImageUrl;
  final String sharedBy;
  final DateTime sharedAt;
  final int shareCount;
  final List<String> platforms; // 'whatsapp', 'facebook', 'twitter', 'instagram'

  const ShareEntity({
    required this.id,
    required this.type,
    required this.contentId,
    required this.contentTitle,
    this.contentDescription,
    this.contentImageUrl,
    required this.sharedBy,
    required this.sharedAt,
    this.shareCount = 0,
    this.platforms = const [],
  });

  @override
  List<Object?> get props => [
    id,
    type,
    contentId,
    contentTitle,
    contentDescription,
    contentImageUrl,
    sharedBy,
    sharedAt,
    shareCount,
    platforms,
  ];
}

class SocialConnectionEntity extends Equatable {
  final String id;
  final String userId;
  final String connectedUserId;
  final String connectedUserName;
  final String? connectedUserAvatarUrl;
  final SocialConnectionType type;
  final DateTime connectedAt;
  final bool isActive;

  const SocialConnectionEntity({
    required this.id,
    required this.userId,
    required this.connectedUserId,
    required this.connectedUserName,
    this.connectedUserAvatarUrl,
    required this.type,
    required this.connectedAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    connectedUserId,
    connectedUserName,
    connectedUserAvatarUrl,
    type,
    connectedAt,
    isActive,
  ];
}

enum SocialConnectionType {
  friend,
  follower,
  following,
  blocked,
}

class SocialActivityEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final SocialActivityType type;
  final String contentId;
  final String contentTitle;
  final String? contentDescription;
  final String? contentImageUrl;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;

  const SocialActivityEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.type,
    required this.contentId,
    required this.contentTitle,
    this.contentDescription,
    this.contentImageUrl,
    this.metadata = const {},
    required this.createdAt,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userAvatarUrl,
    type,
    contentId,
    contentTitle,
    contentDescription,
    contentImageUrl,
    metadata,
    createdAt,
    likesCount,
    commentsCount,
    sharesCount,
  ];
}

enum SocialActivityType {
  reviewPosted,
  ratingGiven,
  orderPlaced,
  restaurantFavorited,
  dishLiked,
  reviewLiked,
  reviewShared,
  friendJoined,
  achievementUnlocked,
}
