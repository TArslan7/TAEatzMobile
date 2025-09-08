import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';
import '../widgets/tracking_timeline.dart';
import '../widgets/delivery_map.dart';
import '../widgets/driver_info.dart';

class TrackingPage extends StatefulWidget {
  final String orderId;

  const TrackingPage({
    super.key,
    required this.orderId,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrackingBloc>().add(LoadOrderTracking(orderId: widget.orderId));
    context.read<TrackingBloc>().add(StartTracking(orderId: widget.orderId));
  }

  @override
  void dispose() {
    context.read<TrackingBloc>().add(StopTracking(orderId: widget.orderId));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<TrackingBloc>().add(RefreshTracking(orderId: widget.orderId));
            },
          ),
        ],
      ),
      body: BlocBuilder<TrackingBloc, TrackingState>(
        builder: (context, state) {
          if (state is TrackingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TrackingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    'Error loading tracking',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    state.message,
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingL),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TrackingBloc>().add(LoadOrderTracking(orderId: widget.orderId));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is TrackingLoaded) {
            return SingleChildScrollView(
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
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: AppTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingM),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order #${widget.orderId}',
                                    style: AppTheme.heading6,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    state.latestTracking?.status.replaceAll('_', ' ').toUpperCase() ?? 'UNKNOWN',
                                    style: AppTheme.bodyMedium.copyWith(
                                      color: AppTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state.latestTracking?.estimatedDeliveryTime != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingS,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'ETA: ${state.latestTracking!.estimatedDeliveryTime}',
                                  style: AppTheme.caption.copyWith(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (state.latestTracking?.description != null) ...[
                          const SizedBox(height: AppTheme.spacingM),
                          Text(
                            state.latestTracking!.description!,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Driver Info
                  if (state.latestTracking?.driverName != null)
                    DriverInfo(tracking: state.latestTracking!),

                  // Map
                  if (state.latestTracking?.latitude != null && state.latestTracking?.longitude != null)
                    DeliveryMap(tracking: state.latestTracking!),

                  // Tracking Timeline
                  TrackingTimeline(trackingHistory: state.trackingHistory),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
