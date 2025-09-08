import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final NotificationType type;
  final String? orderId;
  final String? restaurantId;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.type,
    this.orderId,
    this.restaurantId,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    body,
    imageUrl,
    type,
    orderId,
    restaurantId,
    data,
    isRead,
    createdAt,
  ];
}

enum NotificationType {
  orderUpdate,
  promotion,
  restaurant,
  general,
  delivery,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.orderUpdate:
        return 'Order Update';
      case NotificationType.promotion:
        return 'Promotion';
      case NotificationType.restaurant:
        return 'Restaurant';
      case NotificationType.general:
        return 'General';
      case NotificationType.delivery:
        return 'Delivery';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.orderUpdate:
        return '📦';
      case NotificationType.promotion:
        return '🎉';
      case NotificationType.restaurant:
        return '🍽️';
      case NotificationType.general:
        return '📢';
      case NotificationType.delivery:
        return '🚚';
    }
  }
}
