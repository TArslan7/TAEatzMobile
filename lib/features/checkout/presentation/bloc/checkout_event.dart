import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_entity.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class ProceedToPayment extends CheckoutEvent {
  final CartEntity cart;
  final String deliveryAddress;
  final String? deliveryInstructions;
  final String paymentMethod;
  final double tipAmount;
  final String? promoCode;

  const ProceedToPayment({
    required this.cart,
    required this.deliveryAddress,
    this.deliveryInstructions,
    required this.paymentMethod,
    required this.tipAmount,
    this.promoCode,
  });

  @override
  List<Object?> get props => [
        cart,
        deliveryAddress,
        deliveryInstructions,
        paymentMethod,
        tipAmount,
        promoCode,
      ];
}

class ConfirmPayment extends CheckoutEvent {
  final String paymentIntentId;
  final String clientSecret;

  const ConfirmPayment({
    required this.paymentIntentId,
    required this.clientSecret,
  });

  @override
  List<Object?> get props => [paymentIntentId, clientSecret];
}

class CancelOrder extends CheckoutEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}




