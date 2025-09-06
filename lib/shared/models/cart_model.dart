import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double tip;
  final double discount;
  final double total;
  final String currency;
  final String? promoCode;
  final double? promoDiscount;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const CartModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tax,
    required this.tip,
    required this.discount,
    required this.total,
    required this.currency,
    this.promoCode,
    this.promoDiscount,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
  
  CartModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImageUrl,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? serviceFee,
    double? tax,
    double? tip,
    double? discount,
    double? total,
    String? currency,
    String? promoCode,
    double? promoDiscount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      tax: tax ?? this.tax,
      tip: tip ?? this.tip,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      promoCode: promoCode ?? this.promoCode,
      promoDiscount: promoDiscount ?? this.promoDiscount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  String get formattedTotal => '€${total.toStringAsFixed(2)}';
  String get formattedSubtotal => '€${subtotal.toStringAsFixed(2)}';
  String get formattedDeliveryFee => '€${deliveryFee.toStringAsFixed(2)}';
  String get formattedServiceFee => '€${serviceFee.toStringAsFixed(2)}';
  String get formattedTax => '€${tax.toStringAsFixed(2)}';
  String get formattedTip => '€${tip.toStringAsFixed(2)}';
  String get formattedDiscount => '€${discount.toStringAsFixed(2)}';
  String get formattedPromoDiscount => promoDiscount != null ? '€${promoDiscount!.toStringAsFixed(2)}' : '';
  
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  bool get hasPromoCode => promoCode != null && promoCode!.isNotEmpty;
  
  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    restaurantImageUrl,
    items,
    subtotal,
    deliveryFee,
    serviceFee,
    tax,
    tip,
    discount,
    total,
    currency,
    promoCode,
    promoDiscount,
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
  final String? imageUrl;
  final double price;
  final int quantity;
  final String currency;
  final List<CartItemOptionModel> selectedOptions;
  final List<CartItemAddonModel> selectedAddons;
  final String? specialInstructions;
  final double totalPrice;
  
  const CartItemModel({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.price,
    required this.quantity,
    required this.currency,
    required this.selectedOptions,
    required this.selectedAddons,
    this.specialInstructions,
    required this.totalPrice,
  });
  
  factory CartItemModel.fromJson(Map<String, dynamic> json) => _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
  
  CartItemModel copyWith({
    String? id,
    String? menuItemId,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    int? quantity,
    String? currency,
    List<CartItemOptionModel>? selectedOptions,
    List<CartItemAddonModel>? selectedAddons,
    String? specialInstructions,
    double? totalPrice,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      menuItemId: menuItemId ?? this.menuItemId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      currency: currency ?? this.currency,
      selectedOptions: selectedOptions ?? this.selectedOptions,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
  
  String get formattedPrice => '€${price.toStringAsFixed(2)}';
  String get formattedTotalPrice => '€${totalPrice.toStringAsFixed(2)}';
  
  @override
  List<Object?> get props => [
    id,
    menuItemId,
    name,
    description,
    imageUrl,
    price,
    quantity,
    currency,
    selectedOptions,
    selectedAddons,
    specialInstructions,
    totalPrice,
  ];
}

@JsonSerializable()
class CartItemOptionModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final List<CartItemOptionChoiceModel> selectedChoices;
  
  const CartItemOptionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.selectedChoices,
  });
  
  factory CartItemOptionModel.fromJson(Map<String, dynamic> json) => _$CartItemOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemOptionModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, type, selectedChoices];
}

@JsonSerializable()
class CartItemOptionChoiceModel extends Equatable {
  final String id;
  final String name;
  final double price;
  
  const CartItemOptionChoiceModel({
    required this.id,
    required this.name,
    required this.price,
  });
  
  factory CartItemOptionChoiceModel.fromJson(Map<String, dynamic> json) => _$CartItemOptionChoiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemOptionChoiceModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, price];
}

@JsonSerializable()
class CartItemAddonModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int quantity;
  
  const CartItemAddonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.quantity,
  });
  
  factory CartItemAddonModel.fromJson(Map<String, dynamic> json) => _$CartItemAddonModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemAddonModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, description, price, currency, quantity];
}

@JsonSerializable()
class PromoCodeModel extends Equatable {
  final String id;
  final String code;
  final String description;
  final String type; // 'percentage', 'fixed_amount', 'free_delivery'
  final double value;
  final double? minimumOrderAmount;
  final double? maximumDiscount;
  final DateTime validFrom;
  final DateTime validUntil;
  final int? usageLimit;
  final int? usedCount;
  final bool isActive;
  final List<String>? applicableRestaurants;
  final List<String>? applicableCategories;
  
  const PromoCodeModel({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    this.minimumOrderAmount,
    this.maximumDiscount,
    required this.validFrom,
    required this.validUntil,
    this.usageLimit,
    this.usedCount,
    required this.isActive,
    this.applicableRestaurants,
    this.applicableCategories,
  });
  
  factory PromoCodeModel.fromJson(Map<String, dynamic> json) => _$PromoCodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$PromoCodeModelToJson(this);
  
  bool get isValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(validFrom) && 
           now.isBefore(validUntil) &&
           (usageLimit == null || (usedCount ?? 0) < usageLimit!);
  }
  
  double calculateDiscount(double orderAmount) {
    if (!isValid || (minimumOrderAmount != null && orderAmount < minimumOrderAmount!)) {
      return 0;
    }
    
    double discount = 0;
    switch (type) {
      case 'percentage':
        discount = orderAmount * (value / 100);
        break;
      case 'fixed_amount':
        discount = value;
        break;
      case 'free_delivery':
        // This would be handled separately in the delivery fee calculation
        discount = 0;
        break;
    }
    
    if (maximumDiscount != null && discount > maximumDiscount!) {
      discount = maximumDiscount!;
    }
    
    return discount;
  }
  
  @override
  List<Object?> get props => [
    id,
    code,
    description,
    type,
    value,
    minimumOrderAmount,
    maximumDiscount,
    validFrom,
    validUntil,
    usageLimit,
    usedCount,
    isActive,
    applicableRestaurants,
    applicableCategories,
  ];
}
