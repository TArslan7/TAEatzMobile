import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  CartEntity toEntity() {
    return CartEntity(
      id: id,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantImageUrl: restaurantImageUrl,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      tax: tax,
      total: total,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    restaurantName,
    restaurantImageUrl,
    items,
    subtotal,
    deliveryFee,
    tax,
    total,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class CartItemModel extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  final int quantity;
  final List<CartItemOptionModel> selectedOptions;
  final String? specialInstructions;
  final double totalPrice;

  const CartItemModel({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.quantity,
    required this.selectedOptions,
    this.specialInstructions,
    required this.totalPrice,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      menuItemId: menuItemId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      basePrice: basePrice,
      quantity: quantity,
      selectedOptions: selectedOptions.map((option) => option.toEntity()).toList(),
      specialInstructions: specialInstructions,
      totalPrice: totalPrice,
    );
  }

  @override
  List<Object?> get props => [
    id,
    menuItemId,
    name,
    description,
    imageUrl,
    basePrice,
    quantity,
    selectedOptions,
    specialInstructions,
    totalPrice,
  ];
}

@JsonSerializable()
class CartItemOptionModel extends Equatable {
  final String id;
  final String name;
  final String value;
  final double price;

  const CartItemOptionModel({
    required this.id,
    required this.name,
    required this.value,
    required this.price,
  });

  factory CartItemOptionModel.fromJson(Map<String, dynamic> json) => _$CartItemOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemOptionModelToJson(this);

  CartItemOptionEntity toEntity() {
    return CartItemOptionEntity(
      id: id,
      name: name,
      value: value,
      price: price,
    );
  }

  @override
  List<Object?> get props => [id, name, value, price];
}

extension CartItemModelExtension on CartItemEntity {
  CartItemModel fromEntity() {
    return CartItemModel(
      id: id,
      menuItemId: menuItemId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      basePrice: basePrice,
      quantity: quantity,
      selectedOptions: selectedOptions.map((option) => CartItemOptionModel(
        id: option.id,
        name: option.name,
        value: option.value,
        price: option.price,
      )).toList(),
      specialInstructions: specialInstructions,
      totalPrice: totalPrice,
    );
  }
}
