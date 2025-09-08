import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.getCurrentUser();
        return Right(userModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = UserModel.fromEntity(user);
        final updatedUser = await remoteDataSource.updateProfile(userModel);
        return Right(updatedUser.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfileImage(String imageUrl) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser = await remoteDataSource.updateProfileImage(imageUrl);
        return Right(updatedUser.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updatePassword(String currentPassword, String newPassword) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser = await remoteDataSource.updatePassword(currentPassword, newPassword);
        return Right(updatedUser.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updatePreferences({
    List<String>? dietaryPreferences,
    List<String>? allergies,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser = await remoteDataSource.updatePreferences(
          dietaryPreferences: dietaryPreferences,
          allergies: allergies,
        );
        return Right(updatedUser.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateAddress({
    String? address,
    String? city,
    String? postalCode,
    String? country,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedUser = await remoteDataSource.updateAddress(
          address: address,
          city: city,
          postalCode: postalCode,
          country: country,
        );
        return Right(updatedUser.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
