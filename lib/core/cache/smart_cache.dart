import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SmartCache {
  static const String _cachePrefix = 'smart_cache_';
  static const Duration _defaultExpiry = Duration(hours: 24);
  
  // Cache configuration
  static const Map<String, Duration> _cacheExpiry = {
    'restaurants': Duration(hours: 2),
    'menu': Duration(hours: 1),
    'orders': Duration(minutes: 30),
    'profile': Duration(hours: 6),
    'search': Duration(minutes: 15),
  };

  // Get cached data with automatic expiry
  static Future<T?> get<T>(String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      final cachedData = prefs.getString(cacheKey);
      
      if (cachedData == null) return null;
      
      final data = jsonDecode(cachedData);
      final timestamp = DateTime.parse(data['timestamp']);
      final expiry = _cacheExpiry[key.split('_').first] ?? _defaultExpiry;
      
      // Check if cache is expired
      if (DateTime.now().difference(timestamp) > expiry) {
        await remove(key);
        return null;
      }
      
      return fromJson(data['data']);
    } catch (e) {
      debugPrint('Cache get error: $e');
      return null;
    }
  }

  // Set cached data with timestamp
  static Future<void> set<T>(String key, T data, Map<String, dynamic> Function(T) toJson) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      final cacheData = {
        'data': toJson(data),
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      await prefs.setString(cacheKey, jsonEncode(cacheData));
    } catch (e) {
      debugPrint('Cache set error: $e');
    }
  }

  // Remove specific cache entry
  static Future<void> remove(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      await prefs.remove(cacheKey);
    } catch (e) {
      debugPrint('Cache remove error: $e');
    }
  }

  // Clear all cache
  static Future<void> clear() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
      for (final key in keys) {
        await prefs.remove(key);
      }
    } catch (e) {
      debugPrint('Cache clear error: $e');
    }
  }

  // Get cache size
  static Future<int> getCacheSize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getKeys().where((key) => key.startsWith(_cachePrefix)).length;
    } catch (e) {
      debugPrint('Cache size error: $e');
      return 0;
    }
  }

  // Preload critical data
  static Future<void> preloadCriticalData() async {
    // This would preload essential data like user profile, cart, etc.
    debugPrint('Preloading critical data...');
  }
}

// Hive-based cache for complex objects
class HiveCache {
  static const String _boxName = 'app_cache';
  static Box? _box;

  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static Future<void> put(String key, dynamic value) async {
    await _box?.put(key, value);
  }

  static T? get<T>(String key) {
    return _box?.get(key);
  }

  static Future<void> delete(String key) async {
    await _box?.delete(key);
  }

  static Future<void> clear() async {
    await _box?.clear();
  }

  static Future<void> close() async {
    await _box?.close();
  }
}

// Cache statistics
class CacheStats {
  static int _hits = 0;
  static int _misses = 0;

  static void recordHit() => _hits++;
  static void recordMiss() => _misses++;

  static double get hitRate => _hits / (_hits + _misses);
  static int get totalRequests => _hits + _misses;

  static void reset() {
    _hits = 0;
    _misses = 0;
  }
}
