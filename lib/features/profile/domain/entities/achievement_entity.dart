import 'package:equatable/equatable.dart';

enum AchievementType {
  orders,
  spending,
  reviews,
  streaks,
  referrals,
  badges,
}

enum AchievementStatus {
  locked,
  inProgress,
  unlocked,
  collected,
}

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final AchievementStatus status;
  final int currentProgress;
  final int targetProgress;
  final String rewardTitle;
  final String rewardDescription;
  final String icon;
  final int points;
  final DateTime? unlockedAt;
  final DateTime? collectedAt;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.currentProgress,
    required this.targetProgress,
    required this.rewardTitle,
    required this.rewardDescription,
    required this.icon,
    required this.points,
    this.unlockedAt,
    this.collectedAt,
  });

  double get progressPercentage {
    if (targetProgress == 0) return 0.0;
    return (currentProgress / targetProgress).clamp(0.0, 1.0);
  }

  int get remainingProgress {
    return (targetProgress - currentProgress).clamp(0, targetProgress);
  }

  bool get isUnlocked => status == AchievementStatus.unlocked;
  bool get isCollected => status == AchievementStatus.collected;
  bool get isInProgress => status == AchievementStatus.inProgress;
  bool get isLocked => status == AchievementStatus.locked;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        type,
        status,
        currentProgress,
        targetProgress,
        rewardTitle,
        rewardDescription,
        icon,
        points,
        unlockedAt,
        collectedAt,
      ];

  AchievementEntity copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    AchievementStatus? status,
    int? currentProgress,
    int? targetProgress,
    String? rewardTitle,
    String? rewardDescription,
    String? icon,
    int? points,
    DateTime? unlockedAt,
    DateTime? collectedAt,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      rewardTitle: rewardTitle ?? this.rewardTitle,
      rewardDescription: rewardDescription ?? this.rewardDescription,
      icon: icon ?? this.icon,
      points: points ?? this.points,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      collectedAt: collectedAt ?? this.collectedAt,
    );
  }
}

