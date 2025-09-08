import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/tracking_entity.dart';

class TrackingTimeline extends StatelessWidget {
  final List<TrackingEntity> trackingHistory;

  const TrackingTimeline({
    super.key,
    required this.trackingHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'Order Progress',
            style: AppTheme.heading6,
          ),
          const SizedBox(height: AppTheme.spacingM),
          ...trackingHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final tracking = entry.value;
            final isLast = index == trackingHistory.length - 1;
            
            return _buildTimelineItem(
              tracking: tracking,
              isLast: isLast,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required TrackingEntity tracking,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getStatusColor(tracking.status),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppTheme.borderColor,
                margin: const EdgeInsets.only(top: 4),
              ),
          ],
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getStatusDisplayName(tracking.status),
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (tracking.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  tracking.description!,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                _formatTime(tracking.timestamp),
                style: AppTheme.caption.copyWith(
                  color: AppTheme.textTertiaryColor,
                ),
              ),
              if (tracking.location != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: AppTheme.textTertiaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tracking.location!,
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textTertiaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'order_placed':
        return AppTheme.infoColor;
      case 'order_confirmed':
        return AppTheme.primaryColor;
      case 'preparing':
        return AppTheme.warningColor;
      case 'ready_for_pickup':
        return AppTheme.accentColor;
      case 'out_for_delivery':
        return AppTheme.successColor;
      case 'delivered':
        return AppTheme.successColor;
      case 'cancelled':
        return AppTheme.errorColor;
      default:
        return AppTheme.textTertiaryColor;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'order_placed':
        return 'Order Placed';
      case 'order_confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Preparing';
      case 'ready_for_pickup':
        return 'Ready for Pickup';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _formatTime(DateTime timestamp) {
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
