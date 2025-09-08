import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/tracking_entity.dart';

class DeliveryMap extends StatelessWidget {
  final TrackingEntity tracking;

  const DeliveryMap({
    super.key,
    required this.tracking,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
      height: 200,
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
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Row(
              children: [
                Icon(
                  Icons.map,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  'Delivery Location',
                  style: AppTheme.heading6,
                ),
                const Spacer(),
                if (tracking.trackingUrl != null)
                  TextButton(
                    onPressed: () {
                      // TODO: Open tracking URL
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tracking URL not implemented yet')),
                      );
                    },
                    child: const Text('View on Map'),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                AppTheme.spacingM,
                0,
                AppTheme.spacingM,
                AppTheme.spacingM,
              ),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
                border: Border.all(color: AppTheme.borderColor),
              ),
              child: Stack(
                children: [
                  // Mock map background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.1),
                          AppTheme.secondaryColor.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    ),
                  ),
                  // Mock map content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppTheme.primaryColor,
                          size: 40,
                        ),
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          'Driver Location',
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Lat: ${tracking.latitude?.toStringAsFixed(4) ?? 'N/A'}',
                          style: AppTheme.caption,
                        ),
                        Text(
                          'Lng: ${tracking.longitude?.toStringAsFixed(4) ?? 'N/A'}',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  // Mock delivery route
                  if (tracking.latitude != null && tracking.longitude != null)
                    Positioned(
                      top: 20,
                      left: 20,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
