import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:io';

class PerformanceMonitor {
  static PerformanceMonitor? _instance;
  static PerformanceMonitor get instance => _instance ??= PerformanceMonitor._();
  
  PerformanceMonitor._();

  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<Duration>> _measurements = {};
  final List<PerformanceMetric> _metrics = [];
  Timer? _monitoringTimer;
  bool _isMonitoring = false;

  // Start monitoring
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _collectMetrics();
    });
    
    debugPrint('Performance monitoring started');
  }

  // Stop monitoring
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    
    debugPrint('Performance monitoring stopped');
  }

  // Start timing
  void startTimer(String name) {
    _timers[name] = Stopwatch()..start();
  }

  // Stop timing
  Duration? stopTimer(String name) {
    final timer = _timers.remove(name);
    if (timer == null) return null;
    
    timer.stop();
    final duration = timer.elapsed;
    
    _measurements.putIfAbsent(name, () => []).add(duration);
    
    debugPrint('Timer $name: ${duration.inMilliseconds}ms');
    return duration;
  }

  // Measure function execution time
  Future<T> measure<T>(String name, Future<T> Function() function) async {
    startTimer(name);
    try {
      final result = await function();
      return result;
    } finally {
      stopTimer(name);
    }
  }

  // Measure synchronous function execution time
  T measureSync<T>(String name, T Function() function) {
    startTimer(name);
    try {
      final result = function();
      return result;
    } finally {
      stopTimer(name);
    }
  }

  // Collect performance metrics
  void _collectMetrics() {
    if (!_isMonitoring) return;

    // Memory usage
    final memoryUsage = _getMemoryUsage();
    _addMetric('memory_usage', memoryUsage);

    // CPU usage
    final cpuUsage = _getCPUUsage();
    _addMetric('cpu_usage', cpuUsage);

    // Frame rate
    final frameRate = _getFrameRate();
    _addMetric('frame_rate', frameRate);

    // App state
    final appState = _getAppState();
    _addMetric('app_state', appState);

    // Network status
    final networkStatus = _getNetworkStatus();
    _addMetric('network_status', networkStatus);
  }

  // Get memory usage
  double _getMemoryUsage() {
    try {
      // This is a simplified implementation
      // In production, use proper memory monitoring
      return 0.0;
    } catch (e) {
      debugPrint('Failed to get memory usage: $e');
      return 0.0;
    }
  }

  // Get CPU usage
  double _getCPUUsage() {
    try {
      // This is a simplified implementation
      // In production, use proper CPU monitoring
      return 0.0;
    } catch (e) {
      debugPrint('Failed to get CPU usage: $e');
      return 0.0;
    }
  }

  // Get frame rate
  double _getFrameRate() {
    try {
      // This is a simplified implementation
      // In production, use proper frame rate monitoring
      return 60.0;
    } catch (e) {
      debugPrint('Failed to get frame rate: $e');
      return 0.0;
    }
  }

  // Get app state
  String _getAppState() {
    try {
      // This is a simplified implementation
      // In production, use proper app state monitoring
      return 'active';
    } catch (e) {
      debugPrint('Failed to get app state: $e');
      return 'unknown';
    }
  }

  // Get network status
  String _getNetworkStatus() {
    try {
      // This is a simplified implementation
      // In production, use proper network monitoring
      return 'connected';
    } catch (e) {
      debugPrint('Failed to get network status: $e');
      return 'unknown';
    }
  }

  // Add performance metric
  void _addMetric(String name, dynamic value) {
    _metrics.add(PerformanceMetric(
      name: name,
      value: value,
      timestamp: DateTime.now(),
    ));
  }

  // Get performance report
  PerformanceReport getPerformanceReport() {
    final now = DateTime.now();
    final lastHour = now.subtract(const Duration(hours: 1));
    
    final recentMetrics = _metrics.where((m) => m.timestamp.isAfter(lastHour)).toList();
    
    return PerformanceReport(
      timestamp: now,
      metrics: recentMetrics,
      averageResponseTime: _getAverageResponseTime(),
      memoryUsage: _getAverageMemoryUsage(),
      cpuUsage: _getAverageCPUUsage(),
      frameRate: _getAverageFrameRate(),
      errorCount: _getErrorCount(),
      recommendations: _getRecommendations(),
    );
  }

  // Get average response time
  Duration _getAverageResponseTime() {
    final responseTimes = _measurements['response_time'] ?? [];
    if (responseTimes.isEmpty) return Duration.zero;
    
    final total = responseTimes.fold<Duration>(
      Duration.zero,
      (sum, duration) => sum + duration,
    );
    
    return Duration(
      microseconds: total.inMicroseconds ~/ responseTimes.length,
    );
  }

  // Get average memory usage
  double _getAverageMemoryUsage() {
    final memoryMetrics = _metrics.where((m) => m.name == 'memory_usage').toList();
    if (memoryMetrics.isEmpty) return 0.0;
    
    final total = memoryMetrics.fold<double>(
      0.0,
      (sum, metric) => sum + (metric.value as double),
    );
    
    return total / memoryMetrics.length;
  }

  // Get average CPU usage
  double _getAverageCPUUsage() {
    final cpuMetrics = _metrics.where((m) => m.name == 'cpu_usage').toList();
    if (cpuMetrics.isEmpty) return 0.0;
    
    final total = cpuMetrics.fold<double>(
      0.0,
      (sum, metric) => sum + (metric.value as double),
    );
    
    return total / cpuMetrics.length;
  }

  // Get average frame rate
  double _getAverageFrameRate() {
    final frameRateMetrics = _metrics.where((m) => m.name == 'frame_rate').toList();
    if (frameRateMetrics.isEmpty) return 0.0;
    
    final total = frameRateMetrics.fold<double>(
      0.0,
      (sum, metric) => sum + (metric.value as double),
    );
    
    return total / frameRateMetrics.length;
  }

  // Get error count
  int _getErrorCount() {
    return _metrics.where((m) => m.name == 'error').length;
  }

  // Get performance recommendations
  List<String> _getRecommendations() {
    final recommendations = <String>[];
    
    final averageResponseTime = _getAverageResponseTime();
    if (averageResponseTime.inMilliseconds > 1000) {
      recommendations.add('Consider optimizing slow operations');
    }
    
    final averageMemoryUsage = _getAverageMemoryUsage();
    if (averageMemoryUsage > 100) {
      recommendations.add('Consider optimizing memory usage');
    }
    
    final averageFrameRate = _getAverageFrameRate();
    if (averageFrameRate < 30) {
      recommendations.add('Consider optimizing rendering performance');
    }
    
    final errorCount = _getErrorCount();
    if (errorCount > 10) {
      recommendations.add('Consider improving error handling');
    }
    
    return recommendations;
  }

  // Clear old metrics
  void clearOldMetrics({Duration maxAge = const Duration(hours: 24)}) {
    final cutoff = DateTime.now().subtract(maxAge);
    _metrics.removeWhere((m) => m.timestamp.isBefore(cutoff));
  }

  // Get metrics by name
  List<PerformanceMetric> getMetricsByName(String name) {
    return _metrics.where((m) => m.name == name).toList();
  }

  // Get metrics by time range
  List<PerformanceMetric> getMetricsByTimeRange(DateTime start, DateTime end) {
    return _metrics.where((m) => 
      m.timestamp.isAfter(start) && m.timestamp.isBefore(end)
    ).toList();
  }

  // Export metrics
  Map<String, dynamic> exportMetrics() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'metrics': _metrics.map((m) => m.toJson()).toList(),
      'measurements': _measurements.map((k, v) => MapEntry(k, v.map((d) => d.inMilliseconds).toList())),
    };
  }
}

