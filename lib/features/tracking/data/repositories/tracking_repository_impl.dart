import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/tracking_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_datasource.dart';
import '../models/tracking_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TrackingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<TrackingEntity>>> getOrderTracking(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final trackingModels = await remoteDataSource.getOrderTracking(orderId);
        final trackingEntities = trackingModels.map((model) => model.toEntity()).toList();
        return Right(trackingEntities);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, TrackingEntity>> getLatestTracking(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final trackingModel = await remoteDataSource.getLatestTracking(orderId);
        return Right(trackingModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> startTracking(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.startTracking(orderId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> stopTracking(String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.stopTracking(orderId);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Stream<TrackingEntity> getTrackingStream(String orderId) {
    return remoteDataSource.getTrackingStream(orderId).map((model) => model.toEntity());
  }
}
