import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileState {
  final UserEntity user;

  const ProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class ProfileImageUpdated extends ProfileState {
  final String imageUrl;

  const ProfileImageUpdated({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class PasswordUpdated extends ProfileState {
  const PasswordUpdated();
}

class PreferencesUpdated extends ProfileState {
  final UserEntity user;

  const PreferencesUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AddressUpdated extends ProfileState {
  final UserEntity user;

  const AddressUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AccountDeleted extends ProfileState {
  const AccountDeleted();
}
