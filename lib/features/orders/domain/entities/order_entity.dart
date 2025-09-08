import 'package:equatable/equatable.dart';
import '../enums/order_enums.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantImageUrl;
  final List<OrderItemEntity> items;
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

  const OrderEntity({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        restaurantId,
        restaurantName,
        restaurantImageUrl,
        items,
        subtotal,
        taxAmount,
        deliveryFee,
        tipAmount,
        totalAmount,
        status,
        paymentStatus,
        paymentMethod,
        paymentIntentId,
        deliveryAddress,
        deliveryInstructions,
        specialInstructions,
        promoCode,
        discountAmount,
        estimatedDeliveryTime,
        actualDeliveryTime,
        deliveryDriverId,
        deliveryDriverName,
        deliveryDriverPhone,
        trackingUrl,
        createdAt,
        updatedAt,
      ];

  OrderEntity copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    String? restaurantImageUrl,
    List<OrderItemEntity>? items,
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
    return OrderEntity(
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

class OrderItemEntity extends Equatable {
  final String id;
  final String menuItemId;
  final String name;
  final String description;
  final String? imageUrl;
  final double basePrice;
  final int quantity;
  final List<OrderItemOptionEntity> selectedOptions;
  final String? specialInstructions;
  final double totalPrice;

  const OrderItemEntity({
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

class OrderItemOptionEntity extends Equatable {
  final String id;
  final String name;
  final String value;
  final double price;

  const OrderItemOptionEntity({
    required this.id,
    required this.name,
    required this.value,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, value, price];
}
