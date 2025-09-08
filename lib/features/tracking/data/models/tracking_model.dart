import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tracking_entity.dart';

part 'tracking_model.g.dart';

@JsonSerializable()
class TrackingModel {
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

  const TrackingModel({
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

  factory TrackingModel.fromJson(Map<String, dynamic> json) => _$TrackingModelFromJson(json);
  Map<String, dynamic> toJson() => _$TrackingModelToJson(this);

  factory TrackingModel.fromEntity(TrackingEntity entity) {
    return TrackingModel(
      id: entity.id,
      orderId: entity.orderId,
      status: entity.status,
      description: entity.description,
      timestamp: entity.timestamp,
      location: entity.location,
      latitude: entity.latitude,
      longitude: entity.longitude,
      driverId: entity.driverId,
      driverName: entity.driverName,
      driverPhone: entity.driverPhone,
      estimatedDeliveryTime: entity.estimatedDeliveryTime,
      trackingUrl: entity.trackingUrl,
    );
  }

  TrackingEntity toEntity() {
    return TrackingEntity(
      id: id,
      orderId: orderId,
      status: status,
      description: description,
      timestamp: timestamp,
      location: location,
      latitude: latitude,
      longitude: longitude,
      driverId: driverId,
      driverName: driverName,
      driverPhone: driverPhone,
      estimatedDeliveryTime: estimatedDeliveryTime,
      trackingUrl: trackingUrl,
    );
  }
}
