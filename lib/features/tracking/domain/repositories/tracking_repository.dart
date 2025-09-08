import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/tracking_entity.dart';

abstract class TrackingRepository {
  Future<Either<Failure, List<TrackingEntity>>> getOrderTracking(String orderId);
  Future<Either<Failure, TrackingEntity>> getLatestTracking(String orderId);
  Future<Either<Failure, void>> startTracking(String orderId);
  Future<Either<Failure, void>> stopTracking(String orderId);
  Stream<TrackingEntity> getTrackingStream(String orderId);
}