// Performance Metric Class
class PerformanceMetric {
  final String name;
  final dynamic value;
  final DateTime timestamp;

  const PerformanceMetric({
    required this.name,
    required this.value,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

// Performance Report Class
class PerformanceReport {
  final DateTime timestamp;
  final List<PerformanceMetric> metrics;
  final Duration averageResponseTime;
  final double memoryUsage;
  final double cpuUsage;
  final double frameRate;
  final int errorCount;
  final List<String> recommendations;

  const PerformanceReport({
    required this.timestamp,
    required this.metrics,
    required this.averageResponseTime,
    required this.memoryUsage,
    required this.cpuUsage,
    required this.frameRate,
    required this.errorCount,
    required this.recommendations,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'metrics': metrics.map((m) => m.toJson()).toList(),
      'average_response_time': averageResponseTime.inMilliseconds,
      'memory_usage': memoryUsage,
      'cpu_usage': cpuUsage,
      'frame_rate': frameRate,
      'error_count': errorCount,
      'recommendations': recommendations,
    };
  }
}

// Performance Constants
class PerformanceConstants {
  static const Duration defaultMonitoringInterval = Duration(seconds: 1);
  static const Duration defaultMetricRetention = Duration(hours: 24);
  static const double maxMemoryUsageMB = 100.0;
  static const double maxCPUUsagePercent = 80.0;
  static const double minFrameRate = 30.0;
  static const Duration maxResponseTime = Duration(milliseconds: 1000);
}

// Performance Enums
enum PerformanceLevel {
  excellent,
  good,
  fair,
  poor,
  critical,
}

enum MetricType {
  memory,
  cpu,
  frameRate,
  responseTime,
  error,
  network,
  battery,
}
