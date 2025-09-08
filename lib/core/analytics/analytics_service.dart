import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static AnalyticsService? _instance;
  static AnalyticsService get instance => _instance ??= AnalyticsService._();
  
  AnalyticsService._();

  static const String _analyticsKey = 'analytics_data';
  static const String _eventsKey = 'analytics_events';
  static const int _maxEvents = 1000;

  // Track user events
  static Future<void> trackEvent(String eventName, Map<String, dynamic>? parameters) async {
    try {
      final event = {
        'event': eventName,
        'parameters': parameters ?? {},
        'timestamp': DateTime.now().toIso8601String(),
        'platform': defaultTargetPlatform.name,
      };

      final prefs = await SharedPreferences.getInstance();
      final events = await _getStoredEvents(prefs);
      
      events.add(event);
      
      // Keep only the latest events
      if (events.length > _maxEvents) {
        events.removeRange(0, events.length - _maxEvents);
      }
      
      await prefs.setString(_eventsKey, jsonEncode(events));
      
      debugPrint('Analytics Event: $eventName - $parameters');
    } catch (e) {
      debugPrint('Analytics tracking error: $e');
    }
  }

  // Track screen views
  static Future<void> trackScreenView(String screenName, {Map<String, dynamic>? parameters}) async {
    await trackEvent('screen_view', {
      'screen_name': screenName,
      ...?parameters,
    });
  }

  // Track user actions
  static Future<void> trackUserAction(String action, {Map<String, dynamic>? parameters}) async {
    await trackEvent('user_action', {
      'action': action,
      ...?parameters,
    });
  }

  // Track performance metrics
  static Future<void> trackPerformance(String operation, Duration duration, {Map<String, dynamic>? parameters}) async {
    await trackEvent('performance', {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      ...?parameters,
    });
  }

  // Track errors
  static Future<void> trackError(String error, String? stackTrace, {Map<String, dynamic>? parameters}) async {
    await trackEvent('error', {
      'error': error,
      'stack_trace': stackTrace,
      ...?parameters,
    });
  }

  // Track business metrics
  static Future<void> trackBusinessMetric(String metric, dynamic value, {Map<String, dynamic>? parameters}) async {
    await trackEvent('business_metric', {
      'metric': metric,
      'value': value,
      ...?parameters,
    });
  }

  // Get stored events
  static Future<List<Map<String, dynamic>>> _getStoredEvents(SharedPreferences prefs) async {
    try {
      final eventsJson = prefs.getString(_eventsKey);
      if (eventsJson != null) {
        final List<dynamic> events = jsonDecode(eventsJson);
        return events.cast<Map<String, dynamic>>();
      }
    } catch (e) {
      debugPrint('Error getting stored events: $e');
    }
    return [];
  }

  // Get analytics data
  static Future<Map<String, dynamic>> getAnalyticsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final events = await _getStoredEvents(prefs);
      
      // Calculate metrics
      final totalEvents = events.length;
      final uniqueEvents = events.map((e) => e['event']).toSet().length;
      final screenViews = events.where((e) => e['event'] == 'screen_view').length;
      final userActions = events.where((e) => e['event'] == 'user_action').length;
      final errors = events.where((e) => e['event'] == 'error').length;
      
      // Calculate session duration
      final sessionStart = events.isNotEmpty ? 
        DateTime.parse(events.first['timestamp']) : null;
      final sessionEnd = events.isNotEmpty ? 
        DateTime.parse(events.last['timestamp']) : null;
      final sessionDuration = sessionStart != null && sessionEnd != null ?
        sessionEnd.difference(sessionStart).inMinutes : 0;
      
      return {
        'total_events': totalEvents,
        'unique_events': uniqueEvents,
        'screen_views': screenViews,
        'user_actions': userActions,
        'errors': errors,
        'session_duration_minutes': sessionDuration,
        'events': events,
      };
    } catch (e) {
      debugPrint('Error getting analytics data: $e');
      return {};
    }
  }

  // Clear analytics data
  static Future<void> clearAnalyticsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_eventsKey);
      await prefs.remove(_analyticsKey);
    } catch (e) {
      debugPrint('Error clearing analytics data: $e');
    }
  }

  // Export analytics data
  static Future<String> exportAnalyticsData() async {
    try {
      final data = await getAnalyticsData();
      return jsonEncode(data);
    } catch (e) {
      debugPrint('Error exporting analytics data: $e');
      return '{}';
    }
  }
}

