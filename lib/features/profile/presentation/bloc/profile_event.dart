import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  const LoadProfile();
}

class UpdateProfile extends ProfileEvent {
  final UserEntity user;

  const UpdateProfile({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateProfileImage extends ProfileEvent {
  final String imageUrl;

  const UpdateProfileImage({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class UpdatePassword extends ProfileEvent {
  final String currentPassword;
  final String newPassword;

  const UpdatePassword({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class UpdatePreferences extends ProfileEvent {
  final List<String>? dietaryPreferences;
  final List<String>? allergies;

  const UpdatePreferences({
    this.dietaryPreferences,
    this.allergies,
  });

  @override
  List<Object?> get props => [dietaryPreferences, allergies];
}

class UpdateAddress extends ProfileEvent {
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;

  const UpdateAddress({
    this.address,
    this.city,
    this.postalCode,
    this.country,
  });

  @override
  List<Object?> get props => [address, city, postalCode, country];
}

class DeleteAccount extends ProfileEvent {
  const DeleteAccount();
}

class RefreshProfile extends ProfileEvent {
  const RefreshProfile();
}
