import 'dart:math';

class AdvancedAIService {
  static AdvancedAIService? _instance;
  static AdvancedAIService get instance => _instance ??= AdvancedAIService._();
  
  AdvancedAIService._();

  // Smart Menu Recommendations
  Future<List<String>> getSmartRecommendations({
    required String userId,
    required String restaurantId,
    required List<String> dietaryRestrictions,
    required double budget,
    required String timeOfDay,
  }) async {
    // Mock AI-powered recommendations
    await Future.delayed(const Duration(milliseconds: 500));
    
    final recommendations = <String>[];
    
    // Time-based recommendations
    if (timeOfDay == 'morning') {
      recommendations.addAll(['Breakfast Burrito', 'Avocado Toast', 'Smoothie Bowl']);
    } else if (timeOfDay == 'lunch') {
      recommendations.addAll(['Caesar Salad', 'Grilled Chicken Sandwich', 'Soup of the Day']);
    } else {
      recommendations.addAll(['Pasta Carbonara', 'Grilled Salmon', 'Vegetable Stir Fry']);
    }
    
    // Budget-based filtering
    if (budget < 15) {
      recommendations.removeWhere((item) => item.contains('Salmon') || item.contains('Carbonara'));
    }
    
    // Dietary restrictions
    if (dietaryRestrictions.contains('vegetarian')) {
      recommendations.removeWhere((item) => item.contains('Chicken') || item.contains('Salmon'));
    }
    
    return recommendations.take(5).toList();
  }

