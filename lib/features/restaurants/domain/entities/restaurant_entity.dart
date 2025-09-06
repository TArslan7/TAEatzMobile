import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
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
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const RestaurantEntity({
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
    required this.createdAt,
    required this.updatedAt,
  });
  
  String get fullAddress => '$address, $postalCode $city, $country';
  String get deliveryTimeRange => '$deliveryTimeMin-$deliveryTimeMax min';
  String get formattedDeliveryFee => '€${deliveryFee.toStringAsFixed(2)}';
  String get formattedMinimumOrder => '€${minimumOrderAmount.toStringAsFixed(2)}';
  
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
    createdAt,
    updatedAt,
  ];
}
