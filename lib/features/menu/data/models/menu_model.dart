import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/menu_entity.dart';

part 'menu_model.g.dart';

@JsonSerializable()
class MenuModel extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final List<MenuCategoryModel> categories;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.categories,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => _$MenuModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuModelToJson(this);

  MenuEntity toEntity() {
    return MenuEntity(
      id: id,
      restaurantId: restaurantId,
      name: name,
      description: description,
      categories: categories.map((category) => category.toEntity()).toList(),
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

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

@JsonSerializable()
class MenuCategoryModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final int sortOrder;
  final List<MenuItemModel> items;
  final bool isActive;

  const MenuCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sortOrder,
    required this.items,
    required this.isActive,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) => _$MenuCategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuCategoryModelToJson(this);

  MenuCategoryEntity toEntity() {
    return MenuCategoryEntity(
      id: id,
      name: name,
      description: description,
      sortOrder: sortOrder,
      items: items.map((item) => item.toEntity()).toList(),
      isActive: isActive,
    );
  }

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

@JsonSerializable()
class MenuItemModel extends Equatable {
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
  final List<MenuItemOptionModel> options;
  final Map<String, dynamic>? customizations;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MenuItemModel({
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

  factory MenuItemModel.fromJson(Map<String, dynamic> json) => _$MenuItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemModelToJson(this);

  MenuItemEntity toEntity() {
    return MenuItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      imageUrls: imageUrls,
      allergens: allergens,
      dietaryInfo: dietaryInfo,
      calories: calories,
      preparationTime: preparationTime,
      isAvailable: isAvailable,
      isPopular: isPopular,
      isSpicy: isSpicy,
      isVegetarian: isVegetarian,
      isVegan: isVegan,
      isHalal: isHalal,
      options: options.map((option) => option.toEntity()).toList(),
      customizations: customizations,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

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

@JsonSerializable()
class MenuItemOptionModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool isRequired;
  final int minSelections;
  final int maxSelections;
  final List<MenuItemOptionValueModel> values;

  const MenuItemOptionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.isRequired,
    required this.minSelections,
    required this.maxSelections,
    required this.values,
  });

  factory MenuItemOptionModel.fromJson(Map<String, dynamic> json) => _$MenuItemOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemOptionModelToJson(this);

  MenuItemOptionEntity toEntity() {
    return MenuItemOptionEntity(
      id: id,
      name: name,
      type: type,
      isRequired: isRequired,
      minSelections: minSelections,
      maxSelections: maxSelections,
      values: values.map((value) => value.toEntity()).toList(),
    );
  }

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

@JsonSerializable()
class MenuItemOptionValueModel extends Equatable {
  final String id;
  final String name;
  final double? price;
  final bool isDefault;
  final bool isAvailable;

  const MenuItemOptionValueModel({
    required this.id,
    required this.name,
    this.price,
    required this.isDefault,
    required this.isAvailable,
  });

  factory MenuItemOptionValueModel.fromJson(Map<String, dynamic> json) => _$MenuItemOptionValueModelFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemOptionValueModelToJson(this);

  MenuItemOptionValueEntity toEntity() {
    return MenuItemOptionValueEntity(
      id: id,
      name: name,
      price: price,
      isDefault: isDefault,
      isAvailable: isAvailable,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    price,
    isDefault,
    isAvailable,
  ];
}
