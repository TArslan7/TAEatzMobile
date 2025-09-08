import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';

class OrderCard extends StatelessWidget {
  final OrderEntity order;
  final VoidCallback? onTap;
  final VoidCallback? onReorder;
  final VoidCallback? onTrack;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
    this.onReorder,
    this.onTrack,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with restaurant info and status
              Row(
                children: [
                  // Restaurant Image
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
                  // Restaurant name and order info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.restaurantName,
                          style: AppTheme.heading6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          'Order #${order.id.substring(order.id.length - 6)}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        Text(
                          _formatOrderDate(order.createdAt),
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.textTertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status chip
                  _buildStatusChip(),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Order items preview
              _buildOrderItemsPreview(),
              
              const SizedBox(height: AppTheme.spacingM),
              
              // Order total and actions
              Row(
                children: [
                  Text(
                    'Total: €${order.totalAmount.toStringAsFixed(2)}',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  const Spacer(),
                  _buildActionButtons(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    final statusColor = _getStatusColor(order.status);
    final statusText = _getStatusText(order.status);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingXS,
      ),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        statusText,
        style: AppTheme.caption.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildOrderItemsPreview() {
    final previewItems = order.items.take(2).toList();
    final remainingCount = order.items.length - previewItems.length;
    
    return Column(
      children: [
        ...previewItems.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingXS),
          child: Row(
            children: [
              Text(
                '${item.quantity}x',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  item.name,
                  style: AppTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '€${item.totalPrice.toStringAsFixed(2)}',
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )),
        if (remainingCount > 0)
          Text(
            '+ $remainingCount more item${remainingCount > 1 ? 's' : ''}',
            style: AppTheme.caption.copyWith(
              color: AppTheme.textTertiaryColor,
              fontStyle: FontStyle.italic,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (order.status == OrderStatus.delivered && onReorder != null)
          GestureDetector(
            onTap: () {
              print('Reorder button tapped for order: ${order.id}');
              onReorder?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Reorder',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        if ((order.status == OrderStatus.confirmed || 
              order.status == OrderStatus.preparing || 
              order.status == OrderStatus.ready || 
              order.status == OrderStatus.outForDelivery) && onTrack != null)
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () {
                print('Track button tapped for order: ${order.id}');
                onTrack?.call();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
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
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if ((order.status == OrderStatus.pending || order.status == OrderStatus.confirmed) && onCancel != null)
          GestureDetector(
            onTap: () {
              print('Cancel button tapped for order: ${order.id}');
              onCancel?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.errorColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.errorColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppTheme.warningColor;
      case OrderStatus.confirmed:
        return AppTheme.infoColor;
      case OrderStatus.preparing:
        return AppTheme.primaryColor;
      case OrderStatus.ready:
        return AppTheme.secondaryColor;
      case OrderStatus.outForDelivery:
        return AppTheme.accentColor;
      case OrderStatus.delivered:
        return AppTheme.successColor;
      case OrderStatus.cancelled:
        return AppTheme.errorColor;
      case OrderStatus.refunded:
        return AppTheme.textTertiaryColor;
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

  String _formatOrderDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
