import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class AppHealthMonitor {
  static AppHealthMonitor? _instance;
  static AppHealthMonitor get instance => _instance ??= AppHealthMonitor._();
  
  AppHealthMonitor._();

  Timer? _healthCheckTimer;
  final Map<String, dynamic> _healthMetrics = {};
  final List<HealthCheck> _healthChecks = [];
  bool _isMonitoring = false;

  // Health status
  AppHealthStatus _currentStatus = AppHealthStatus.healthy;
  final StreamController<AppHealthStatus> _statusController = StreamController<AppHealthStatus>.broadcast();

  // Initialize health monitoring
  Future<void> initialize() async {
    debugPrint('🏥 Initializing App Health Monitor...');
    
    // Register default health checks
    _registerDefaultHealthChecks();
    
    // Start monitoring
    startMonitoring();
    
    debugPrint('✅ App Health Monitor initialized');
  }

  // Register default health checks
  void _registerDefaultHealthChecks() {
    _healthChecks.addAll([
      MemoryHealthCheck(),
      NetworkHealthCheck(),
      PerformanceHealthCheck(),
      DatabaseHealthCheck(),
      ApiHealthCheck(),
      StorageHealthCheck(),
    ]);
  }

  // Start health monitoring
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _healthCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _performHealthCheck(),
    );
    
    debugPrint('🏥 Health monitoring started');
  }

  // Stop health monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _healthCheckTimer?.cancel();
    _healthCheckTimer = null;
    
    debugPrint('🏥 Health monitoring stopped');
  }

  // Perform health check
  Future<void> _performHealthCheck() async {
    final results = <String, HealthCheckResult>{};
    
    for (final check in _healthChecks) {
      try {
        final result = await check.check();
        results[check.name] = result;
      } catch (e) {
        results[check.name] = HealthCheckResult.failure(
          check.name,
          'Health check failed: $e',
        );
      }
    }
    
    // Update health metrics
    _updateHealthMetrics(results);
    
    // Determine overall health status
    final newStatus = _determineHealthStatus(results);
    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
    }
    
    debugPrint('🏥 Health check completed: $_currentStatus');
  }

  // Update health metrics
  void _updateHealthMetrics(Map<String, HealthCheckResult> results) {
    _healthMetrics['lastCheck'] = DateTime.now().toIso8601String();
    _healthMetrics['results'] = results.map(
      (key, value) => MapEntry(key, {
        'status': value.status.name,
        'message': value.message,
        'details': value.details,
        'timestamp': value.timestamp.toIso8601String(),
      }),
    );
  }

  // Determine overall health status
  AppHealthStatus _determineHealthStatus(Map<String, HealthCheckResult> results) {
    final criticalFailures = results.values.where(
      (result) => result.status == HealthStatus.critical,
    ).length;
    
    final warnings = results.values.where(
      (result) => result.status == HealthStatus.warning,
    ).length;
    
    if (criticalFailures > 0) {
      return AppHealthStatus.critical;
    } else if (warnings > 2) {
      return AppHealthStatus.warning;
    } else {
      return AppHealthStatus.healthy;
    }
  }

  // Get current health status
  AppHealthStatus get currentStatus => _currentStatus;

  // Get health status stream
  Stream<AppHealthStatus> get statusStream => _statusController.stream;

  // Get health metrics
  Map<String, dynamic> get healthMetrics => Map.from(_healthMetrics);

  // Get detailed health report
  Map<String, dynamic> getDetailedHealthReport() {
    return {
      'overallStatus': _currentStatus.name,
      'isMonitoring': _isMonitoring,
      'lastCheck': _healthMetrics['lastCheck'],
      'healthChecks': _healthMetrics['results'],
      'summary': _generateHealthSummary(),
    };
  }

  // Generate health summary
  Map<String, dynamic> _generateHealthSummary() {
    final results = _healthMetrics['results'] as Map<String, dynamic>? ?? {};
    final totalChecks = results.length;
    final healthyChecks = results.values.where(
      (result) => result['status'] == 'healthy',
    ).length;
    final warningChecks = results.values.where(
      (result) => result['status'] == 'warning',
    ).length;
    final criticalChecks = results.values.where(
      (result) => result['status'] == 'critical',
    ).length;

    return {
      'totalChecks': totalChecks,
      'healthy': healthyChecks,
      'warnings': warningChecks,
      'critical': criticalChecks,
      'healthScore': totalChecks > 0 ? (healthyChecks / totalChecks * 100).round() : 0,
    };
  }

  // Register custom health check
  void registerHealthCheck(HealthCheck healthCheck) {
    _healthChecks.add(healthCheck);
    debugPrint('📝 Registered health check: ${healthCheck.name}');
  }

  // Force health check
  Future<void> forceHealthCheck() async {
    await _performHealthCheck();
  }

  // Dispose
  void dispose() {
    stopMonitoring();
    _statusController.close();
  }
}

