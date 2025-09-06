import 'package:equatable/equatable.dart';

class MenuEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final List<MenuCategoryEntity> categories;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuEntity({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.categories,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    name,
    description,
    categories,
    isActive,
    createdAt,
    updatedAt,
  ];
}

class MenuCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final int sortOrder;
  final List<MenuItemEntity> items;
  final bool isActive;

  const MenuCategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.items,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    sortOrder,
    items,
    isActive,
  ];
}

class MenuItemEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> imageUrls;
  final List<String> allergens;
  final List<String> dietaryInfo;
  final int calories;
  final int preparationTime;
  final bool isAvailable;
  final bool isPopular;
  final bool isSpicy;
  final bool isVegetarian;
  final bool isVegan;
  final bool isHalal;
  final List<MenuItemOptionEntity> options;
  final Map<String, dynamic>? customizations;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuItemEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.imageUrls,
    required this.allergens,
    required this.dietaryInfo,
    required this.calories,
    required this.preparationTime,
    required this.isAvailable,
    required this.isPopular,
    required this.isSpicy,
    required this.isVegetarian,
    required this.isVegan,
    required this.isHalal,
    required this.options,
    this.customizations,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedPrice => '€${price.toStringAsFixed(2)}';
  String get preparationTimeText => '${preparationTime} min';
  String get caloriesText => '$calories cal';

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    imageUrl,
    imageUrls,
    allergens,
    dietaryInfo,
    calories,
    preparationTime,
    isAvailable,
    isPopular,
    isSpicy,
    isVegetarian,
    isVegan,
    isHalal,
    options,
    customizations,
    createdAt,
    updatedAt,
  ];
}

class MenuItemOptionEntity extends Equatable {
  final String id;
  final String name;
  final String type; // 'single', 'multiple', 'text'
  final bool isRequired;
  final int minSelections;
  final int maxSelections;
  final List<MenuItemOptionValueEntity> values;

  const MenuItemOptionEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.isRequired,
    required this.minSelections,
    required this.maxSelections,
    required this.values,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    isRequired,
    minSelections,
    maxSelections,
    values,
  ];
}

class MenuItemOptionValueEntity extends Equatable {
  final String id;
  final String name;
  final double? price;
  final bool isDefault;
  final bool isAvailable;

  const MenuItemOptionValueEntity({
    required this.id,
    required this.name,
    this.price,
    required this.isDefault,
    required this.isAvailable,
  });

  String get formattedPrice => price != null ? '€${price!.toStringAsFixed(2)}' : '';

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    isDefault,
    isAvailable,
  ];
}
