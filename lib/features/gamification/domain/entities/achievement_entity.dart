import 'package:equatable/equatable.dart';

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final AchievementType type;
  final AchievementRarity rarity;
  final int pointsReward;
  final Map<String, dynamic> requirements;
  final List<String> tags;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final DateTime createdAt;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.type,
    required this.rarity,
    required this.pointsReward,
    required this.requirements,
    this.tags = const [],
    this.isUnlocked = false,
    this.unlockedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    iconUrl,
    type,
    rarity,
    pointsReward,
    requirements,
    tags,
    isUnlocked,
    unlockedAt,
    createdAt,
  ];
}

enum AchievementType {
  orderCount,
  orderValue,
  restaurantVisits,
  reviewCount,
  ratingCount,
  socialShares,
  consecutiveDays,
  streakCount,
  categoryExplorer,
  priceRangeExplorer,
  timeBased,
  seasonal,
  special,
}

enum AchievementRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

class UserAchievementEntity extends Equatable {
  final String id;
  final String userId;
  final String achievementId;
  final AchievementEntity achievement;
  final DateTime unlockedAt;
  final Map<String, dynamic> progress;
  final bool isNotified;

  const UserAchievementEntity({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.achievement,
    required this.unlockedAt,
    this.progress = const {},
    this.isNotified = false,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    achievementId,
    achievement,
    unlockedAt,
    progress,
    isNotified,
  ];
}

class LoyaltyPointsEntity extends Equatable {
  final String id;
  final String userId;
  final int totalPoints;
  final int availablePoints;
  final int usedPoints;
  final int pendingPoints;
  final DateTime lastUpdated;
  final List<LoyaltyTransactionEntity> recentTransactions;

  const LoyaltyPointsEntity({
    required this.id,
    required this.userId,
    required this.totalPoints,
    required this.availablePoints,
    required this.usedPoints,
    required this.pendingPoints,
    required this.lastUpdated,
    this.recentTransactions = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    totalPoints,
    availablePoints,
    usedPoints,
    pendingPoints,
    lastUpdated,
    recentTransactions,
  ];
}

class LoyaltyTransactionEntity extends Equatable {
  final String id;
  final String userId;
  final int points;
  final LoyaltyTransactionType type;
  final String description;
  final String? relatedId; // orderId, achievementId, etc.
  final DateTime createdAt;
  final DateTime? expiresAt;

  const LoyaltyTransactionEntity({
    required this.id,
    required this.userId,
    required this.points,
    required this.type,
    required this.description,
    this.relatedId,
    required this.createdAt,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    points,
    type,
    description,
    relatedId,
    createdAt,
    expiresAt,
  ];
}

enum LoyaltyTransactionType {
  earned,
  redeemed,
  expired,
  bonus,
  penalty,
  adjustment,
}

class RewardEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final int pointsCost;
  final RewardType type;
  final RewardStatus status;
  final Map<String, dynamic> value; // discount amount, free item, etc.
  final DateTime validFrom;
  final DateTime validUntil;
  final int? usageLimit;
  final int usedCount;
  final List<String> applicableRestaurants;
  final List<String> applicableCategories;

  const RewardEntity({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.pointsCost,
    required this.type,
    required this.status,
    required this.value,
    required this.validFrom,
    required this.validUntil,
    this.usageLimit,
    this.usedCount = 0,
    this.applicableRestaurants = const [],
    this.applicableCategories = const [],
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    pointsCost,
    type,
    status,
    value,
    validFrom,
    validUntil,
    usageLimit,
    usedCount,
    applicableRestaurants,
    applicableCategories,
  ];
}

enum RewardType {
  discount,
  freeItem,
  freeDelivery,
  prioritySupport,
  exclusiveAccess,
  cashback,
  bonusPoints,
}

enum RewardStatus {
  active,
  inactive,
  expired,
  redeemed,
}

class UserRewardEntity extends Equatable {
  final String id;
  final String userId;
  final String rewardId;
  final RewardEntity reward;
  final DateTime redeemedAt;
  final DateTime? usedAt;
  final String? orderId;
  final RewardStatus status;

  const UserRewardEntity({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.reward,
    required this.redeemedAt,
    this.usedAt,
    this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    rewardId,
    reward,
    redeemedAt,
    usedAt,
    orderId,
    status,
  ];
}

class StreakEntity extends Equatable {
  final String id;
  final String userId;
  final StreakType type;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final DateTime streakStartDate;
  final bool isActive;

  const StreakEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.currentStreak,
    required this.longestStreak,
    required this.lastActivityDate,
    required this.streakStartDate,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    currentStreak,
    longestStreak,
    lastActivityDate,
    streakStartDate,
    isActive,
  ];
}

enum StreakType {
  dailyOrders,
  weeklyOrders,
  monthlyOrders,
  consecutiveReviews,
  consecutiveRatings,
  consecutiveLogins,
}

class LeaderboardEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final int rank;
  final int points;
  final LeaderboardType type;
  final DateTime periodStart;
  final DateTime periodEnd;
  final Map<String, dynamic> stats;

  const LeaderboardEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.rank,
    required this.points,
    required this.type,
    required this.periodStart,
    required this.periodEnd,
    this.stats = const {},
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userAvatarUrl,
    rank,
    points,
    type,
    periodStart,
    periodEnd,
    stats,
  ];
}

enum LeaderboardType {
  weekly,
  monthly,
  yearly,
  allTime,
  category,
  restaurant,
}
