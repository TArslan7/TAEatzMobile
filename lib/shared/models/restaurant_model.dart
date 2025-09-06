import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../features/restaurants/domain/entities/restaurant_entity.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final String phoneNumber;
  final String email;
  final String website;
  final List<String> categories;
  final List<String> cuisineTypes;
  final double rating;
  final int reviewCount;
  final double deliveryFee;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final double minimumOrderAmount;
  final bool isOpen;
  final bool isDeliveryAvailable;
  final bool isPickupAvailable;
  final List<OpeningHoursModel> openingHours;
  final List<PaymentMethodModel> acceptedPaymentMethods;
  final List<DeliveryAreaModel> deliveryAreas;
  final RestaurantSettingsModel settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.imageUrls,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.categories,
    required this.cuisineTypes,
    required this.rating,
    required this.reviewCount,
    required this.deliveryFee,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.minimumOrderAmount,
    required this.isOpen,
    required this.isDeliveryAvailable,
    required this.isPickupAvailable,
    required this.openingHours,
    required this.acceptedPaymentMethods,
    required this.deliveryAreas,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory RestaurantModel.fromJson(Map<String, dynamic> json) => _$RestaurantModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
  
  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
    String? address,
    String? city,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    String? email,
    String? website,
    List<String>? categories,
    List<String>? cuisineTypes,
    double? rating,
    int? reviewCount,
    double? deliveryFee,
    int? deliveryTimeMin,
    int? deliveryTimeMax,
    double? minimumOrderAmount,
    bool? isOpen,
    bool? isDeliveryAvailable,
    bool? isPickupAvailable,
    List<OpeningHoursModel>? openingHours,
    List<PaymentMethodModel>? acceptedPaymentMethods,
    List<DeliveryAreaModel>? deliveryAreas,
    RestaurantSettingsModel? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      categories: categories ?? this.categories,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryTimeMin: deliveryTimeMin ?? this.deliveryTimeMin,
      deliveryTimeMax: deliveryTimeMax ?? this.deliveryTimeMax,
      minimumOrderAmount: minimumOrderAmount ?? this.minimumOrderAmount,
      isOpen: isOpen ?? this.isOpen,
      isDeliveryAvailable: isDeliveryAvailable ?? this.isDeliveryAvailable,
      isPickupAvailable: isPickupAvailable ?? this.isPickupAvailable,
      openingHours: openingHours ?? this.openingHours,
      acceptedPaymentMethods: acceptedPaymentMethods ?? this.acceptedPaymentMethods,
      deliveryAreas: deliveryAreas ?? this.deliveryAreas,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  String get fullAddress => '$address, $postalCode $city, $country';
  String get deliveryTimeRange => '$deliveryTimeMin-$deliveryTimeMax min';
  bool get isCurrentlyOpen => _isCurrentlyOpen();
  
  bool _isCurrentlyOpen() {
    final now = DateTime.now();
    final currentDay = now.weekday;
    final currentTime = now.hour * 60 + now.minute;
    
    for (final hours in openingHours) {
      if (hours.dayOfWeek == currentDay) {
        final openTime = hours.openTime.hour * 60 + hours.openTime.minute;
        final closeTime = hours.closeTime.hour * 60 + hours.closeTime.minute;
        
        if (currentTime >= openTime && currentTime <= closeTime) {
          return true;
        }
      }
    }
    return false;
  }
  
  RestaurantEntity toEntity() {
    return RestaurantEntity(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      imageUrls: imageUrls,
      address: address,
      city: city,
      postalCode: postalCode,
      country: country,
      latitude: latitude,
      longitude: longitude,
      phoneNumber: phoneNumber,
      email: email,
      website: website,
      categories: categories,
      cuisineTypes: cuisineTypes,
      rating: rating,
      reviewCount: reviewCount,
      deliveryFee: deliveryFee,
      deliveryTimeMin: deliveryTimeMin,
      deliveryTimeMax: deliveryTimeMax,
      minimumOrderAmount: minimumOrderAmount,
      isOpen: isOpen,
      isDeliveryAvailable: isDeliveryAvailable,
      isPickupAvailable: isPickupAvailable,
      acceptedPaymentMethods: acceptedPaymentMethods.map((e) => e.name).toList(),
      deliveryAreas: deliveryAreas.map((e) => e.name).toList(),
      settings: {
        'allowPreOrders': settings.allowPreOrders,
        'allowScheduledOrders': settings.allowScheduledOrders,
        'maxAdvanceOrderDays': settings.maxAdvanceOrderDays,
        'requirePhoneVerification': settings.requirePhoneVerification,
        'allowGuestOrders': settings.allowGuestOrders,
        'enableReviews': settings.enableReviews,
        'enableRatings': settings.enableRatings,
        'enableLoyaltyProgram': settings.enableLoyaltyProgram,
      },
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    imageUrls,
    address,
    city,
    postalCode,
    country,
    latitude,
    longitude,
    phoneNumber,
    email,
    website,
    categories,
    cuisineTypes,
    rating,
    reviewCount,
    deliveryFee,
    deliveryTimeMin,
    deliveryTimeMax,
    minimumOrderAmount,
    isOpen,
    isDeliveryAvailable,
    isPickupAvailable,
    openingHours,
    acceptedPaymentMethods,
    deliveryAreas,
    settings,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class OpeningHoursModel extends Equatable {
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final DateTime openTime;
  final DateTime closeTime;
  final bool isClosed;
  
  const OpeningHoursModel({
    required this.dayOfWeek,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });
  
  factory OpeningHoursModel.fromJson(Map<String, dynamic> json) => _$OpeningHoursModelFromJson(json);
  Map<String, dynamic> toJson() => _$OpeningHoursModelToJson(this);
  
  @override
  List<Object?> get props => [dayOfWeek, openTime, closeTime, isClosed];
}

@JsonSerializable()
class PaymentMethodModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool isEnabled;
  final Map<String, dynamic>? configuration;
  
  const PaymentMethodModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isEnabled,
    this.configuration,
  });
  
  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, type, isEnabled, configuration];
}

