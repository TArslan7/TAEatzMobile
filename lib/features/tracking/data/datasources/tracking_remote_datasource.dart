import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/tracking_model.dart';

abstract class TrackingRemoteDataSource {
  Future<List<TrackingModel>> getOrderTracking(String orderId);
  Future<TrackingModel> getLatestTracking(String orderId);
  Future<void> startTracking(String orderId);
  Future<void> stopTracking(String orderId);
  Stream<TrackingModel> getTrackingStream(String orderId);
}

class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  TrackingRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<List<TrackingModel>> getOrderTracking(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      TrackingModel(
        id: 'track_1',
        orderId: orderId,
        status: 'order_placed',
        description: 'Your order has been placed and is being processed',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        location: 'Restaurant',
      ),
      TrackingModel(
        id: 'track_2',
        orderId: orderId,
        status: 'order_confirmed',
        description: 'Restaurant has confirmed your order',
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        location: 'Restaurant',
      ),
      TrackingModel(
        id: 'track_3',
        orderId: orderId,
        status: 'preparing',
        description: 'Your food is being prepared',
        timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
        location: 'Restaurant',
      ),
      TrackingModel(
        id: 'track_4',
        orderId: orderId,
        status: 'out_for_delivery',
        description: 'Your order is on its way to you',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        location: 'On the way',
        latitude: 52.3676,
        longitude: 4.9041,
        driverId: 'driver_123',
        driverName: 'John Doe',
        driverPhone: '+1234567890',
        estimatedDeliveryTime: '15 minutes',
      ),
    ];
  }

  @override
  Future<TrackingModel> getLatestTracking(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return TrackingModel(
      id: 'track_latest',
      orderId: orderId,
      status: 'out_for_delivery',
      description: 'Your order is on its way to you',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      location: 'On the way',
      latitude: 52.3676,
      longitude: 4.9041,
      driverId: 'driver_123',
      driverName: 'John Doe',
      driverPhone: '+1234567890',
      estimatedDeliveryTime: '15 minutes',
    );
  }

  @override
  Future<void> startTracking(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> stopTracking(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Stream<TrackingModel> getTrackingStream(String orderId) async* {
    // Mock implementation - simulate real-time updates
    while (true) {
      await Future.delayed(const Duration(seconds: 10));
      
      final tracking = TrackingModel(
        id: 'track_${DateTime.now().millisecondsSinceEpoch}',
        orderId: orderId,
        status: 'out_for_delivery',
        description: 'Your order is on its way to you',
        timestamp: DateTime.now(),
        location: 'On the way',
        latitude: 52.3676 + (DateTime.now().millisecond / 1000000),
        longitude: 4.9041 + (DateTime.now().millisecond / 1000000),
        driverId: 'driver_123',
        driverName: 'John Doe',
        driverPhone: '+1234567890',
        estimatedDeliveryTime: '${15 - (DateTime.now().minute % 15)} minutes',
      );
      
      yield tracking;
    }
  }
}
