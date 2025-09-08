import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getCurrentUser();
  Future<UserModel> updateProfile(UserModel user);
  Future<UserModel> updateProfileImage(String imageUrl);
  Future<UserModel> updatePassword(String currentPassword, String newPassword);
  Future<void> deleteAccount();
  Future<UserModel> updatePreferences({
    List<String>? dietaryPreferences,
    List<String>? allergies,
  });
  Future<UserModel> updateAddress({
    String? address,
    String? city,
    String? postalCode,
    String? country,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<UserModel> getCurrentUser() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return UserModel(
      id: 'user_123',
      email: 'john.doe@example.com',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1234567890',
      profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      dateOfBirth: DateTime(1990, 5, 15),
      address: '123 Main Street',
      city: 'Amsterdam',
      postalCode: '1012 AB',
      country: 'Netherlands',
      dietaryPreferences: ['Vegetarian', 'Gluten-Free'],
      allergies: ['Nuts', 'Dairy'],
      isEmailVerified: true,
      isPhoneVerified: true,
      createdAt: DateTime(2023, 1, 1),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return user.copyWith(
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> updateProfileImage(String imageUrl) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final currentUser = await getCurrentUser();
    return currentUser.copyWith(
      profileImageUrl: imageUrl,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> updatePassword(String currentPassword, String newPassword) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final currentUser = await getCurrentUser();
    return currentUser.copyWith(
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteAccount() async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<UserModel> updatePreferences({
    List<String>? dietaryPreferences,
    List<String>? allergies,
  }) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final currentUser = await getCurrentUser();
    return currentUser.copyWith(
      dietaryPreferences: dietaryPreferences ?? currentUser.dietaryPreferences,
      allergies: allergies ?? currentUser.allergies,
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserModel> updateAddress({
    String? address,
    String? city,
    String? postalCode,
    String? country,
  }) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final currentUser = await getCurrentUser();
    return currentUser.copyWith(
      address: address ?? currentUser.address,
      city: city ?? currentUser.city,
      postalCode: postalCode ?? currentUser.postalCode,
      country: country ?? currentUser.country,
      updatedAt: DateTime.now(),
    );
  }
}
