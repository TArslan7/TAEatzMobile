import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'menu_model.g.dart';

@JsonSerializable()
class MenuModel extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final List<CategoryModel> categories;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const MenuModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.categories,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory MenuModel.fromJson(Map<String, dynamic> json) => _$MenuModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuModelToJson(this);
  
  @override
  List<Object?> get props => [id, restaurantId, name, description, categories, createdAt, updatedAt];
}

@JsonSerializable()
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int sortOrder;
  final bool isActive;
  final List<MenuItemModel> items;
  
  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.sortOrder,
    required this.isActive,
    required this.items,
  });
  
  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, description, imageUrl, sortOrder, isActive, items];
}

@JsonSerializable()
class MenuItemModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final List<String> imageUrls;
  final double price;
  final double? originalPrice;
  final String currency;
  final List<String> allergens;
  final List<String> dietaryInfo;
  final int calories;
  final int preparationTime;
  final bool isAvailable;
  final bool isPopular;
  final bool isSpicy;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isHalal;
  final bool isKosher;
  final List<MenuItemOptionModel> options;
  final List<MenuItemAddonModel> addons;
  final Map<String, dynamic>? nutritionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const MenuItemModel({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.imageUrls,
    required this.price,
    this.originalPrice,
    required this.currency,
    required this.allergens,
    required this.dietaryInfo,
    required this.calories,
    required this.preparationTime,
    required this.isAvailable,
    required this.isPopular,
    required this.isSpicy,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.isHalal,
    required this.isKosher,
    required this.options,
    required this.addons,
    this.nutritionalInfo,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory MenuItemModel.fromJson(Map<String, dynamic> json) => _$MenuItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);
  
  MenuItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
    double? price,
    double? originalPrice,
    String? currency,
    List<String>? allergens,
    List<String>? dietaryInfo,
    int? calories,
    int? preparationTime,
    bool? isAvailable,
    bool? isPopular,
    bool? isSpicy,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isHalal,
    bool? isKosher,
    List<MenuItemOptionModel>? options,
    List<MenuItemAddonModel>? addons,
    Map<String, dynamic>? nutritionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      currency: currency ?? this.currency,
      allergens: allergens ?? this.allergens,
      dietaryInfo: dietaryInfo ?? this.dietaryInfo,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      isSpicy: isSpicy ?? this.isSpicy,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isHalal: isHalal ?? this.isHalal,
      isKosher: isKosher ?? this.isKosher,
      options: options ?? this.options,
      addons: addons ?? this.addons,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  double get discountPercentage => hasDiscount ? ((originalPrice! - price) / originalPrice!) * 100 : 0;
  String get formattedPrice => '€${price.toStringAsFixed(2)}';
  String get formattedOriginalPrice => originalPrice != null ? '€${originalPrice!.toStringAsFixed(2)}' : '';
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    imageUrls,
    price,
    originalPrice,
    currency,
    allergens,
    dietaryInfo,
    calories,
    preparationTime,
    isAvailable,
    isPopular,
    isSpicy,
    isVegetarian,
    isVegan,
    isGlutenFree,
    isHalal,
    isKosher,
    options,
    addons,
    nutritionalInfo,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class MenuItemOptionModel extends Equatable {
  final String id;
  final String name;
  final String type; // 'single', 'multiple'
  final bool isRequired;
  final int minSelections;
  final int maxSelections;
  final List<OptionChoiceModel> choices;
  
  const MenuItemOptionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isRequired,
    required this.minSelections,
    required this.maxSelections,
    required this.choices,
  });
  
  factory MenuItemOptionModel.fromJson(Map<String, dynamic> json) => _$MenuItemOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemOptionModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, type, isRequired, minSelections, maxSelections, choices];
}

@JsonSerializable()
class OptionChoiceModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isAvailable;
  final int calories;
  
  const OptionChoiceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.calories,
  });
  
  factory OptionChoiceModel.fromJson(Map<String, dynamic> json) => _$OptionChoiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$OptionChoiceModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, price, isAvailable, calories];
}

@JsonSerializable()
class MenuItemAddonModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final bool isAvailable;
  final int calories;
  final String? imageUrl;
  
  const MenuItemAddonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.isAvailable,
    required this.calories,
    this.imageUrl,
  });
  
  factory MenuItemAddonModel.fromJson(Map<String, dynamic> json) => _$MenuItemAddonModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemAddonModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, description, price, currency, isAvailable, calories, imageUrl];
}
