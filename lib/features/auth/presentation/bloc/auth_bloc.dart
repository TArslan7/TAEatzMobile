import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../shared/models/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<RefreshTokenRequested>(_onRefreshTokenRequested);
    on<CheckAuthStatusRequested>(_onCheckAuthStatusRequested);
  }

  void _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) {
    emit(const AuthLoading());
    // TODO: Check if user is already authenticated
    emit(const AuthUnauthenticated());
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implement actual login logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock success response
      emit(AuthSuccess(
        user: UserModel(
          id: '1',
          email: 'user@example.com',
          firstName: 'John',
          lastName: 'Doe',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: true,
          isPhoneVerified: false,
          addresses: [],
          preferences: UserPreferencesModel(
            language: 'en',
            currency: 'EUR',
            notificationsEnabled: true,
            locationTrackingEnabled: true,
            marketingEmailsEnabled: false,
            theme: 'light',
            defaultPaymentMethod: 'card',
          ),
        ),
        token: 'mock_token_123',
      ));
    } catch (e) {
      emit(AuthFailure(message: 'Login failed: ${e.toString()}'));
    }
  }

  void _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implement actual registration logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock success response
      emit(AuthSuccess(
        user: UserModel(
          id: '1',
          email: event.email,
          firstName: event.firstName,
          lastName: event.lastName,
          phoneNumber: event.phoneNumber,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: false,
          isPhoneVerified: false,
          addresses: [],
          preferences: UserPreferencesModel(
            language: 'en',
            currency: 'EUR',
            notificationsEnabled: true,
            locationTrackingEnabled: true,
            marketingEmailsEnabled: false,
            theme: 'light',
            defaultPaymentMethod: 'card',
          ),
        ),
        token: 'mock_token_123',
      ));
    } catch (e) {
      emit(AuthFailure(message: 'Registration failed: ${e.toString()}'));
    }
  }

  void _onGoogleLoginRequested(GoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implement Google login logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Mock success response
      emit(AuthSuccess(
        user: UserModel(
          id: '1',
          email: 'user@gmail.com',
          firstName: 'Google',
          lastName: 'User',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isEmailVerified: true,
          isPhoneVerified: false,
          addresses: [],
          preferences: UserPreferencesModel(
            language: 'en',
            currency: 'EUR',
            notificationsEnabled: true,
            locationTrackingEnabled: true,
            marketingEmailsEnabled: false,
            theme: 'light',
            defaultPaymentMethod: 'card',
          ),
        ),
        token: 'mock_google_token_123',
      ));
    } catch (e) {
      emit(AuthFailure(message: 'Google login failed: ${e.toString()}'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implement logout logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: 'Logout failed: ${e.toString()}'));
    }
  }

  void _onForgotPasswordRequested(ForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implement forgot password logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      emit(const ForgotPasswordSuccess(
        message: 'Password reset email sent successfully',
      ));
    } catch (e) {
      emit(ForgotPasswordFailure(message: 'Failed to send reset email: ${e.toString()}'));
    }
  }

  void _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Implement reset password logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      emit(const ResetPasswordSuccess(
        message: 'Password reset successfully',
      ));
    } catch (e) {
      emit(ResetPasswordFailure(message: 'Failed to reset password: ${e.toString()}'));
    }
  }

  void _onRefreshTokenRequested(RefreshTokenRequested event, Emitter<AuthState> emit) async {
    try {
      // TODO: Implement token refresh logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Mock success - keep current state
    } catch (e) {
      emit(AuthFailure(message: 'Token refresh failed: ${e.toString()}'));
    }
  }

  void _onCheckAuthStatusRequested(CheckAuthStatusRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    
    try {
      // TODO: Check if user is authenticated
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // For now, always return unauthenticated
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthFailure(message: 'Auth check failed: ${e.toString()}'));
    }
  }
}
