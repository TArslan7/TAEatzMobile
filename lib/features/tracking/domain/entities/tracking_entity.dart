import 'package:equatable/equatable.dart';

class TrackingEntity extends Equatable {
  final String id;
  final String orderId;
  final String status;
  final String? description;
  final DateTime timestamp;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final String? estimatedDeliveryTime;
  final String? trackingUrl;

  const TrackingEntity({
    required this.id,
    required this.orderId,
    required this.status,
    this.description,
    required this.timestamp,
    this.location,
    this.latitude,
    this.longitude,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.estimatedDeliveryTime,
    this.trackingUrl,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    status,
    description,
    timestamp,
    location,
    latitude,
    longitude,
    driverId,
    driverName,
    driverPhone,
    estimatedDeliveryTime,
    trackingUrl,
  ];
}

enum TrackingStatus {
  orderPlaced,
  orderConfirmed,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
  cancelled,
}

extension TrackingStatusExtension on TrackingStatus {
  String get displayName {
    switch (this) {
      case TrackingStatus.orderPlaced:
        return 'Order Placed';
      case TrackingStatus.orderConfirmed:
        return 'Order Confirmed';
      case TrackingStatus.preparing:
        return 'Preparing';
      case TrackingStatus.readyForPickup:
        return 'Ready for Pickup';
      case TrackingStatus.outForDelivery:
        return 'Out for Delivery';
      case TrackingStatus.delivered:
        return 'Delivered';
      case TrackingStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case TrackingStatus.orderPlaced:
        return 'Your order has been placed and is being processed';
      case TrackingStatus.orderConfirmed:
        return 'Restaurant has confirmed your order';
      case TrackingStatus.preparing:
        return 'Your food is being prepared';
      case TrackingStatus.readyForPickup:
        return 'Your order is ready for pickup';
      case TrackingStatus.outForDelivery:
        return 'Your order is on its way to you';
      case TrackingStatus.delivered:
        return 'Your order has been delivered';
      case TrackingStatus.cancelled:
        return 'Your order has been cancelled';
    }
  }
}
