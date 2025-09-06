class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.taeatz.com';
  static const String apiVersion = '/v1';
  static const String apiKey = 'your-api-key-here';
  
  // App Configuration
  static const String appName = 'TAEatz';
  static const String appVersion = '1.0.0';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String cartDataKey = 'cart_data';
  static const String locationDataKey = 'location_data';
  static const String preferencesKey = 'app_preferences';
  
  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderOutForDelivery = 'out_for_delivery';
  static const String orderDelivered = 'delivered';
  static const String orderCancelled = 'cancelled';
  
  // Payment Methods
  static const String paymentCard = 'card';
  static const String paymentCash = 'cash';
  static const String paymentPaypal = 'paypal';
  static const String paymentApplePay = 'apple_pay';
  static const String paymentGooglePay = 'google_pay';
  
  // Delivery Status
  static const String deliveryPending = 'pending';
  static const String deliveryAssigned = 'assigned';
  static const String deliveryPickedUp = 'picked_up';
  static const String deliveryInTransit = 'in_transit';
  static const String deliveryDelivered = 'delivered';
  
  // Restaurant Categories
  static const List<String> restaurantCategories = [
    'Pizza',
    'Burgers',
    'Sushi',
    'Chinese',
    'Italian',
    'Mexican',
    'Indian',
    'Thai',
    'Fast Food',
    'Desserts',
    'Healthy',
    'Vegetarian',
    'Vegan',
    'Halal',
    'Kosher',
  ];
  
  // Cuisine Types
  static const List<String> cuisineTypes = [
    'European',
    'Asian',
    'American',
    'Middle Eastern',
    'African',
    'Latin American',
    'Mediterranean',
  ];
  
  // Delivery Time Slots
  static const List<String> deliveryTimeSlots = [
    'ASAP (30-45 min)',
    '1 hour',
    '2 hours',
    '3 hours',
    'Tomorrow',
  ];
  
  // Rating Scale
  static const double minRating = 1.0;
  static const double maxRating = 5.0;
  
  // Map Configuration
  static const double defaultLatitude = 52.3676; // Amsterdam
  static const double defaultLongitude = 4.9041;
  static const double defaultZoom = 12.0;
  
  // Image Sizes
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Duration
  static const Duration cacheExpiration = Duration(hours: 1);
  static const Duration userDataCacheExpiration = Duration(days: 7);
  
  // Notification Types
  static const String notificationOrderUpdate = 'order_update';
  static const String notificationPromotion = 'promotion';
  static const String notificationDelivery = 'delivery';
  static const String notificationGeneral = 'general';
}
