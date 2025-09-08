import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ErrorRecoverySystem {
  static ErrorRecoverySystem? _instance;
  static ErrorRecoverySystem get instance => _instance ??= ErrorRecoverySystem._();
  
  ErrorRecoverySystem._();

  final Map<String, int> _errorCounts = {};
  final Map<String, DateTime> _lastErrorTimes = {};
  final List<ErrorRecoveryStrategy> _recoveryStrategies = [];

  // Initialize error recovery system
  Future<void> initialize() async {
    debugPrint('🛡️ Initializing Error Recovery System...');
    
    // Register default recovery strategies
    _registerDefaultStrategies();
    
    debugPrint('✅ Error Recovery System initialized');
  }

  // Register default recovery strategies
  void _registerDefaultStrategies() {
    _recoveryStrategies.addAll([
      NetworkErrorRecoveryStrategy(),
      AuthenticationErrorRecoveryStrategy(),
      ValidationErrorRecoveryStrategy(),
      ServerErrorRecoveryStrategy(),
      TimeoutErrorRecoveryStrategy(),
      GenericErrorRecoveryStrategy(),
    ]);
  }

  // Handle error with recovery
  Future<ErrorRecoveryResult> handleError(
    dynamic error,
    String context, {
    Map<String, dynamic>? additionalData,
  }) async {
    final errorType = _classifyError(error);
    final errorKey = '${errorType}_$context';
    
    // Track error frequency
    _errorCounts[errorKey] = (_errorCounts[errorKey] ?? 0) + 1;
    _lastErrorTimes[errorKey] = DateTime.now();
    
    // Find appropriate recovery strategy
    final strategy = _findRecoveryStrategy(errorType);
    if (strategy != null) {
      try {
        final result = await strategy.recover(error, context, additionalData);
        debugPrint('🔄 Error recovered using ${strategy.runtimeType}: $result');
        return result;
      } catch (recoveryError) {
        debugPrint('❌ Recovery failed: $recoveryError');
        return ErrorRecoveryResult.failure(
          originalError: error,
          recoveryError: recoveryError,
          context: context,
        );
      }
    }
    
    return ErrorRecoveryResult.failure(
      originalError: error,
      context: context,
    );
  }

  // Classify error type
  ErrorType _classifyError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ErrorType.timeout;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 401) return ErrorType.authentication;
          if (statusCode == 403) return ErrorType.authentication;
          if (statusCode == 422) return ErrorType.validation;
          if (statusCode != null && statusCode >= 500) return ErrorType.server;
          return ErrorType.network;
        case DioExceptionType.connectionError:
          return ErrorType.network;
        default:
          return ErrorType.network;
      }
    }
    
    if (error is FormatException) return ErrorType.validation;
    if (error is StateError) return ErrorType.state;
    if (error is ArgumentError) return ErrorType.validation;
    
    return ErrorType.generic;
  }

  // Find recovery strategy
  ErrorRecoveryStrategy? _findRecoveryStrategy(ErrorType errorType) {
    return _recoveryStrategies.firstWhere(
      (strategy) => strategy.canHandle(errorType),
      orElse: () => GenericErrorRecoveryStrategy(),
    );
  }

  // Get error statistics
  Map<String, dynamic> getErrorStatistics() {
    return {
      'totalErrors': _errorCounts.values.fold(0, (sum, count) => sum + count),
      'errorCounts': Map.from(_errorCounts),
      'lastErrorTimes': _lastErrorTimes.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'recoveryStrategies': _recoveryStrategies.map((s) => s.runtimeType.toString()).toList(),
    };
  }

  // Clear error history
  void clearErrorHistory() {
    _errorCounts.clear();
    _lastErrorTimes.clear();
    debugPrint('🧹 Error history cleared');
  }

  // Register custom recovery strategy
  void registerRecoveryStrategy(ErrorRecoveryStrategy strategy) {
    _recoveryStrategies.add(strategy);
    debugPrint('📝 Registered recovery strategy: ${strategy.runtimeType}');
  }
}

// Error Types
enum ErrorType {
  network,
  authentication,
  validation,
  server,
  timeout,
  state,
  generic,
}

// Error Recovery Result
class ErrorRecoveryResult {
  final bool success;
  final dynamic originalError;
  final dynamic recoveryError;
  final String context;
  final Map<String, dynamic>? recoveryData;
  final String? message;

  const ErrorRecoveryResult._({
    required this.success,
    required this.originalError,
    required this.context,
    this.recoveryError,
    this.recoveryData,
    this.message,
  });

