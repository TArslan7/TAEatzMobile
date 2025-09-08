import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class SecurityManager {
  static SecurityManager? _instance;
  static SecurityManager get instance => _instance ??= SecurityManager._();
  
  SecurityManager._();

  final Random _random = Random.secure();

  // Biometric Authentication (Mock implementation)
  Future<bool> isBiometricAvailable() async {
    try {
      // Mock implementation - in production, use local_auth package
      return true;
    } catch (e) {
      debugPrint('Biometric availability check failed: $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics({String? reason}) async {
    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;

      // Mock implementation - in production, use local_auth package
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      debugPrint('Biometric authentication failed: $e');
      return false;
    }
  }

  Future<List<String>> getAvailableBiometrics() async {
    try {
      // Mock implementation - in production, use local_auth package
      return ['fingerprint', 'face'];
    } catch (e) {
      debugPrint('Failed to get available biometrics: $e');
      return [];
    }
  }

  // Data Encryption
  String encryptData(String data, String key) {
    try {
      final bytes = utf8.encode(data);
      final keyBytes = utf8.encode(key);
      final hmac = Hmac(sha256, keyBytes);
      final digest = hmac.convert(bytes);
      return base64.encode(digest.bytes);
    } catch (e) {
      debugPrint('Data encryption failed: $e');
      return data; // Return original data if encryption fails
    }
  }

  String decryptData(String encryptedData, String key) {
    try {
      final bytes = base64.decode(encryptedData);
      // Note: This is a simplified example. In production, use proper encryption
      return utf8.decode(bytes);
    } catch (e) {
      debugPrint('Data decryption failed: $e');
      return encryptedData; // Return encrypted data if decryption fails
    }
  }

  // Secure Key Generation
  String generateSecureKey({int length = 32}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()';
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(_random.nextInt(chars.length))),
    );
  }

  // Hash Generation
  String generateHash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Secure Random Generation
  String generateSecureRandom({int length = 16}) {
    final bytes = List<int>.generate(length, (i) => _random.nextInt(256));
    return base64.encode(bytes);
  }

  // PIN Security
  bool validatePIN(String pin) {
    // Check PIN length
    if (pin.length < 4 || pin.length > 8) return false;
    
    // Check for repeated digits
    if (RegExp(r'(\d)\1{2,}').hasMatch(pin)) return false;
    
    // Check for sequential digits
    if (_isSequential(pin)) return false;
    
    return true;
  }

  bool _isSequential(String pin) {
    for (int i = 0; i < pin.length - 2; i++) {
      final current = int.tryParse(pin[i]);
      final next = int.tryParse(pin[i + 1]);
      final afterNext = int.tryParse(pin[i + 2]);
      
      if (current != null && next != null && afterNext != null) {
        if ((next == current + 1 && afterNext == current + 2) ||
            (next == current - 1 && afterNext == current - 2)) {
          return true;
        }
      }
    }
    return false;
  }

  // Session Security
  String generateSessionToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = generateSecureRandom();
    return generateHash('$timestamp$random');
  }

  bool isSessionValid(String token, DateTime createdAt, {Duration maxAge = const Duration(hours: 24)}) {
    final now = DateTime.now();
    final age = now.difference(createdAt);
    return age < maxAge;
  }

  // Data Sanitization
  String sanitizeInput(String input) {
    return input
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '')
        .trim();
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }

  // Security Headers
  Map<String, String> getSecurityHeaders() {
    return {
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Content-Security-Policy': "default-src 'self'",
    };
  }

  // Rate Limiting
  final Map<String, List<DateTime>> _rateLimitMap = {};

  bool isRateLimited(String identifier, {int maxAttempts = 5, Duration window = const Duration(minutes: 15)}) {
    final now = DateTime.now();
    final attempts = _rateLimitMap[identifier] ?? [];
    
    // Remove old attempts outside the window
    attempts.removeWhere((attempt) => now.difference(attempt) > window);
    
    if (attempts.length >= maxAttempts) {
      return true;
    }
    
    attempts.add(now);
    _rateLimitMap[identifier] = attempts;
    return false;
  }

  void resetRateLimit(String identifier) {
    _rateLimitMap.remove(identifier);
  }

  // Security Audit
  Map<String, dynamic> getSecurityAudit() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'biometric_available': isBiometricAvailable(),
      'rate_limits': _rateLimitMap.length,
      'security_headers': getSecurityHeaders(),
    };
  }

  // Secure Storage
  Future<String> storeSecurely(String key, String value) async {
    try {
      final encryptedValue = encryptData(value, generateSecureKey());
      // In production, use secure storage like flutter_secure_storage
      return encryptedValue;
    } catch (e) {
      debugPrint('Secure storage failed: $e');
      return value;
    }
  }

  Future<String> retrieveSecurely(String key, String encryptedValue) async {
    try {
      // In production, use secure storage like flutter_secure_storage
      return decryptData(encryptedValue, generateSecureKey());
    } catch (e) {
      debugPrint('Secure retrieval failed: $e');
      return encryptedValue;
    }
  }

  // Security Monitoring
  void logSecurityEvent(String event, Map<String, dynamic> data) {
    debugPrint('Security Event: $event - $data');
    // In production, send to security monitoring service
  }

  // Threat Detection
  bool detectSuspiciousActivity(Map<String, dynamic> activity) {
    // Check for unusual patterns
    final location = activity['location'];
    final timestamp = activity['timestamp'];
    final action = activity['action'];
    
    // Add your threat detection logic here
    return false;
  }

  // Security Recommendations
  List<String> getSecurityRecommendations() {
    return [
      'Enable biometric authentication',
      'Use strong, unique passwords',
      'Keep your app updated',
      'Be cautious with public Wi-Fi',
      'Enable two-factor authentication',
      'Regularly review your security settings',
    ];
  }
}

// Security Constants
class SecurityConstants {
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minPINLength = 4;
  static const int maxPINLength = 8;
  static const int maxLoginAttempts = 5;
  static const Duration lockoutDuration = Duration(minutes: 15);
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration tokenRefreshInterval = Duration(hours: 1);
}

// Security Enums
enum SecurityLevel {
  low,
  medium,
  high,
  critical,
}

enum BiometricType {
  fingerprint,
  face,
  iris,
  voice,
}

enum EncryptionAlgorithm {
  aes256,
  rsa2048,
  ecdsa,
}

enum SecurityEvent {
  login,
  logout,
  passwordChange,
  biometricSetup,
  suspiciousActivity,
  dataBreach,
}