  // Predictive Ordering
  Future<Map<String, dynamic>> predictNextOrder({
    required String userId,
    required List<Map<String, dynamic>> orderHistory,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Analyze order patterns
    final mostOrderedItems = _analyzeOrderPatterns(orderHistory);
    final preferredRestaurants = _analyzeRestaurantPreferences(orderHistory);
    final orderFrequency = _calculateOrderFrequency(orderHistory);
    
    return {
      'predictedItems': mostOrderedItems,
      'predictedRestaurant': preferredRestaurants.isNotEmpty ? preferredRestaurants.first : null,
      'confidence': Random().nextDouble() * 0.4 + 0.6, // 60-100% confidence
      'nextOrderTime': _predictNextOrderTime(orderFrequency),
      'suggestedBudget': _predictBudget(orderHistory),
    };
  }

  // Dynamic Pricing Optimization
  Future<Map<String, double>> optimizePricing({
    required String restaurantId,
    required Map<String, double> basePrices,
    required Map<String, int> demandData,
    required String timeOfDay,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final optimizedPrices = <String, double>{};
    
    for (final entry in basePrices.entries) {
      final item = entry.key;
      final basePrice = entry.value;
      final demand = demandData[item] ?? 0;
      
      // Simple demand-based pricing
      double multiplier = 1.0;
      if (demand > 10) multiplier = 1.1; // High demand = 10% increase
      if (demand < 3) multiplier = 0.9;  // Low demand = 10% decrease
      
      // Time-based pricing
      if (timeOfDay == 'dinner') multiplier *= 1.05;
      
      optimizedPrices[item] = (basePrice * multiplier).roundToDouble();
    }
    
    return optimizedPrices;
  }

  // Sentiment Analysis
  Future<Map<String, dynamic>> analyzeSentiment({
    required String text,
    required String context, // 'review', 'chat', 'feedback'
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    // Simple keyword-based sentiment analysis
    final positiveWords = ['great', 'excellent', 'amazing', 'delicious', 'love', 'perfect', 'fantastic'];
    final negativeWords = ['bad', 'terrible', 'awful', 'hate', 'disgusting', 'worst', 'horrible'];
    
    final words = text.toLowerCase().split(' ');
    int positiveCount = 0;
    int negativeCount = 0;
    
    for (final word in words) {
      if (positiveWords.contains(word)) positiveCount++;
      if (negativeWords.contains(word)) negativeCount++;
    }
    
    String sentiment;
    double confidence;
    
    if (positiveCount > negativeCount) {
      sentiment = 'positive';
      confidence = (positiveCount / (positiveCount + negativeCount));
    } else if (negativeCount > positiveCount) {
      sentiment = 'negative';
      confidence = (negativeCount / (positiveCount + negativeCount));
    } else {
      sentiment = 'neutral';
      confidence = 0.5;
    }
    
    return {
      'sentiment': sentiment,
      'confidence': confidence,
      'positiveScore': positiveCount,
      'negativeScore': negativeCount,
      'emotions': _extractEmotions(text),
    };
  }

  // Image Recognition for Food
  Future<Map<String, dynamic>> recognizeFood({
    required String imageUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock food recognition
    final mockResults = [
      {'name': 'Pizza Margherita', 'confidence': 0.95, 'calories': 285, 'allergens': ['gluten', 'dairy']},
      {'name': 'Caesar Salad', 'confidence': 0.88, 'calories': 180, 'allergens': ['dairy', 'eggs']},
      {'name': 'Chicken Burger', 'confidence': 0.92, 'calories': 450, 'allergens': ['gluten']},
    ];
    
    return mockResults[Random().nextInt(mockResults.length)];
  }

  // Chatbot for Customer Support
  Future<String> generateChatbotResponse({
    required String userMessage,
    required String context,
    required Map<String, dynamic> userProfile,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final message = userMessage.toLowerCase();
    
    if (message.contains('order') && message.contains('status')) {
      return "I can help you check your order status. Let me look that up for you.";
    } else if (message.contains('delivery') && message.contains('time')) {
      return "Delivery times typically range from 30-45 minutes depending on your location and restaurant.";
    } else if (message.contains('refund') || message.contains('cancel')) {
      return "I can help you with refunds and cancellations. What's the issue with your order?";
    } else if (message.contains('menu') || message.contains('food')) {
      return "I'd be happy to help you find something delicious! What type of cuisine are you in the mood for?";
    } else {
      return "I'm here to help! Could you please provide more details about what you need assistance with?";
    }
  }

  // Helper Methods
  List<String> _analyzeOrderPatterns(List<Map<String, dynamic>> orderHistory) {
    final itemCounts = <String, int>{};
    
    for (final order in orderHistory) {
      final items = order['items'] as List<dynamic>? ?? [];
      for (final item in items) {
        final itemName = item['name'] as String? ?? '';
        itemCounts[itemName] = (itemCounts[itemName] ?? 0) + 1;
      }
    }
    
    final sortedItems = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedItems.take(3).map((e) => e.key).toList();
  }

  List<String> _analyzeRestaurantPreferences(List<Map<String, dynamic>> orderHistory) {
    final restaurantCounts = <String, int>{};
    
    for (final order in orderHistory) {
      final restaurantId = order['restaurantId'] as String? ?? '';
      restaurantCounts[restaurantId] = (restaurantCounts[restaurantId] ?? 0) + 1;
    }
    
    final sortedRestaurants = restaurantCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedRestaurants.take(2).map((e) => e.key).toList();
  }

  double _calculateOrderFrequency(List<Map<String, dynamic>> orderHistory) {
    if (orderHistory.isEmpty) return 0.0;
    
    final now = DateTime.now();
    final firstOrder = DateTime.parse(orderHistory.first['createdAt'] as String);
    final daysSinceFirstOrder = now.difference(firstOrder).inDays;
    
    return orderHistory.length / (daysSinceFirstOrder + 1);
  }

  DateTime _predictNextOrderTime(double frequency) {
    final daysUntilNextOrder = (1 / frequency).ceil();
    return DateTime.now().add(Duration(days: daysUntilNextOrder));
  }

  double _predictBudget(List<Map<String, dynamic>> orderHistory) {
    if (orderHistory.isEmpty) return 25.0;
    
    final totalSpent = orderHistory.fold<double>(0.0, (sum, order) {
      return sum + (order['total'] as double? ?? 0.0);
    });
    
    return totalSpent / orderHistory.length;
  }

  List<String> _extractEmotions(String text) {
    final emotions = <String>[];
    final textLower = text.toLowerCase();
    
    if (textLower.contains('happy') || textLower.contains('joy')) emotions.add('joy');
    if (textLower.contains('angry') || textLower.contains('mad')) emotions.add('anger');
    if (textLower.contains('sad') || textLower.contains('disappointed')) emotions.add('sadness');
    if (textLower.contains('excited') || textLower.contains('thrilled')) emotions.add('excitement');
    if (textLower.contains('surprised') || textLower.contains('wow')) emotions.add('surprise');
    
    return emotions;
  }
}
