import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<OrderItemModel> items;
  final double subtotal;
  final double taxAmount;
  final double deliveryFee;
  final double tipAmount;
  final double totalAmount;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final String? paymentIntentId;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final String? specialInstructions;
  final String? promoCode;
  final double? discountAmount;
  final DateTime estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String? deliveryDriverId;
  final String? deliveryDriverName;
  final String? deliveryDriverPhone;
  final String? trackingUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantImageUrl,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.deliveryFee,
    required this.tipAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    this.paymentIntentId,
    required this.deliveryAddress,
    this.deliveryInstructions,
    this.specialInstructions,
    this.promoCode,
    this.discountAmount,
    required this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.deliveryDriverId,
    this.deliveryDriverName,
    this.deliveryDriverPhone,
    this.trackingUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
      restaurantImageUrl: entity.restaurantImageUrl,
      items: entity.items.map((item) => OrderItemModel.fromEntity(item)).toList(),
      subtotal: entity.subtotal,
      taxAmount: entity.taxAmount,
      deliveryFee: entity.deliveryFee,
      tipAmount: entity.tipAmount,
      totalAmount: entity.totalAmount,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      paymentMethod: entity.paymentMethod,
      paymentIntentId: entity.paymentIntentId,
      deliveryAddress: entity.deliveryAddress,
      deliveryInstructions: entity.deliveryInstructions,
      specialInstructions: entity.specialInstructions,
      promoCode: entity.promoCode,
      discountAmount: entity.discountAmount,
      estimatedDeliveryTime: entity.estimatedDeliveryTime,
      actualDeliveryTime: entity.actualDeliveryTime,
      deliveryDriverId: entity.deliveryDriverId,
      deliveryDriverName: entity.deliveryDriverName,
      deliveryDriverPhone: entity.deliveryDriverPhone,
      trackingUrl: entity.trackingUrl,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      restaurantImageUrl: restaurantImageUrl,
      items: items.map((item) => item.toEntity()).toList(),
      subtotal: subtotal,
      taxAmount: taxAmount,
      deliveryFee: deliveryFee,
      tipAmount: tipAmount,
      totalAmount: totalAmount,
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      paymentIntentId: paymentIntentId,
      deliveryAddress: deliveryAddress,
      deliveryInstructions: deliveryInstructions,
      specialInstructions: specialInstructions,
      promoCode: promoCode,
      discountAmount: discountAmount,
      estimatedDeliveryTime: estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime,
      deliveryDriverId: deliveryDriverId,
      deliveryDriverName: deliveryDriverName,
      deliveryDriverPhone: deliveryDriverPhone,
      trackingUrl: trackingUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  OrderModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImageUrl,
    List<OrderItemModel>? items,
    double? subtotal,
    double? taxAmount,
    double? deliveryFee,
    double? tipAmount,
    double? totalAmount,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    String? paymentIntentId,
    String? deliveryAddress,
    String? deliveryInstructions,
    String? specialInstructions,
    String? promoCode,
    double? discountAmount,
    DateTime? estimatedDeliveryTime,
    DateTime? actualDeliveryTime,
    String? deliveryDriverId,
    String? deliveryDriverName,
    String? deliveryDriverPhone,
    String? trackingUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tipAmount: tipAmount ?? this.tipAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentIntentId: paymentIntentId ?? this.paymentIntentId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      promoCode: promoCode ?? this.promoCode,
      discountAmount: discountAmount ?? this.discountAmount,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      deliveryDriverId: deliveryDriverId ?? this.deliveryDriverId,
      deliveryDriverName: deliveryDriverName ?? this.deliveryDriverName,
      deliveryDriverPhone: deliveryDriverPhone ?? this.deliveryDriverPhone,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

@JsonSerializable()
class OrderItemModel {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final String? imageUrl;
  final double basePrice;
  final int quantity;
  final List<OrderItemOptionModel> selectedOptions;
  final String? specialInstructions;
  final double totalPrice;

  const OrderItemModel({
    required this.id,
    required this.menuItemId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.basePrice,
    required this.quantity,
    required this.selectedOptions,
    this.specialInstructions,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      id: entity.id,
      menuItemId: entity.menuItemId,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      basePrice: entity.basePrice,
      quantity: entity.quantity,
      selectedOptions: entity.selectedOptions.map((option) => OrderItemOptionModel.fromEntity(option)).toList(),
      specialInstructions: entity.specialInstructions,
      totalPrice: entity.totalPrice,
    );
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
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
}

@JsonSerializable()
class OrderItemOptionModel {
  final String id;
  final String name;
  final String value;
  final double price;

  const OrderItemOptionModel({
    required this.id,
    required this.name,
    required this.value,
    required this.price,
  });

  factory OrderItemOptionModel.fromJson(Map<String, dynamic> json) => _$OrderItemOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemOptionModelToJson(this);

  factory OrderItemOptionModel.fromEntity(OrderItemOptionEntity entity) {
    return OrderItemOptionModel(
      id: entity.id,
      name: entity.name,
      value: entity.value,
      price: entity.price,
    );
  }

  OrderItemOptionEntity toEntity() {
    return OrderItemOptionEntity(
      id: id,
      name: name,
      value: value,
      price: price,
    );
  }
}
