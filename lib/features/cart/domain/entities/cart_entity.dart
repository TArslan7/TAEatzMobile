import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<CartItemEntity> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CartEntity({
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

  bool get isEmpty => items.isEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
  
  // Alias properties for compatibility
  double get taxAmount => tax;
  double get totalAmount => total;
  
  String get formattedSubtotal => '€${subtotal.toStringAsFixed(2)}';
  String get formattedDeliveryFee => '€${deliveryFee.toStringAsFixed(2)}';
  String get formattedTax => '€${tax.toStringAsFixed(2)}';
  String get formattedTotal => '€${total.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    restaurantName,
    items,
    subtotal,
    deliveryFee,
    tax,
    total,
    createdAt,
    updatedAt,
  ];
}

class CartItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final String imageUrl;
  final double basePrice;
  final int quantity;
  final List<CartItemOptionEntity> selectedOptions;
  final String? specialInstructions;
  final double totalPrice;

  const CartItemEntity({
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

  String get formattedBasePrice => '€${basePrice.toStringAsFixed(2)}';
  String get formattedTotalPrice => '€${totalPrice.toStringAsFixed(2)}';

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

class CartItemOptionEntity extends Equatable {
  final String id;
  final String name;
  final String value;
  final double price;

  const CartItemOptionEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.price,
  });

  String get formattedPrice => '€${price.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [id, name, value, price];
}
