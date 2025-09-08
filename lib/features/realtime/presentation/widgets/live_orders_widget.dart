import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_event.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_state.dart';

class LiveOrdersWidget extends StatefulWidget {
  const LiveOrdersWidget({super.key});

  @override
  State<LiveOrdersWidget> createState() => _LiveOrdersWidgetState();
}

class _LiveOrdersWidgetState extends State<LiveOrdersWidget> {
  final List<Map<String, dynamic>> _liveOrders = [];
  final Map<String, Map<String, double>> _orderLocations = {};

  @override
  void initState() {
    super.initState();
    _loadMockLiveOrders();
  }

  void _loadMockLiveOrders() {
    // Mock live orders data
    _liveOrders.addAll([
      {
        'id': 'order_001',
        'restaurant': 'Pizza Palace',
        'status': 'preparing',
        'estimatedTime': '15-20 min',
        'total': 25.99,
        'items': ['Margherita Pizza', 'Caesar Salad'],
        'driver': {
          'name': 'John Doe',
          'phone': '+1 234-567-8900',
          'rating': 4.8,
        },
        'location': {
          'latitude': 40.7128,
          'longitude': -74.0060,
        },
      },
      {
        'id': 'order_002',
        'restaurant': 'Burger Joint',
        'status': 'out_for_delivery',
        'estimatedTime': '5-10 min',
        'total': 18.50,
        'items': ['Chicken Burger', 'Fries'],
        'driver': {
          'name': 'Jane Smith',
          'phone': '+1 234-567-8901',
          'rating': 4.9,
        },
        'location': {
          'latitude': 40.7589,
          'longitude': -73.9851,
        },
      },
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RealtimeBloc, RealtimeState>(
      listener: (context, state) {
        if (state is RealtimeOrderUpdate) {
          _handleOrderUpdate(state);
        } else if (state is RealtimeLocationUpdate) {
          _handleLocationUpdate(state);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          // Refresh live orders
          setState(() {
            _loadMockLiveOrders();
          });
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _liveOrders.length,
          itemBuilder: (context, index) {
            final order = _liveOrders[index];
            return _buildLiveOrderCard(order);
          },
        ),
      ),
    );
  }

  Widget _buildLiveOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['restaurant'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Order #${order['id']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase().replaceAll('_', ' '),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Estimated time: ${order['estimatedTime']}',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total: \$${order['total']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: (order['items'] as List<dynamic>)
                  .map((item) => Chip(
                        label: Text(
                          item as String,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[100],
                        labelStyle: TextStyle(color: Colors.grey[700]),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blue[100],
                  child: Text(
                    (order['driver']['name'] as String).substring(0, 1),
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['driver']['name'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${order['driver']['rating']}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _callDriver(order['driver']['phone'] as String),
                  icon: const Icon(Icons.phone, color: Colors.green),
                ),
                IconButton(
                  onPressed: () => _trackOrder(order['id'] as String),
                  icon: const Icon(Icons.location_on, color: Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'preparing':
        return Colors.orange;
      case 'out_for_delivery':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'preparing':
        return Icons.restaurant;
      case 'out_for_delivery':
        return Icons.delivery_dining;
      case 'delivered':
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  void _handleOrderUpdate(RealtimeOrderUpdate state) {
    setState(() {
      final orderIndex = _liveOrders.indexWhere(
        (order) => order['id'] == state.orderId,
      );
      if (orderIndex != -1) {
        _liveOrders[orderIndex]['status'] = state.status;
        _liveOrders[orderIndex]['data'] = state.data;
      }
    });
  }

  void _handleLocationUpdate(RealtimeLocationUpdate state) {
    setState(() {
      _orderLocations[state.orderId] = {
        'latitude': state.latitude,
        'longitude': state.longitude,
      };
    });
  }

  void _callDriver(String phoneNumber) {
    // Implement phone call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calling $phoneNumber...')),
    );
  }

  void _trackOrder(String orderId) {
    // Navigate to detailed tracking page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tracking order $orderId...')),
    );
  }
}
