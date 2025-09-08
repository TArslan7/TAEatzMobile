import 'package:equatable/equatable.dart';

// Group Order Entity
class GroupOrderEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> participantIds;
  final String restaurantId;
  final String status; // 'active', 'closed', 'completed'
  final DateTime createdAt;
  final DateTime? expiresAt;
  final Map<String, dynamic> settings;
  final double totalAmount;
  final String currency;

  const GroupOrderEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.participantIds,
    required this.restaurantId,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    required this.settings,
    required this.totalAmount,
    required this.currency,
  });

  @override
  List<Object> get props => [id, name, description, creatorId, participantIds, restaurantId, status, createdAt, expiresAt, settings, totalAmount, currency];
}

// Live Chat Entity
class LiveChatEntity extends Equatable {
  final String id;
  final String groupOrderId;
  final String senderId;
  final String message;
  final String messageType; // 'text', 'image', 'emoji', 'system'
  final Map<String, dynamic> metadata;
  final DateTime timestamp;
  final bool isRead;

  const LiveChatEntity({
    required this.id,
    required this.groupOrderId,
    required this.senderId,
    required this.message,
    required this.messageType,
    required this.metadata,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object> get props => [id, groupOrderId, senderId, message, messageType, metadata, timestamp, isRead];
}

// User Presence Entity
class UserPresenceEntity extends Equatable {
  final String userId;
  final String status; // 'online', 'away', 'busy', 'offline'
  final DateTime lastSeen;
  final String currentActivity;
  final Map<String, dynamic> context;

  const UserPresenceEntity({
    required this.userId,
    required this.status,
    required this.lastSeen,
    required this.currentActivity,
    required this.context,
  });

  @override
  List<Object> get props => [userId, status, lastSeen, currentActivity, context];
}

// Shared Cart Entity
class SharedCartEntity extends Equatable {
  final String id;
  final String groupOrderId;
  final String userId;
  final List<CartItemEntity> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final DateTime lastUpdated;

  const SharedCartEntity({
    required this.id,
    required this.groupOrderId,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.lastUpdated,
  });

  @override
  List<Object> get props => [id, groupOrderId, userId, items, subtotal, tax, deliveryFee, total, lastUpdated];
}

// Cart Item Entity
class CartItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final List<String> customizations;
  final String notes;

  const CartItemEntity({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.customizations,
    required this.notes,
  });

  @override
  List<Object> get props => [id, menuItemId, name, quantity, price, customizations, notes];
}

// Real-time Notification Entity
class RealtimeNotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String type; // 'group_invite', 'order_update', 'chat_message', 'payment_request'
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const RealtimeNotificationEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.message,
    required this.data,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  @override
  List<Object> get props => [id, userId, type, title, message, data, isRead, createdAt, readAt];
}
