import 'dart:math';

class AdvancedPaymentService {
  static AdvancedPaymentService? _instance;
  static AdvancedPaymentService get instance => _instance ??= AdvancedPaymentService._();
  
  AdvancedPaymentService._();

  // Split Bill Functionality
  Future<Map<String, dynamic>> splitBill({
    required double totalAmount,
    required List<String> participantIds,
    required String splitType, // 'equal', 'percentage', 'custom'
    Map<String, double>? customAmounts,
    Map<String, double>? percentages,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final splitAmounts = <String, double>{};
    
    switch (splitType) {
      case 'equal':
        final amountPerPerson = totalAmount / participantIds.length;
        for (final participantId in participantIds) {
          splitAmounts[participantId] = amountPerPerson;
        }
        break;
        
      case 'percentage':
        if (percentages != null) {
          for (final entry in percentages.entries) {
            splitAmounts[entry.key] = totalAmount * (entry.value / 100);
          }
        }
        break;
        
      case 'custom':
        if (customAmounts != null) {
          splitAmounts.addAll(customAmounts);
        }
        break;
    }
    
    return {
      'totalAmount': totalAmount,
      'participantCount': participantIds.length,
      'splitAmounts': splitAmounts,
      'splitType': splitType,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Cryptocurrency Payment
  Future<Map<String, dynamic>> processCryptoPayment({
    required String currency, // 'BTC', 'ETH', 'USDC'
    required double amount,
    required String walletAddress,
    required String orderId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    
    // Mock cryptocurrency payment processing
    final transactionHash = _generateTransactionHash();
    final gasFee = _calculateGasFee(currency);
    
    return {
      'success': true,
      'transactionHash': transactionHash,
      'currency': currency,
      'amount': amount,
      'gasFee': gasFee,
      'confirmations': 0,
      'status': 'pending',
      'orderId': orderId,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  // Digital Wallet Integration
  Future<Map<String, dynamic>> processWalletPayment({
    required String walletType, // 'apple_pay', 'google_pay', 'samsung_pay'
    required double amount,
    required String orderId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return {
      'success': true,
      'walletType': walletType,
      'amount': amount,
      'transactionId': _generateTransactionId(),
      'orderId': orderId,
      'processedAt': DateTime.now().toIso8601String(),
    };
  }

  // Subscription Management
  Future<Map<String, dynamic>> createSubscription({
    required String userId,
    required String planId,
    required String paymentMethodId,
    required String billingCycle, // 'monthly', 'yearly'
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final subscription = {
      'id': _generateSubscriptionId(),
      'userId': userId,
      'planId': planId,
      'paymentMethodId': paymentMethodId,
      'billingCycle': billingCycle,
      'status': 'active',
      'currentPeriodStart': DateTime.now().toIso8601String(),
      'currentPeriodEnd': _calculatePeriodEnd(billingCycle),
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    return subscription;
  }

  // Loyalty Points System
  Future<Map<String, dynamic>> processLoyaltyPoints({
    required String userId,
    required double orderAmount,
    required String action, // 'earn', 'redeem'
    int? pointsToRedeem,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final pointsEarned = action == 'earn' ? (orderAmount * 0.1).round() : 0;
    final pointsRedeemed = action == 'redeem' ? (pointsToRedeem ?? 0) : 0;
    final pointsValue = pointsRedeemed * 0.01; // 1 point = $0.01
    
    return {
      'userId': userId,
      'action': action,
      'pointsEarned': pointsEarned,
      'pointsRedeemed': pointsRedeemed,
      'pointsValue': pointsValue,
      'remainingPoints': _calculateRemainingPoints(userId, pointsEarned, pointsRedeemed),
      'processedAt': DateTime.now().toIso8601String(),
    };
  }

  // Dynamic Pricing
  Future<Map<String, double>> calculateDynamicPricing({
    required String restaurantId,
    required Map<String, double> basePrices,
    required String timeOfDay,
    required double demandLevel,
    required String weatherCondition,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final dynamicPrices = <String, double>{};
    
    for (final entry in basePrices.entries) {
      double multiplier = 1.0;
      
      // Time-based pricing
      if (timeOfDay == 'dinner') multiplier *= 1.1;
      if (timeOfDay == 'lunch') multiplier *= 1.05;
      
      // Demand-based pricing
      if (demandLevel > 0.8) multiplier *= 1.15;
      if (demandLevel < 0.3) multiplier *= 0.95;
      
      // Weather-based pricing
      if (weatherCondition == 'rainy') multiplier *= 1.2;
      if (weatherCondition == 'snowy') multiplier *= 1.3;
      
      dynamicPrices[entry.key] = (entry.value * multiplier).roundToDouble();
    }
    
    return dynamicPrices;
  }

  // Payment Analytics
  Map<String, dynamic> getPaymentAnalytics(String userId) {
    return {
      'totalSpent': 1250.50,
      'averageOrderValue': 25.10,
      'paymentMethods': {
        'credit_card': 0.6,
        'debit_card': 0.25,
        'digital_wallet': 0.1,
        'cryptocurrency': 0.05,
      },
      'monthlySpending': {
        'current': 180.75,
        'previous': 165.30,
        'growth': 0.09,
      },
      'loyaltyPoints': {
        'total': 1250,
        'available': 1100,
        'redeemed': 150,
        'value': 11.00,
      },
      'preferredPaymentTime': '19:00-21:00',
      'topRestaurants': [
        {'name': 'Pizza Palace', 'spent': 450.00, 'orders': 18},
        {'name': 'Burger Joint', 'spent': 320.00, 'orders': 12},
        {'name': 'Sushi Spot', 'spent': 280.00, 'orders': 8},
      ],
    };
  }

  // Fraud Detection
  Future<Map<String, dynamic>> detectFraud({
    required String userId,
    required double amount,
    required String paymentMethodId,
    required Map<String, dynamic> transactionData,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Mock fraud detection
    final riskScore = _calculateRiskScore(amount, transactionData);
    final isFraudulent = riskScore > 0.7;
    
    return {
      'isFraudulent': isFraudulent,
      'riskScore': riskScore,
      'riskLevel': _getRiskLevel(riskScore),
      'reasons': _getFraudReasons(riskScore, transactionData),
      'recommendations': _getFraudRecommendations(riskScore),
      'processedAt': DateTime.now().toIso8601String(),
    };
  }

  // Refund Processing
  Future<Map<String, dynamic>> processRefund({
    required String orderId,
    required double amount,
    required String reason,
    required String refundType, // 'full', 'partial'
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return {
      'success': true,
      'refundId': _generateRefundId(),
      'orderId': orderId,
      'amount': amount,
      'reason': reason,
      'refundType': refundType,
      'status': 'processed',
      'processedAt': DateTime.now().toIso8601String(),
      'estimatedRefundTime': '3-5 business days',
    };
  }

  // Helper Methods
  String _generateTransactionHash() {
    final random = Random();
    final chars = '0123456789abcdef';
    return List.generate(64, (index) => chars[random.nextInt(chars.length)]).join();
  }

  String _generateTransactionId() {
    return 'TXN_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  String _generateSubscriptionId() {
    return 'SUB_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  String _generateRefundId() {
    return 'REF_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  double _calculateGasFee(String currency) {
    switch (currency) {
      case 'BTC':
        return 0.0001;
      case 'ETH':
        return 0.005;
      case 'USDC':
        return 0.01;
      default:
        return 0.001;
    }
  }

  String _calculatePeriodEnd(String billingCycle) {
    final now = DateTime.now();
    if (billingCycle == 'monthly') {
      return now.add(const Duration(days: 30)).toIso8601String();
    } else {
      return now.add(const Duration(days: 365)).toIso8601String();
    }
  }

  int _calculateRemainingPoints(String userId, int earned, int redeemed) {
    // Mock calculation - in production, fetch from database
    return 1000 + earned - redeemed;
  }

  double _calculateRiskScore(double amount, Map<String, dynamic> transactionData) {
    double score = 0.0;
    
    // Amount-based risk
    if (amount > 100) score += 0.2;
    if (amount > 500) score += 0.3;
    
    // Time-based risk
    final hour = DateTime.now().hour;
    if (hour < 6 || hour > 22) score += 0.2;
    
    // Location-based risk
    final location = transactionData['location'] as String? ?? '';
    if (location.isEmpty) score += 0.3;
    
    return score.clamp(0.0, 1.0);
  }

  String _getRiskLevel(double riskScore) {
    if (riskScore < 0.3) return 'low';
    if (riskScore < 0.7) return 'medium';
    return 'high';
  }

  List<String> _getFraudReasons(double riskScore, Map<String, dynamic> transactionData) {
    final reasons = <String>[];
    
    if (riskScore > 0.5) {
      reasons.add('High transaction amount');
    }
    if (transactionData['location'] == null) {
      reasons.add('Missing location data');
    }
    if (riskScore > 0.7) {
      reasons.add('Unusual transaction pattern');
    }
    
    return reasons;
  }

  List<String> _getFraudRecommendations(double riskScore) {
    if (riskScore > 0.7) {
      return ['Require additional verification', 'Contact customer', 'Hold transaction'];
    } else if (riskScore > 0.5) {
      return ['Monitor transaction', 'Verify payment method'];
    } else {
      return ['Process normally'];
    }
  }
}
