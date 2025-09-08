import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({
    required this.repository,
  }) : super(const ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<UpdatePassword>(_onUpdatePassword);
    on<UpdatePreferences>(_onUpdatePreferences);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAccount>(_onDeleteAccount);
    on<RefreshProfile>(_onRefreshProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.getCurrentUser();
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileLoaded(user: user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.updateProfile(event.user);
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileUpdated(user: user)),
    );
  }

  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.updateProfileImage(event.imageUrl);
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileImageUpdated(imageUrl: event.imageUrl)),
    );
  }

  Future<void> _onUpdatePassword(
    UpdatePassword event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.updatePassword(event.currentPassword, event.newPassword);
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(const PasswordUpdated()),
    );
  }

  Future<void> _onUpdatePreferences(
    UpdatePreferences event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.updatePreferences(
      dietaryPreferences: event.dietaryPreferences,
      allergies: event.allergies,
    );
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(PreferencesUpdated(user: user)),
    );
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.updateAddress(
      address: event.address,
      city: event.city,
      postalCode: event.postalCode,
      country: event.country,
    );
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(AddressUpdated(user: user)),
    );
  }

  Future<void> _onDeleteAccount(
    DeleteAccount event,
    Emitter<ProfileState> emit,
  ) async {
    emit(const ProfileLoading());
    
    final result = await repository.deleteAccount();
    
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(const AccountDeleted()),
    );
  }

  Future<void> _onRefreshProfile(
    RefreshProfile event,
    Emitter<ProfileState> emit,
  ) async {
    add(const LoadProfile());
  }
}
