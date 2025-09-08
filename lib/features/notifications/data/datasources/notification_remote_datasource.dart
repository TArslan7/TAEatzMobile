import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<NotificationModel> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> clearAllNotifications();
  Stream<NotificationModel> getNotificationStream();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  NotificationRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<List<NotificationModel>> getNotifications() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      NotificationModel(
        id: 'notif_1',
        title: 'Order Update',
        body: 'Your order #12345 is out for delivery',
        type: 'orderUpdate',
        orderId: 'order_12345',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: 'notif_2',
        title: 'Special Offer!',
        body: 'Get 20% off your next order at Pizza Palace',
        type: 'promotion',
        restaurantId: 'restaurant_1',
        imageUrl: 'https://example.com/promo.jpg',
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationModel(
        id: 'notif_3',
        title: 'Order Delivered',
        body: 'Your order has been delivered. Enjoy your meal!',
        type: 'delivery',
        orderId: 'order_12344',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      NotificationModel(
        id: 'notif_4',
        title: 'New Restaurant',
        body: 'Check out the new Sushi Bar in your area',
        type: 'restaurant',
        restaurantId: 'restaurant_3',
        imageUrl: 'https://example.com/sushi.jpg',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationModel(
        id: 'notif_5',
        title: 'App Update',
        body: 'New features available! Update now for the best experience',
        type: 'general',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final notifications = await getNotifications();
    final notification = notifications.firstWhere(
      (n) => n.id == notificationId,
      orElse: () => throw Exception('Notification not found'),
    );
    
    return NotificationModel(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      imageUrl: notification.imageUrl,
      type: notification.type,
      orderId: notification.orderId,
      restaurantId: notification.restaurantId,
      data: notification.data,
      isRead: true,
      createdAt: notification.createdAt,
    );
  }

  @override
  Future<void> markAllAsRead() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> clearAllNotifications() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Stream<NotificationModel> getNotificationStream() async* {
    // Mock implementation - simulate real-time notifications
    while (true) {
      await Future.delayed(const Duration(seconds: 30));
      
      final notification = NotificationModel(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'New Order Update',
        body: 'Your order status has been updated',
        type: 'orderUpdate',
        orderId: 'order_${DateTime.now().millisecondsSinceEpoch}',
        isRead: false,
        createdAt: DateTime.now(),
      );
      
      yield notification;
    }
  }
}
