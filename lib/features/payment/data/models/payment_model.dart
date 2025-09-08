import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/payment_entity.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  final String id;
  final String orderId;
  final String userId;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? paymentIntentId;
  final String? clientSecret;
  final String? lastPaymentError;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.paymentIntentId,
    this.clientSecret,
    this.lastPaymentError,
    this.metadata = const {},
    required this.createdAt,
    this.updatedAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);

  factory PaymentModel.fromEntity(PaymentEntity entity) {
    return PaymentModel(
      id: entity.id,
      orderId: entity.orderId,
      userId: entity.userId,
      amount: entity.amount,
      currency: entity.currency,
      method: entity.method,
      status: entity.status,
      paymentIntentId: entity.paymentIntentId,
      clientSecret: entity.clientSecret,
      lastPaymentError: entity.lastPaymentError,
      metadata: entity.metadata,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt ?? entity.createdAt,
    );
  }

  PaymentEntity toEntity() {
    return PaymentEntity(
      id: id,
      orderId: orderId,
      userId: userId,
      amount: amount,
      currency: currency,
      method: method,
      status: status,
      paymentIntentId: paymentIntentId,
      clientSecret: clientSecret,
      lastPaymentError: lastPaymentError,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@JsonSerializable()
class PaymentMethodModel {
  final String id;
  final String userId;
  final PaymentMethod type;
  final String? last4;
  final String? brand;
  final String? expMonth;
  final String? expYear;
  final String displayName;
  final bool isDefault;
  final DateTime createdAt;

  const PaymentMethodModel({
    required this.id,
    required this.userId,
    required this.type,
    this.last4,
    this.brand,
    this.expMonth,
    this.expYear,
    required this.displayName,
    required this.isDefault,
    required this.createdAt,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) => _$PaymentMethodModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      last4: entity.last4,
      brand: entity.brand,
      expMonth: entity.expMonth,
      expYear: entity.expYear,
      displayName: entity.displayName,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
    );
  }

  PaymentMethodEntity toEntity() {
    return PaymentMethodEntity(
      id: id,
      userId: userId,
      type: type,
      displayName: displayName,
      last4: last4,
      brand: brand,
      expMonth: expMonth,
      expYear: expYear,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }
}