// Performance monitoring
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  static final Map<String, List<Duration>> _durations = {};

  static void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
  }

  static void endTimer(String operation) {
    final startTime = _startTimes[operation];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _durations.putIfAbsent(operation, () => []).add(duration);
      
      // Track performance
      AnalyticsService.trackPerformance(operation, duration);
      
      debugPrint('Performance: $operation took ${duration.inMilliseconds}ms');
      _startTimes.remove(operation);
    }
  }

  static Map<String, dynamic> getPerformanceStats() {
    final stats = <String, dynamic>{};
    
    for (final entry in _durations.entries) {
      final operation = entry.key;
      final durations = entry.value;
      
      if (durations.isNotEmpty) {
        final totalMs = durations.fold(0, (sum, d) => sum + d.inMilliseconds);
        final avgMs = totalMs / durations.length;
        final minMs = durations.map((d) => d.inMilliseconds).reduce((a, b) => a < b ? a : b);
        final maxMs = durations.map((d) => d.inMilliseconds).reduce((a, b) => a > b ? a : b);
        
        stats[operation] = {
          'count': durations.length,
          'total_ms': totalMs,
          'avg_ms': avgMs,
          'min_ms': minMs,
          'max_ms': maxMs,
        };
      }
    }
    
    return stats;
  }

  static void clearStats() {
    _durations.clear();
    _startTimes.clear();
  }
}

// User behavior tracking
class UserBehaviorTracker {
  static final Map<String, int> _screenViewCounts = {};
  static final Map<String, DateTime> _lastScreenView = {};
  static final Map<String, int> _actionCounts = {};

  static void trackScreenView(String screenName) {
    _screenViewCounts[screenName] = (_screenViewCounts[screenName] ?? 0) + 1;
    _lastScreenView[screenName] = DateTime.now();
    
    AnalyticsService.trackScreenView(screenName, parameters: {
      'view_count': _screenViewCounts[screenName],
      'last_viewed': _lastScreenView[screenName]?.toIso8601String(),
    });
  }

  static void trackUserAction(String action) {
    _actionCounts[action] = (_actionCounts[action] ?? 0) + 1;
    
    AnalyticsService.trackUserAction(action, parameters: {
      'action_count': _actionCounts[action],
    });
  }

  static Map<String, dynamic> getUserBehaviorStats() {
    return {
      'screen_views': Map.from(_screenViewCounts),
      'last_screen_views': _lastScreenView.map((k, v) => MapEntry(k, v.toIso8601String())),
      'action_counts': Map.from(_actionCounts),
    };
  }

  static void clearStats() {
    _screenViewCounts.clear();
    _lastScreenView.clear();
    _actionCounts.clear();
  }
}

// Crash reporting
class CrashReporter {
  static void reportError(dynamic error, StackTrace? stackTrace, {Map<String, dynamic>? context}) {
    final errorString = error.toString();
    final stackString = stackTrace?.toString();
    
    AnalyticsService.trackError(errorString, stackString, parameters: {
      'context': context,
      'platform': defaultTargetPlatform.name,
      'timestamp': DateTime.now().toIso8601String(),
    });
    
    debugPrint('Crash reported: $errorString');
    if (stackTrace != null) {
      debugPrint('Stack trace: $stackString');
    }
  }

  static void reportFlutterError(FlutterErrorDetails details) {
    reportError(
      details.exception,
      details.stack,
      context: {
        'library': details.library,
        'context': details.context?.toString(),
      },
    );
  }
}
