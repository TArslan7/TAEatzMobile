import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final String id;
  final String userId;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final String? paymentIntentId;
  final String? clientSecret;
  final String? lastPaymentError;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? updatedAt;
  final String? failureReason;
  final RefundEntity? refund;

  const PaymentEntity({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.status,
    this.transactionId,
    this.paymentIntentId,
    this.clientSecret,
    this.lastPaymentError,
    this.metadata = const {},
    required this.createdAt,
    this.completedAt,
    this.updatedAt,
    this.failureReason,
    this.refund,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    orderId,
    amount,
    currency,
    method,
    status,
    transactionId,
    paymentIntentId,
    clientSecret,
    lastPaymentError,
    metadata,
    createdAt,
    completedAt,
    updatedAt,
    failureReason,
    refund,
  ];
}

enum PaymentMethod {
  creditCard,
  debitCard,
  applePay,
  googlePay,
  paypal,
  bankTransfer,
  cash,
  wallet,
  crypto,
  buyNowPayLater,
}

enum PaymentStatus {
  pending,
  processing,
  succeeded,
  failed,
  cancelled,
  refunded,
  partiallyRefunded,
}

class PaymentMethodEntity extends Equatable {
  final String id;
  final String userId;
  final PaymentMethod type;
  final String displayName;
  final String? lastFourDigits;
  final String? last4;
  final String? expiryMonth;
  final String? expMonth;
  final String? expiryYear;
  final String? expYear;
  final String? brand;
  final bool isDefault;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const PaymentMethodEntity({
    required this.id,
    required this.userId,
    required this.type,
    required this.displayName,
    this.lastFourDigits,
    this.last4,
    this.expiryMonth,
    this.expMonth,
    this.expiryYear,
    this.expYear,
    this.brand,
    this.isDefault = false,
    this.isVerified = false,
    required this.createdAt,
    this.lastUsedAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    type,
    displayName,
    lastFourDigits,
    last4,
    expiryMonth,
    expMonth,
    expiryYear,
    expYear,
    brand,
    isDefault,
    isVerified,
    createdAt,
    lastUsedAt,
  ];
}

class RefundEntity extends Equatable {
  final String id;
  final String paymentId;
  final String orderId;
  final double amount;
  final String reason;
  final RefundStatus status;
  final String? refundId;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? failureReason;

  const RefundEntity({
    required this.id,
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.reason,
    required this.status,
    this.refundId,
    required this.createdAt,
    this.processedAt,
    this.failureReason,
  });

  @override
  List<Object?> get props => [
    id,
    paymentId,
    orderId,
    amount,
    reason,
    status,
    refundId,
    createdAt,
    processedAt,
    failureReason,
  ];
}

enum RefundStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}

class SplitBillEntity extends Equatable {
  final String id;
  final String orderId;
  final String createdBy;
  final List<SplitBillParticipantEntity> participants;
  final double totalAmount;
  final SplitBillStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? description;

  const SplitBillEntity({
    required this.id,
    required this.orderId,
    required this.createdBy,
    required this.participants,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.completedAt,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    createdBy,
    participants,
    totalAmount,
    status,
    createdAt,
    completedAt,
    description,
  ];
}

class SplitBillParticipantEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userEmail;
  final String? userPhone;
  final double amount;
  final SplitBillParticipantStatus status;
  final String? paymentId;
  final DateTime? paidAt;

  const SplitBillParticipantEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userEmail,
    this.userPhone,
    required this.amount,
    required this.status,
    this.paymentId,
    this.paidAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    userEmail,
    userPhone,
    amount,
    status,
    paymentId,
    paidAt,
  ];
}

enum SplitBillStatus {
  pending,
  collecting,
  completed,
  cancelled,
  expired,
}

enum SplitBillParticipantStatus {
  pending,
  paid,
  failed,
  cancelled,
}

class TipEntity extends Equatable {
  final String id;
  final String orderId;
  final String userId;
  final double amount;
  final TipType type;
  final String? message;
  final DateTime createdAt;
  final String? paymentId;

  const TipEntity({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.type,
    this.message,
    required this.createdAt,
    this.paymentId,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    userId,
    amount,
    type,
    message,
    createdAt,
    paymentId,
  ];
}

enum TipType {
  percentage,
  fixed,
  custom,
}

class WalletEntity extends Equatable {
  final String id;
  final String userId;
  final double balance;
  final String currency;
  final List<WalletTransactionEntity> recentTransactions;
  final DateTime lastUpdated;

  const WalletEntity({
    required this.id,
    required this.userId,
    required this.balance,
    required this.currency,
    this.recentTransactions = const [],
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    balance,
    currency,
    recentTransactions,
    lastUpdated,
  ];
}

class WalletTransactionEntity extends Equatable {
  final String id;
  final String walletId;
  final double amount;
  final WalletTransactionType type;
  final String description;
  final String? relatedId;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const WalletTransactionEntity({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    required this.description,
    this.relatedId,
    required this.createdAt,
    this.metadata = const {},
  });

  @override
  List<Object?> get props => [
    id,
    walletId,
    amount,
    type,
    description,
    relatedId,
    createdAt,
    metadata,
  ];
}

enum WalletTransactionType {
  deposit,
  withdrawal,
  payment,
  refund,
  bonus,
  reward,
  transfer,
}

class PaymentPromotionEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final double discountAmount;
  final double? discountPercentage;
  final double minimumOrderAmount;
  final DateTime validFrom;
  final DateTime validUntil;
  final List<PaymentMethod> applicableMethods;
  final List<String> applicableRestaurants;
  final int usageLimit;
  final int usedCount;
  final bool isActive;

  const PaymentPromotionEntity({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.discountAmount,
    this.discountPercentage,
    required this.minimumOrderAmount,
    required this.validFrom,
    required this.validUntil,
    this.applicableMethods = const [],
    this.applicableRestaurants = const [],
    required this.usageLimit,
    this.usedCount = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    imageUrl,
    discountAmount,
    discountPercentage,
    minimumOrderAmount,
    validFrom,
    validUntil,
    applicableMethods,
    applicableRestaurants,
    usageLimit,
    usedCount,
    isActive,
  ];
}

class PaymentSecurityEntity extends Equatable {
  final String id;
  final String userId;
  final String deviceId;
  final String deviceName;
  final String? deviceLocation;
  final DateTime lastUsedAt;
  final bool isTrusted;
  final bool isBlocked;
  final List<String> securityFlags;

  const PaymentSecurityEntity({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.deviceName,
    this.deviceLocation,
    required this.lastUsedAt,
    this.isTrusted = false,
    this.isBlocked = false,
    this.securityFlags = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    deviceId,
    deviceName,
    deviceLocation,
    lastUsedAt,
    isTrusted,
    isBlocked,
    securityFlags,
  ];
}