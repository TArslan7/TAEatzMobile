import 'package:equatable/equatable.dart';

// AR Menu Item Entity
class ARMenuItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String arModelUrl;
  final String arModelType; // '3d', '2d', 'video'
  final Map<String, double> dimensions; // width, height, depth
  final Map<String, double> position; // x, y, z
  final Map<String, double> rotation; // x, y, z
  final Map<String, double> scale; // x, y, z
  final List<String> animations;
  final Map<String, dynamic> metadata;
  final bool isActive;

  const ARMenuItemEntity({
    required this.id,
    required this.menuItemId,
    required this.arModelUrl,
    required this.arModelType,
    required this.dimensions,
    required this.position,
    required this.rotation,
    required this.scale,
    required this.animations,
    required this.metadata,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, menuItemId, arModelUrl, arModelType, dimensions, position, rotation, scale, animations, metadata, isActive];
}

// AR Restaurant Entity
class ARRestaurantEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String arSceneUrl;
  final String arSceneType; // 'interior', 'exterior', 'kitchen'
  final Map<String, double> dimensions;
  final List<ARHotspotEntity> hotspots;
  final List<ARMenuItemEntity> menuItems;
  final Map<String, dynamic> metadata;
  final bool isActive;

  const ARRestaurantEntity({
    required this.id,
    required this.restaurantId,
    required this.arSceneUrl,
    required this.arSceneType,
    required this.dimensions,
    required this.hotspots,
    required this.menuItems,
    required this.metadata,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, restaurantId, arSceneUrl, arSceneType, dimensions, hotspots, menuItems, metadata, isActive];
}

// AR Hotspot Entity
class ARHotspotEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final Map<String, double> position;
  final Map<String, double> rotation;
  final String action; // 'info', 'menu', 'order', 'navigate'
  final Map<String, dynamic> data;
  final String iconUrl;
  final bool isVisible;

  const ARHotspotEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.position,
    required this.rotation,
    required this.action,
    required this.data,
    required this.iconUrl,
    required this.isVisible,
  });

  @override
  List<Object> get props => [id, name, description, position, rotation, action, data, iconUrl, isVisible];
}

// AR Session Entity
class ARSessionEntity extends Equatable {
  final String id;
  final String userId;
  final String sessionId;
  final String arType; // 'menu', 'restaurant', 'custom'
  final String status; // 'active', 'paused', 'ended'
  final DateTime startedAt;
  final DateTime? endedAt;
  final Map<String, dynamic> context;
  final List<ARInteractionEntity> interactions;

  const ARSessionEntity({
    required this.id,
    required this.userId,
    required this.sessionId,
    required this.arType,
    required this.status,
    required this.startedAt,
    this.endedAt,
    required this.context,
    required this.interactions,
  });

  @override
  List<Object> get props => [id, userId, sessionId, arType, status, startedAt, endedAt, context, interactions];
}

// AR Interaction Entity
class ARInteractionEntity extends Equatable {
  final String id;
  final String sessionId;
  final String interactionType; // 'tap', 'gaze', 'gesture', 'voice'
  final String targetId;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  final double duration; // in seconds

  const ARInteractionEntity({
    required this.id,
    required this.sessionId,
    required this.interactionType,
    required this.targetId,
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  @override
  List<Object> get props => [id, sessionId, interactionType, targetId, data, timestamp, duration];
}

// AR Model Entity
class ARModelEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String modelUrl;
  final String modelType; // 'gltf', 'glb', 'fbx', 'obj'
  final String thumbnailUrl;
  final Map<String, double> dimensions;
  final int fileSize;
  final String version;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const ARModelEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.modelUrl,
    required this.modelType,
    required this.thumbnailUrl,
    required this.dimensions,
    required this.fileSize,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, name, description, modelUrl, modelType, thumbnailUrl, dimensions, fileSize, version, createdAt, updatedAt, isActive];
}

// AR Animation Entity
class ARAnimationEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String animationType; // 'rotation', 'scale', 'translation', 'custom'
  final Map<String, dynamic> parameters;
  final double duration; // in seconds
  final String easing; // 'linear', 'ease_in', 'ease_out', 'ease_in_out'
  final bool loop;
  final bool isActive;

  const ARAnimationEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.animationType,
    required this.parameters,
    required this.duration,
    required this.easing,
    required this.loop,
    required this.isActive,
  });

  @override
  List<Object> get props => [id, name, description, animationType, parameters, duration, easing, loop, isActive];
}

// AR Tracking Entity
class ARTrackingEntity extends Equatable {
  final String id;
  final String sessionId;
  final String trackingType; // 'plane', 'image', 'object', 'face'
  final Map<String, dynamic> trackingData;
  final double confidence;
  final DateTime timestamp;

  const ARTrackingEntity({
    required this.id,
    required this.sessionId,
    required this.trackingType,
    required this.trackingData,
    required this.confidence,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, sessionId, trackingType, trackingData, confidence, timestamp];
}

// AR Analytics Entity
class ARAnalyticsEntity extends Equatable {
  final String id;
  final String sessionId;
  final String metricType; // 'session_duration', 'interaction_count', 'model_load_time'
  final double value;
  final Map<String, dynamic> context;
  final DateTime timestamp;

  const ARAnalyticsEntity({
    required this.id,
    required this.sessionId,
    required this.metricType,
    required this.value,
    required this.context,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, sessionId, metricType, value, context, timestamp];
}

// AR Error Entity
class ARErrorEntity extends Equatable {
  final String id;
  final String sessionId;
  final String errorType; // 'tracking', 'rendering', 'model_loading', 'permission'
  final String errorMessage;
  final Map<String, dynamic> context;
  final DateTime timestamp;

  const ARErrorEntity({
    required this.id,
    required this.sessionId,
    required this.errorType,
    required this.errorMessage,
    required this.context,
    required this.timestamp,
  });

  @override
  List<Object> get props => [id, sessionId, errorType, errorMessage, context, timestamp];
}

// AR Settings Entity
class ARSettingsEntity extends Equatable {
  final String id;
  final String userId;
  final bool isEnabled;
  final String quality; // 'low', 'medium', 'high', 'ultra'
  final bool shadowsEnabled;
  final bool lightingEnabled;
  final bool physicsEnabled;
  final double fieldOfView;
  final int maxRenderDistance;
  final bool hapticFeedbackEnabled;
  final bool soundEnabled;

  const ARSettingsEntity({
    required this.id,
    required this.userId,
    required this.isEnabled,
    required this.quality,
    required this.shadowsEnabled,
    required this.lightingEnabled,
    required this.physicsEnabled,
    required this.fieldOfView,
    required this.maxRenderDistance,
    required this.hapticFeedbackEnabled,
    required this.soundEnabled,
  });

  @override
  List<Object> get props => [id, userId, isEnabled, quality, shadowsEnabled, lightingEnabled, physicsEnabled, fieldOfView, maxRenderDistance, hapticFeedbackEnabled, soundEnabled];
}