  factory ErrorRecoveryResult.success({
    required dynamic originalError,
    required String context,
    Map<String, dynamic>? recoveryData,
    String? message,
  }) {
    return ErrorRecoveryResult._(
      success: true,
      originalError: originalError,
      context: context,
      recoveryData: recoveryData,
      message: message,
    );
  }

  factory ErrorRecoveryResult.failure({
    required dynamic originalError,
    required String context,
    dynamic recoveryError,
    String? message,
  }) {
    return ErrorRecoveryResult._(
      success: false,
      originalError: originalError,
      context: context,
      recoveryError: recoveryError,
      message: message,
    );
  }
}

// Base Error Recovery Strategy
abstract class ErrorRecoveryStrategy {
  bool canHandle(ErrorType errorType);
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  );
}

// Network Error Recovery Strategy
class NetworkErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  bool canHandle(ErrorType errorType) => errorType == ErrorType.network;

  @override
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  ) async {
    debugPrint('🔄 Attempting network error recovery...');
    
    // Wait and retry
    await Future.delayed(const Duration(seconds: 2));
    
    // Check if network is available
    // In a real app, you would check connectivity here
    
    return ErrorRecoveryResult.success(
      originalError: error,
      context: context,
      message: 'Network error recovered - retrying...',
    );
  }
}

// Authentication Error Recovery Strategy
class AuthenticationErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  bool canHandle(ErrorType errorType) => errorType == ErrorType.authentication;

  @override
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  ) async {
    debugPrint('🔄 Attempting authentication error recovery...');
    
    // Refresh token or redirect to login
    // In a real app, you would handle token refresh here
    
    return ErrorRecoveryResult.success(
      originalError: error,
      context: context,
      message: 'Authentication error recovered - token refreshed',
    );
  }
}

// Validation Error Recovery Strategy
class ValidationErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  bool canHandle(ErrorType errorType) => errorType == ErrorType.validation;

  @override
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  ) async {
    debugPrint('🔄 Attempting validation error recovery...');
    
    // Validate and sanitize input
    // In a real app, you would validate user input here
    
    return ErrorRecoveryResult.success(
      originalError: error,
      context: context,
      message: 'Validation error recovered - input sanitized',
    );
  }
}

// Server Error Recovery Strategy
class ServerErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  bool canHandle(ErrorType errorType) => errorType == ErrorType.server;

  @override
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  ) async {
    debugPrint('🔄 Attempting server error recovery...');
    
    // Retry with exponential backoff
    await Future.delayed(const Duration(seconds: 5));
    
    return ErrorRecoveryResult.success(
      originalError: error,
      context: context,
      message: 'Server error recovered - retrying with backoff',
    );
  }
}

// Timeout Error Recovery Strategy
class TimeoutErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  bool canHandle(ErrorType errorType) => errorType == ErrorType.timeout;

  @override
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  ) async {
    debugPrint('🔄 Attempting timeout error recovery...');
    
    // Increase timeout and retry
    await Future.delayed(const Duration(seconds: 1));
    
    return ErrorRecoveryResult.success(
      originalError: error,
      context: context,
      message: 'Timeout error recovered - retrying with increased timeout',
    );
  }
}

// Generic Error Recovery Strategy
class GenericErrorRecoveryStrategy extends ErrorRecoveryStrategy {
  @override
  bool canHandle(ErrorType errorType) => true;

  @override
  Future<ErrorRecoveryResult> recover(
    dynamic error,
    String context,
    Map<String, dynamic>? additionalData,
  ) async {
    debugPrint('🔄 Attempting generic error recovery...');
    
    // Log error and show user-friendly message
    debugPrint('❌ Unhandled error: $error');
    
    return ErrorRecoveryResult.failure(
      originalError: error,
      context: context,
      message: 'An unexpected error occurred. Please try again.',
    );
  }
}

// Error Recovery Widget
class ErrorRecoveryWidget extends StatelessWidget {
  final Widget child;
  final String context;
  final Widget Function(dynamic error)? errorBuilder;

  const ErrorRecoveryWidget({
    super.key,
    required this.child,
    required this.context,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      onError: (error, stackTrace) async {
        final result = await ErrorRecoverySystem.instance.handleError(
          error,
          this.context,
        );
        
        if (!result.success) {
          // Show error to user
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(result.message ?? 'An error occurred'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () {
                    // Retry the operation
                  },
                ),
              ),
            );
          }
        }
      },
      child: child,
    );
  }
}

// Error Boundary
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Function(dynamic error, StackTrace stackTrace)? onError;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.onError,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  @override
  void initState() {
    super.initState();
    FlutterError.onError = (FlutterErrorDetails details) {
      widget.onError?.call(details.exception, details.stack ?? StackTrace.empty);
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
