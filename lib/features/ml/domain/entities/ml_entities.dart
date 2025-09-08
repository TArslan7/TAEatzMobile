import 'package:equatable/equatable.dart';

// User Preference Entity
class UserPreferenceEntity extends Equatable {
  final String id;
  final String userId;
  final String category;
  final String value;
  final double weight;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserPreferenceEntity({
    required this.id,
    required this.userId,
    required this.category,
    required this.value,
    required this.weight,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [id, userId, category, value, weight, createdAt, updatedAt];
}

// ML Recommendation Entity
class MLRecommendationEntity extends Equatable {
  final String id;
  final String userId;
  final String type; // 'restaurant', 'menu_item', 'category'
  final String itemId;
  final double confidence;
  final String reason;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;

  const MLRecommendationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.itemId,
    required this.confidence,
    required this.reason,
    required this.metadata,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, userId, type, itemId, confidence, reason, metadata, createdAt];
}

// User Behavior Entity
class UserBehaviorEntity extends Equatable {
  final String id;
  final String userId;
  final String action; // 'view', 'click', 'order', 'search', 'favorite'
  final String itemType; // 'restaurant', 'menu_item', 'category'
  final String itemId;
  final Map<String, dynamic> context;
  final DateTime timestamp;

  const UserBehaviorEntity({
    required this.id,
    required this.userId,
    required this.action,
    required this.itemType,
    required this.itemId,
    required this.context,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, action, itemType, itemId, context, timestamp];
}

// ML Model Entity
class MLModelEntity extends Equatable {
  final String id;
  final String name;
  final String version;
  final String type; // 'recommendation', 'prediction', 'classification'
  final Map<String, dynamic> parameters;
  final double accuracy;
  final DateTime trainedAt;
  final DateTime lastUpdated;
  final bool isActive;

  const MLModelEntity({
    required this.id,
    required this.name,
    required this.version,
    required this.type,
    required this.parameters,
    required this.accuracy,
    required this.trainedAt,
    required this.lastUpdated,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, name, version, type, parameters, accuracy, trainedAt, lastUpdated, isActive];
}

// Prediction Entity
class PredictionEntity extends Equatable {
  final String id;
  final String userId;
  final String predictionType; // 'order_time', 'preferred_restaurant', 'spending_amount'
  final dynamic predictedValue;
  final double confidence;
  final Map<String, dynamic> features;
  final DateTime createdAt;

  const PredictionEntity({
    required this.id,
    required this.userId,
    required this.predictionType,
    required this.predictedValue,
    required this.confidence,
    required this.features,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, userId, predictionType, predictedValue, confidence, features, createdAt];
}

// Feature Entity
class FeatureEntity extends Equatable {
  final String id;
  final String name;
  final String type; // 'numerical', 'categorical', 'text', 'image'
  final dynamic value;
  final double importance;
  final Map<String, dynamic> metadata;

  const FeatureEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
    required this.importance,
    required this.metadata,
  });

  @override
  List<Object> get props => [id, name, type, value, importance, metadata];
}

// ML Training Data Entity
class MLTrainingDataEntity extends Equatable {
  final String id;
  final String userId;
  final Map<String, dynamic> features;
  final Map<String, dynamic> labels;
  final String dataType; // 'order', 'behavior', 'preference'
  final DateTime timestamp;

  const MLTrainingDataEntity({
    required this.id,
    required this.userId,
    required this.features,
    required this.labels,
    required this.dataType,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, userId, features, labels, dataType, timestamp];
}

// ML Performance Metrics Entity
class MLPerformanceMetricsEntity extends Equatable {
  final String id;
  final String modelId;
  final String metricType; // 'accuracy', 'precision', 'recall', 'f1_score'
  final double value;
  final DateTime measuredAt;

  const MLPerformanceMetricsEntity({
    required this.id,
    required this.modelId,
    required this.metricType,
    required this.value,
    required this.measuredAt,
  });

  @override
  List<Object> get props => [id, modelId, metricType, value, measuredAt];
}

// ML Experiment Entity
class MLExperimentEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> parameters;
  final String status; // 'running', 'completed', 'failed'
  final Map<String, dynamic> results;
  final DateTime startedAt;
  final DateTime? completedAt;

  const MLExperimentEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.parameters,
    required this.status,
    required this.results,
    required this.startedAt,
    this.completedAt,
  });

  @override
  List<Object> get props => [id, name, description, parameters, status, results, startedAt, completedAt];
}

// ML A/B Test Entity
class MLABTestEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String controlGroup;
  final String treatmentGroup;
  final double trafficSplit; // 0.0 to 1.0
  final String status; // 'active', 'paused', 'completed'
  final Map<String, dynamic> metrics;
  final DateTime startedAt;
  final DateTime? endedAt;

  const MLABTestEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.controlGroup,
    required this.treatmentGroup,
    required this.trafficSplit,
    required this.status,
    required this.metrics,
    required this.startedAt,
    this.endedAt,
  });

  @override
  List<Object> get props => [id, name, description, controlGroup, treatmentGroup, trafficSplit, status, metrics, startedAt, endedAt];
}

// ML Feedback Entity
class MLFeedbackEntity extends Equatable {
  final String id;
  final String userId;
  final String recommendationId;
  final String feedbackType; // 'positive', 'negative', 'neutral'
  final String reason;
  final Map<String, dynamic> context;
  final DateTime createdAt;

  const MLFeedbackEntity({
    required this.id,
    required this.userId,
    required this.recommendationId,
    required this.feedbackType,
    required this.reason,
    required this.context,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, userId, recommendationId, feedbackType, reason, context, createdAt];
}
