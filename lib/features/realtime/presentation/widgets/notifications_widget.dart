import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_state.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  final List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    _notifications.addAll([
      {
        'id': 'notif_001',
        'title': 'Order Confirmed',
        'message': 'Your order from Pizza Palace has been confirmed and is being prepared.',
        'type': 'order_update',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'isRead': false,
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'id': 'notif_002',
        'title': 'Driver Assigned',
        'message': 'John Doe is on the way to pick up your order. ETA: 15 minutes.',
        'type': 'driver_update',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 10)),
        'isRead': false,
        'icon': Icons.person,
        'color': Colors.blue,
      },
      {
        'id': 'notif_003',
        'title': 'Order Out for Delivery',
        'message': 'Your order is out for delivery. Track your order in real-time.',
        'type': 'delivery_update',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 20)),
        'isRead': true,
        'icon': Icons.delivery_dining,
        'color': Colors.orange,
      },
      {
        'id': 'notif_004',
        'title': 'Special Offer',
        'message': 'Get 20% off your next order at Burger Joint. Use code SAVE20.',
        'type': 'promotion',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'isRead': true,
        'icon': Icons.local_offer,
        'color': Colors.purple,
      },
      {
        'id': 'notif_005',
        'title': 'Order Delivered',
        'message': 'Your order has been delivered. Enjoy your meal!',
        'type': 'delivery_complete',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'isRead': true,
        'icon': Icons.done_all,
        'color': Colors.green,
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RealtimeBloc, RealtimeState>(
      listener: (context, state) {
        if (state is RealtimeNotificationReceived) {
          _handleNewNotification(state);
        }
      },
      child: Column(
        children: [
          _buildNotificationHeader(),
          Expanded(
            child: _notifications.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _buildNotificationCard(notification);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationHeader() {
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unreadCount > 0 ? '$unreadCount unread notifications' : 'All caught up!',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'ll receive real-time updates about your orders here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['isRead'] as bool;
    final icon = notification['icon'] as IconData;
    final color = notification['color'] as Color;
    final timestamp = notification['timestamp'] as DateTime;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _markAsRead(notification['id'] as String),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isRead ? Colors.white : Colors.blue[50],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                              color: isRead ? Colors.grey[700] : Colors.black,
                            ),
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _dismissNotification(notification['id'] as String),
                icon: const Icon(Icons.close, size: 20),
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNewNotification(RealtimeNotificationReceived state) {
    setState(() {
      _notifications.insert(0, {
        'id': state.notificationId,
        'title': state.title,
        'message': state.message,
        'type': state.type,
        'timestamp': DateTime.now(),
        'isRead': false,
        'icon': _getIconForType(state.type),
        'color': _getColorForType(state.type),
      });
    });

    // Show snackbar for new notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.title),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View',
          onPressed: () {
            // Scroll to top to show new notification
          },
        ),
      ),
    );
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _dismissNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'order_update':
        return Icons.restaurant;
      case 'driver_update':
        return Icons.person;
      case 'delivery_update':
        return Icons.delivery_dining;
      case 'delivery_complete':
        return Icons.done_all;
      case 'promotion':
        return Icons.local_offer;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'order_update':
        return Colors.blue;
      case 'driver_update':
        return Colors.green;
      case 'delivery_update':
        return Colors.orange;
      case 'delivery_complete':
        return Colors.green;
      case 'promotion':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
