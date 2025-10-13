import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final String id;
  final String address;
  final String? streetNumber;
  final String? streetName;
  final String? city;
  final String? postalCode;
  final String? country;
  final double? latitude;
  final double? longitude;
  final bool isCurrent;
  final DateTime? lastUsed;

  const LocationEntity({
    required this.id,
    required this.address,
    this.streetNumber,
    this.streetName,
    this.city,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
    this.isCurrent = false,
    this.lastUsed,
  });

  String get shortAddress {
    if (streetName != null && city != null) {
      return '$streetName, $city';
    }
    return address;
  }

  String get displayAddress {
    if (isCurrent) {
      return 'Current Location';
    }
    return shortAddress;
  }

  @override
  List<Object?> get props => [
        id,
        address,
        streetNumber,
        streetName,
        city,
        postalCode,
        country,
        latitude,
        longitude,
        isCurrent,
        lastUsed,
      ];

  LocationEntity copyWith({
    String? id,
    String? address,
    String? streetNumber,
    String? streetName,
    String? city,
    String? postalCode,
    String? country,
    double? latitude,
    double? longitude,
    bool? isCurrent,
    DateTime? lastUsed,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      address: address ?? this.address,
      streetNumber: streetNumber ?? this.streetNumber,
      streetName: streetName ?? this.streetName,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isCurrent: isCurrent ?? this.isCurrent,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

