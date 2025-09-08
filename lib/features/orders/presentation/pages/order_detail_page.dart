import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';
import '../../../tracking/presentation/pages/tracking_page.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderEntity order;

  const OrderDetailPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id}'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          if (_canTrackOrder(order))
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TrackingPage(orderId: order.id),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_shipping,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Track',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Status Card
            Container(
              margin: const EdgeInsets.all(AppTheme.spacingM),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getStatusIcon(order.status),
                          color: _getStatusColor(order.status),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getStatusText(order.status),
                              style: AppTheme.heading6,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _getStatusDescription(order.status),
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (order.estimatedDeliveryTime != null) ...[
                    const SizedBox(height: AppTheme.spacingM),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingS),
                      decoration: BoxDecoration(
                        color: AppTheme.infoColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: AppTheme.infoColor,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            'Estimated delivery: ${_formatDeliveryTime(order.estimatedDeliveryTime!)}',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.infoColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Restaurant Info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Restaurant',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        child: Container(
                          width: 60,
                          height: 60,
                          color: AppTheme.backgroundColor,
                          child: CachedNetworkImage(
                            imageUrl: order.restaurantImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.backgroundColor,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppTheme.backgroundColor,
                              child: Icon(
                                Icons.restaurant,
                                size: 24,
                                color: AppTheme.textTertiaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.restaurantName,
                              style: AppTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Order placed on ${_formatOrderDate(order.createdAt)}',
                              style: AppTheme.bodyMedium.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Order Items
            Container(
              margin: const EdgeInsets.all(AppTheme.spacingM),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Items',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacingM),
                    child: Row(
                      children: [
                        Text(
                          '${item.quantity}x',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Expanded(
                          child: Text(
                            item.name,
                            style: AppTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          '€${item.totalPrice.toStringAsFixed(2)}',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            // Order Summary
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order Summary',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildSummaryRow('Subtotal', '€${order.subtotal.toStringAsFixed(2)}'),
                  _buildSummaryRow('Tax', '€${order.taxAmount.toStringAsFixed(2)}'),
                  _buildSummaryRow('Delivery Fee', '€${order.deliveryFee.toStringAsFixed(2)}'),
                  if (order.tipAmount > 0)
                    _buildSummaryRow('Tip', '€${order.tipAmount.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildSummaryRow(
                    'Total',
                    '€${order.totalAmount.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),

            // Delivery Address
            Container(
              margin: const EdgeInsets.all(AppTheme.spacingM),
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Address',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.deliveryAddress,
                              style: AppTheme.bodyMedium,
                            ),
                            if (order.deliveryInstructions?.isNotEmpty == true) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Note: ${order.deliveryInstructions}',
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondaryColor,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal 
                ? AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)
                : AppTheme.bodyMedium,
          ),
          Text(
            value,
            style: isTotal 
                ? AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  )
                : AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  bool _canTrackOrder(OrderEntity order) {
    return order.status == OrderStatus.confirmed ||
           order.status == OrderStatus.preparing ||
           order.status == OrderStatus.ready ||
           order.status == OrderStatus.outForDelivery;
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warningColor;
      case OrderStatus.confirmed:
        return AppTheme.infoColor;
      case OrderStatus.preparing:
        return AppTheme.accentColor;
      case OrderStatus.ready:
        return AppTheme.successColor;
      case OrderStatus.outForDelivery:
        return AppTheme.primaryColor;
      case OrderStatus.delivered:
        return AppTheme.successColor;
      case OrderStatus.cancelled:
        return AppTheme.errorColor;
      case OrderStatus.refunded:
        return AppTheme.textSecondaryColor;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.ready:
        return Icons.restaurant_menu;
      case OrderStatus.outForDelivery:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.refunded:
        return Icons.refresh;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }

  String _getStatusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Your order is being processed';
      case OrderStatus.confirmed:
        return 'Restaurant has confirmed your order';
      case OrderStatus.preparing:
        return 'Your food is being prepared';
      case OrderStatus.ready:
        return 'Your order is ready for pickup';
      case OrderStatus.outForDelivery:
        return 'Your order is on its way to you';
      case OrderStatus.delivered:
        return 'Your order has been delivered';
      case OrderStatus.cancelled:
        return 'Your order has been cancelled';
      case OrderStatus.refunded:
        return 'Your order has been refunded';
    }
  }

  String _formatDeliveryTime(DateTime deliveryTime) {
    final now = DateTime.now();
    final difference = deliveryTime.difference(now);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours';
    } else {
      return DateFormat('MMM dd, yyyy').format(deliveryTime);
    }
  }

  String _formatOrderDate(DateTime date) {
    return DateFormat('MMM dd, yyyy at hh:mm a').format(date);
  }
}