// Health Status Enums
enum AppHealthStatus {
  healthy,
  warning,
  critical,
  unknown,
}

enum HealthStatus {
  healthy,
  warning,
  critical,
  unknown,
}

// Health Check Result
class HealthCheckResult {
  final String name;
  final HealthStatus status;
  final String message;
  final Map<String, dynamic>? details;
  final DateTime timestamp;

  const HealthCheckResult({
    required this.name,
    required this.status,
    required this.message,
    this.details,
    required this.timestamp,
  });

  factory HealthCheckResult.healthy(String name, String message, {Map<String, dynamic>? details}) {
    return HealthCheckResult(
      name: name,
      status: HealthStatus.healthy,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  factory HealthCheckResult.warning(String name, String message, {Map<String, dynamic>? details}) {
    return HealthCheckResult(
      name: name,
      status: HealthStatus.warning,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  factory HealthCheckResult.critical(String name, String message, {Map<String, dynamic>? details}) {
    return HealthCheckResult(
      name: name,
      status: HealthStatus.critical,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  factory HealthCheckResult.failure(String name, String message) {
    return HealthCheckResult(
      name: name,
      status: HealthStatus.critical,
      message: message,
      timestamp: DateTime.now(),
    );
  }
}

// Base Health Check
abstract class HealthCheck {
  String get name;
  Future<HealthCheckResult> check();
}

// Memory Health Check
class MemoryHealthCheck extends HealthCheck {
  @override
  String get name => 'memory';

  @override
  Future<HealthCheckResult> check() async {
    try {
      // Simulate memory check
      final memoryUsage = _getMemoryUsage();
      final memoryThreshold = 100 * 1024 * 1024; // 100MB
      
      if (memoryUsage > memoryThreshold * 2) {
        return HealthCheckResult.critical(
          name,
          'High memory usage detected',
          details: {'usage': memoryUsage, 'threshold': memoryThreshold},
        );
      } else if (memoryUsage > memoryThreshold) {
        return HealthCheckResult.warning(
          name,
          'Memory usage is high',
          details: {'usage': memoryUsage, 'threshold': memoryThreshold},
        );
      } else {
        return HealthCheckResult.healthy(
          name,
          'Memory usage is normal',
          details: {'usage': memoryUsage, 'threshold': memoryThreshold},
        );
      }
    } catch (e) {
      return HealthCheckResult.failure(name, 'Memory check failed: $e');
    }
  }

  int _getMemoryUsage() {
    // Mock memory usage calculation
    return 50 * 1024 * 1024; // 50MB
  }
}

// Network Health Check
class NetworkHealthCheck extends HealthCheck {
  @override
  String get name => 'network';

  @override
  Future<HealthCheckResult> check() async {
    try {
      // Check network connectivity
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return HealthCheckResult.healthy(
          name,
          'Network connectivity is good',
        );
      } else {
        return HealthCheckResult.critical(
          name,
          'No network connectivity',
        );
      }
    } catch (e) {
      return HealthCheckResult.critical(
        name,
        'Network check failed: $e',
      );
    }
  }
}

// Performance Health Check
class PerformanceHealthCheck extends HealthCheck {
  @override
  String get name => 'performance';

  @override
  Future<HealthCheckResult> check() async {
    try {
      // Check app performance metrics
      final frameRate = _getFrameRate();
      final responseTime = _getResponseTime();
      
      if (frameRate < 30) {
        return HealthCheckResult.critical(
          name,
          'Low frame rate detected',
          details: {'frameRate': frameRate},
        );
      } else if (frameRate < 50) {
        return HealthCheckResult.warning(
          name,
          'Frame rate is below optimal',
          details: {'frameRate': frameRate},
        );
      } else if (responseTime > 1000) {
        return HealthCheckResult.warning(
          name,
          'High response time detected',
          details: {'responseTime': responseTime},
        );
      } else {
        return HealthCheckResult.healthy(
          name,
          'Performance is good',
          details: {'frameRate': frameRate, 'responseTime': responseTime},
        );
      }
    } catch (e) {
      return HealthCheckResult.failure(name, 'Performance check failed: $e');
    }
  }

  double _getFrameRate() {
    // Mock frame rate calculation
    return 60.0;
  }

  int _getResponseTime() {
    // Mock response time calculation
    return 100; // ms
  }
}

// Database Health Check
class DatabaseHealthCheck extends HealthCheck {
  @override
  String get name => 'database';

  @override
  Future<HealthCheckResult> check() async {
    try {
      // Check database connectivity and performance
      final startTime = DateTime.now();
      // Simulate database operation
      await Future.delayed(const Duration(milliseconds: 10));
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds;
      
      if (responseTime > 500) {
        return HealthCheckResult.warning(
          name,
          'Database response time is slow',
          details: {'responseTime': responseTime},
        );
      } else {
        return HealthCheckResult.healthy(
          name,
          'Database is performing well',
          details: {'responseTime': responseTime},
        );
      }
    } catch (e) {
      return HealthCheckResult.critical(
        name,
        'Database check failed: $e',
      );
    }
  }
}

// API Health Check
class ApiHealthCheck extends HealthCheck {
  @override
  String get name => 'api';

  @override
  Future<HealthCheckResult> check() async {
    try {
      // Check API endpoint health
      final startTime = DateTime.now();
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 50));
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds;
      
      if (responseTime > 2000) {
        return HealthCheckResult.critical(
          name,
          'API response time is very slow',
          details: {'responseTime': responseTime},
        );
      } else if (responseTime > 1000) {
        return HealthCheckResult.warning(
          name,
          'API response time is slow',
          details: {'responseTime': responseTime},
        );
      } else {
        return HealthCheckResult.healthy(
          name,
          'API is responding well',
          details: {'responseTime': responseTime},
        );
      }
    } catch (e) {
      return HealthCheckResult.critical(
        name,
        'API check failed: $e',
      );
    }
  }
}

// Storage Health Check
class StorageHealthCheck extends HealthCheck {
  @override
  String get name => 'storage';

  @override
  Future<HealthCheckResult> check() async {
    try {
      // Check storage availability and performance
      final storageUsage = _getStorageUsage();
      final storageThreshold = 1000 * 1024 * 1024; // 1GB
      
      if (storageUsage > storageThreshold * 0.9) {
        return HealthCheckResult.critical(
          name,
          'Storage is almost full',
          details: {'usage': storageUsage, 'threshold': storageThreshold},
        );
      } else if (storageUsage > storageThreshold * 0.7) {
        return HealthCheckResult.warning(
          name,
          'Storage usage is high',
          details: {'usage': storageUsage, 'threshold': storageThreshold},
        );
      } else {
        return HealthCheckResult.healthy(
          name,
          'Storage usage is normal',
          details: {'usage': storageUsage, 'threshold': storageThreshold},
        );
      }
    } catch (e) {
      return HealthCheckResult.failure(name, 'Storage check failed: $e');
    }
  }

  int _getStorageUsage() {
    // Mock storage usage calculation
    return 500 * 1024 * 1024; // 500MB
  }
}
