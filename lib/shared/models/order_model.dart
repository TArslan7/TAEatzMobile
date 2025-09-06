import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImageUrl;
  final String restaurantPhoneNumber;
  final String status;
  final String paymentStatus;
  final String deliveryStatus;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double tip;
  final double discount;
  final double total;
  final String currency;
  final AddressModel deliveryAddress;
  final String? deliveryInstructions;
  final String? specialInstructions;
  final String paymentMethod;
  final String? paymentIntentId;
  final String? paymentTransactionId;
  final DateTime? scheduledDeliveryTime;
  final DateTime? estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? deliveryDriverId;
  final String? deliveryDriverName;
  final String? deliveryDriverPhone;
  final String? trackingNumber;
  final Map<String, dynamic>? trackingData;
  final List<OrderStatusUpdateModel> statusHistory;
  final OrderRatingModel? rating;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.restaurantPhoneNumber,
    required this.status,
    required this.paymentStatus,
    required this.deliveryStatus,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tax,
    required this.tip,
    required this.discount,
    required this.total,
    required this.currency,
    required this.deliveryAddress,
    this.deliveryInstructions,
    this.specialInstructions,
    required this.paymentMethod,
    this.paymentIntentId,
    this.paymentTransactionId,
    this.scheduledDeliveryTime,
    this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.deliveryDriverId,
    this.deliveryDriverName,
    this.deliveryDriverPhone,
    this.trackingNumber,
    this.trackingData,
    required this.statusHistory,
    this.rating,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
  
  OrderModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImageUrl,
    String? restaurantPhoneNumber,
    String? status,
    String? paymentStatus,
    String? deliveryStatus,
    List<OrderItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? serviceFee,
    double? tax,
    double? tip,
    double? discount,
    double? total,
    String? currency,
    AddressModel? deliveryAddress,
    String? deliveryInstructions,
    String? specialInstructions,
    String? paymentMethod,
    String? paymentIntentId,
    String? paymentTransactionId,
    DateTime? scheduledDeliveryTime,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? deliveryDriverId,
    String? deliveryDriverName,
    String? deliveryDriverPhone,
    String? trackingNumber,
    Map<String, dynamic>? trackingData,
    List<OrderStatusUpdateModel>? statusHistory,
    OrderRatingModel? rating,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      restaurantPhoneNumber: restaurantPhoneNumber ?? this.restaurantPhoneNumber,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      tax: tax ?? this.tax,
      tip: tip ?? this.tip,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      paymentTransactionId: paymentTransactionId ?? this.paymentTransactionId,
      scheduledDeliveryTime: scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      deliveryDriverId: deliveryDriverId ?? this.deliveryDriverId,
      deliveryDriverName: deliveryDriverName ?? this.deliveryDriverName,
      deliveryDriverPhone: deliveryDriverPhone ?? this.deliveryDriverPhone,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      trackingData: trackingData ?? this.trackingData,
      statusHistory: statusHistory ?? this.statusHistory,
      rating: rating ?? this.rating,
      metadata: metadata ?? this.metadata,
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
  
  bool get canBeCancelled => ['pending', 'confirmed'].contains(status);
  bool get canBeRated => status == 'delivered' && rating == null;
  bool get isDelivered => status == 'delivered';
  bool get isCancelled => status == 'cancelled';
  
  @override
  List<Object?> get props => [
    id,
    userId,
    restaurantId,
    restaurantName,
    restaurantImageUrl,
    restaurantPhoneNumber,
    status,
    paymentStatus,
    deliveryStatus,
    items,
    subtotal,
    deliveryFee,
    serviceFee,
    tax,
    tip,
    discount,
    total,
    currency,
    deliveryAddress,
    deliveryInstructions,
    specialInstructions,
    paymentMethod,
    paymentIntentId,
    paymentTransactionId,
    scheduledDeliveryTime,
    estimatedDeliveryTime,
    actualDeliveryTime,
    deliveryDriverId,
    deliveryDriverName,
    deliveryDriverPhone,
    trackingNumber,
    trackingData,
    statusHistory,
    rating,
    metadata,
    createdAt,
    updatedAt,
  ];
}

@JsonSerializable()
class OrderItemModel extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final String? imageUrl;
  final double price;
  final int quantity;
  final String currency;
  final List<OrderItemOptionModel> selectedOptions;
  final List<OrderItemAddonModel> selectedAddons;
  final String? specialInstructions;
  final double totalPrice;
  
  const OrderItemModel({
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
  
  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
  
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
class OrderItemOptionModel extends Equatable {
  final String id;
  final String name;
  final String type;
  final List<OrderItemOptionChoiceModel> selectedChoices;
  
  const OrderItemOptionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.selectedChoices,
  });
  
  factory OrderItemOptionModel.fromJson(Map<String, dynamic> json) => _$OrderItemOptionModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemOptionModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, type, selectedChoices];
}

@JsonSerializable()
class OrderItemOptionChoiceModel extends Equatable {
  final String id;
  final String name;
  final double price;
  
  const OrderItemOptionChoiceModel({
    required this.id,
    required this.name,
    required this.price,
  });
  
  factory OrderItemOptionChoiceModel.fromJson(Map<String, dynamic> json) => _$OrderItemOptionChoiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemOptionChoiceModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, price];
}

@JsonSerializable()
class OrderItemAddonModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int quantity;
  
  const OrderItemAddonModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.quantity,
  });
  
  factory OrderItemAddonModel.fromJson(Map<String, dynamic> json) => _$OrderItemAddonModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderItemAddonModelToJson(this);
  
  @override
  List<Object?> get props => [id, name, description, price, currency, quantity];
}

@JsonSerializable()
class OrderStatusUpdateModel extends Equatable {
  final String id;
  final String orderId;
  final String status;
  final String message;
  final DateTime timestamp;
  final String? updatedBy;
  final Map<String, dynamic>? metadata;
  
  const OrderStatusUpdateModel({
    required this.id,
    required this.orderId,
    required this.status,
    required this.message,
    required this.timestamp,
    this.updatedBy,
    this.metadata,
  });
  
  factory OrderStatusUpdateModel.fromJson(Map<String, dynamic> json) => _$OrderStatusUpdateModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderStatusUpdateModelToJson(this);
  
  @override
  List<Object?> get props => [id, orderId, status, message, timestamp, updatedBy, metadata];
}

@JsonSerializable()
class OrderRatingModel extends Equatable {
  final String id;
  final String orderId;
  final double foodRating;
  final double deliveryRating;
  final double overallRating;
  final String? comment;
  final List<String>? tags;
  final DateTime createdAt;
  
  const OrderRatingModel({
    required this.id,
    required this.orderId,
    required this.foodRating,
    required this.deliveryRating,
    required this.overallRating,
    this.comment,
    this.tags,
    required this.createdAt,
  });
  
  factory OrderRatingModel.fromJson(Map<String, dynamic> json) => _$OrderRatingModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderRatingModelToJson(this);
  
  @override
  List<Object?> get props => [id, orderId, foodRating, deliveryRating, overallRating, comment, tags, createdAt];
}