@JsonSerializable()
class DeliveryAreaModel extends Equatable {
  final String id;
  final String name;
  final double deliveryFee;
  final int deliveryTimeMin;
  final int deliveryTimeMax;
  final double minimumOrderAmount;
  final List<LatLngModel> polygon;
  
  const DeliveryAreaModel({
    required this.id,
    required this.name,
    required this.deliveryFee,
    required this.deliveryTimeMin,
    required this.deliveryTimeMax,
    required this.minimumOrderAmount,
    required this.polygon,
  });
  
  factory DeliveryAreaModel.fromJson(Map<String, dynamic> json) => _$DeliveryAreaModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryAreaModelToJson(this);
  
  @override
  List<Object?> get props => [
    id,
    name,
    deliveryFee,
    deliveryTimeMin,
    deliveryTimeMax,
    minimumOrderAmount,
    polygon,
  ];
}

@JsonSerializable()
class LatLngModel extends Equatable {
  final double latitude;
  final double longitude;
  
  const LatLngModel({
    required this.latitude,
    required this.longitude,
  });
  
  factory LatLngModel.fromJson(Map<String, dynamic> json) => _$LatLngModelFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngModelToJson(this);
  
  @override
  List<Object?> get props => [latitude, longitude];
}

@JsonSerializable()
class RestaurantSettingsModel extends Equatable {
  final bool allowPreOrders;
  final bool allowScheduledOrders;
  final int maxAdvanceOrderDays;
  final bool requirePhoneVerification;
  final bool allowGuestOrders;
  final bool enableReviews;
  final bool enableRatings;
  final bool enableLoyaltyProgram;
  final Map<String, dynamic>? customSettings;
  
  const RestaurantSettingsModel({
    required this.allowPreOrders,
    required this.allowScheduledOrders,
    required this.maxAdvanceOrderDays,
    required this.requirePhoneVerification,
    required this.allowGuestOrders,
    required this.enableReviews,
    required this.enableRatings,
    required this.enableLoyaltyProgram,
    this.customSettings,
  });
  
  factory RestaurantSettingsModel.fromJson(Map<String, dynamic> json) => _$RestaurantSettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantSettingsModelToJson(this);
  
  @override
  List<Object?> get props => [
    allowPreOrders,
    allowScheduledOrders,
    maxAdvanceOrderDays,
    requirePhoneVerification,
    allowGuestOrders,
    enableReviews,
    enableRatings,
    enableLoyaltyProgram,
    customSettings,
  ];
}
