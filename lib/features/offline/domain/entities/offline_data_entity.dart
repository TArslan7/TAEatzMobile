import 'package:equatable/equatable.dart';

class OfflineDataEntity extends Equatable {
  final String id;
  final String userId;
  final OfflineDataType type;
  final String dataId;
  final Map<String, dynamic> data;
  final DateTime lastUpdated;
  final DateTime? lastSynced;
  final OfflineDataStatus status;
  final int syncAttempts;
  final String? errorMessage;

  const OfflineDataEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.dataId,
    required this.data,
    required this.lastUpdated,
    this.lastSynced,
    this.status = OfflineDataStatus.pending,
    this.syncAttempts = 0,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    dataId,
    data,
    lastUpdated,
    lastSynced,
    status,
    syncAttempts,
    errorMessage,
  ];
}

enum OfflineDataType {
  order,
  review,
  rating,
  favorite,
  cart,
  profile,
  search,
  restaurant,
  menu,
}

enum OfflineDataStatus {
  pending,
  syncing,
  synced,
  failed,
  conflict,
}

class OfflineSyncEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final OfflineSyncStatus status;
  final int totalItems;
  final int syncedItems;
  final int failedItems;
  final List<String> errors;
  final Map<String, dynamic> metadata;

  const OfflineSyncEntity({
    required this.id,
    required this.userId,
    required this.startedAt,
    this.completedAt,
    this.status = OfflineSyncStatus.pending,
    this.totalItems = 0,
    this.syncedItems = 0,
    this.failedItems = 0,
    this.errors = const [],
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    startedAt,
    completedAt,
    status,
    totalItems,
    syncedItems,
    failedItems,
    errors,
    metadata,
  ];
}

enum OfflineSyncStatus {
  pending,
  inProgress,
  completed,
  failed,
  cancelled,
}

class OfflineCacheEntity extends Equatable {
  final String id;
  final String key;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime expiresAt;
  final OfflineCacheType type;
  final int priority;
  final bool isCompressed;

  const OfflineCacheEntity({
    required this.id,
    required this.key,
    required this.data,
    required this.createdAt,
    required this.expiresAt,
    required this.type,
    this.priority = 0,
    this.isCompressed = false,
  });

  @override
  List<Object?> get props => [
    id,
    key,
    data,
    createdAt,
    expiresAt,
    type,
    priority,
    isCompressed,
  ];
}

enum OfflineCacheType {
  restaurant,
  menu,
  order,
  user,
  search,
  image,
  static,
}

class OfflineOrderEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<OfflineOrderItemEntity> items;
  final double totalAmount;
  final String deliveryAddress;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? scheduledFor;
  final OfflineOrderStatus status;
  final Map<String, dynamic> metadata;

  const OfflineOrderEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.totalAmount,
    required this.deliveryAddress,
    this.specialInstructions,
    required this.createdAt,
    this.scheduledFor,
    this.status = OfflineOrderStatus.draft,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    items,
    totalAmount,
    deliveryAddress,
    specialInstructions,
    createdAt,
    scheduledFor,
    status,
    metadata,
  ];
}

class OfflineOrderItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final List<String> customizations;
  final Map<String, dynamic> metadata;

  const OfflineOrderItemEntity({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    this.customizations = const [],
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    menuItemId,
    name,
    description,
    price,
    quantity,
    customizations,
    metadata,
  ];
}

enum OfflineOrderStatus {
  draft,
  pending,
  queued,
  synced,
  failed,
}

class OfflineSyncConflictEntity extends Equatable {
  final String id;
  final String userId;
  final String dataId;
  final OfflineDataType type;
  final Map<String, dynamic> localData;
  final Map<String, dynamic> remoteData;
  final DateTime detectedAt;
  final ConflictResolutionStrategy strategy;
  final Map<String, dynamic> resolution;

  const OfflineSyncConflictEntity({
    required this.id,
    required this.userId,
    required this.dataId,
    required this.type,
    required this.localData,
    required this.remoteData,
    required this.detectedAt,
    this.strategy = ConflictResolutionStrategy.manual,
    this.resolution = const {},
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    dataId,
    type,
    localData,
    remoteData,
    detectedAt,
    strategy,
    resolution,
  ];
}

enum ConflictResolutionStrategy {
  local,
  remote,
  merge,
  manual,
  newest,
  oldest,
}

class OfflineStorageStatsEntity extends Equatable {
  final String userId;
  final int totalItems;
  final int pendingSync;
  final int failedSync;
  final int totalSizeBytes;
  final DateTime lastSync;
  final Map<OfflineDataType, int> itemsByType;
  final Map<OfflineCacheType, int> cacheByType;

  const OfflineStorageStatsEntity({
    required this.userId,
    required this.totalItems,
    required this.pendingSync,
    required this.failedSync,
    required this.totalSizeBytes,
    required this.lastSync,
    required this.itemsByType,
    required this.cacheByType,
  });

  @override
  List<Object?> get props => [
    userId,
    totalItems,
    pendingSync,
    failedSync,
    totalSizeBytes,
    lastSync,
    itemsByType,
    cacheByType,
  ];
}
