import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/tracking_entity.dart';

class DriverInfo extends StatelessWidget {
  final TrackingEntity tracking;

  const DriverInfo({
    super.key,
    required this.tracking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            children: [
              Icon(
                Icons.person,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Your Driver',
                style: AppTheme.heading6,
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  tracking.driverName?.substring(0, 1).toUpperCase() ?? 'D',
                  style: AppTheme.heading6.copyWith(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tracking.driverName ?? 'Driver',
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Delivery Partner',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (tracking.driverPhone != null)
                IconButton(
                  onPressed: () {
                    // TODO: Implement call functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Call functionality not implemented yet')),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          if (tracking.estimatedDeliveryTime != null) ...[
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
                    'Estimated delivery: ${tracking.estimatedDeliveryTime}',
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
    );
  }
}
