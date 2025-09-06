import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final List<AddressModel> addresses;
  final UserPreferencesModel preferences;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.addresses,
    required this.preferences,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    List<AddressModel>? addresses,
    UserPreferencesModel? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      addresses: addresses ?? this.addresses,
      preferences: preferences ?? this.preferences,
    );
  }
  
  String get fullName => '$firstName $lastName';
  
  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phoneNumber,
    profileImageUrl,
    createdAt,
    updatedAt,
    isEmailVerified,
    isPhoneVerified,
    addresses,
    preferences,
  ];
}

@JsonSerializable()
class AddressModel extends Equatable {
  final String id;
  final String title;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final double latitude;
  final double longitude;
  final String? instructions;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const AddressModel({
    required this.id,
    required this.title,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.instructions,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
  
  AddressModel copyWith({
    String? id,
    String? title,
    String? street,
    String? city,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    String? instructions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  String get fullAddress => '$street, $postalCode $city, $country';
  
  @override
  List<Object?> get props => [
    id,
    title,
    street,
    city,
    postalCode,
    country,
    latitude,
    longitude,
    instructions,
    isDefault,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class UserPreferencesModel extends Equatable {
  final String language;
  final String currency;
  final bool notificationsEnabled;
  final bool locationTrackingEnabled;
  final bool marketingEmailsEnabled;
  final String theme;
  final String defaultPaymentMethod;
  final double? defaultTipPercentage;
  
  const UserPreferencesModel({
    required this.language,
    required this.currency,
    required this.notificationsEnabled,
    required this.locationTrackingEnabled,
    required this.marketingEmailsEnabled,
    required this.theme,
    required this.defaultPaymentMethod,
    this.defaultTipPercentage,
  });
  
  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) => _$UserPreferencesModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserPreferencesModelToJson(this);
  
  UserPreferencesModel copyWith({
    String? language,
    String? currency,
    bool? notificationsEnabled,
    bool? locationTrackingEnabled,
    bool? marketingEmailsEnabled,
    String? theme,
    String? defaultPaymentMethod,
    double? defaultTipPercentage,
  }) {
    return UserPreferencesModel(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationTrackingEnabled: locationTrackingEnabled ?? this.locationTrackingEnabled,
      marketingEmailsEnabled: marketingEmailsEnabled ?? this.marketingEmailsEnabled,
      theme: theme ?? this.theme,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      defaultTipPercentage: defaultTipPercentage ?? this.defaultTipPercentage,
    );
  }
  
  @override
  List<Object?> get props => [
    language,
    currency,
    notificationsEnabled,
    locationTrackingEnabled,
    marketingEmailsEnabled,
    theme,
    defaultPaymentMethod,
    defaultTipPercentage,
  ];
}
