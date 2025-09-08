import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user);
  Future<Either<Failure, UserEntity>> updateProfileImage(String imageUrl);
  Future<Either<Failure, UserEntity>> updatePassword(String currentPassword, String newPassword);
  Future<Either<Failure, void>> deleteAccount();
  Future<Either<Failure, UserEntity>> updatePreferences({
    List<String>? dietaryPreferences,
    List<String>? allergies,
  });
  Future<Either<Failure, UserEntity>> updateAddress({
    String? address,
    String? city,
    String? postalCode,
    String? country,
  });
}
