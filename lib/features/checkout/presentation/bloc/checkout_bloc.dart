import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../orders/domain/entities/order_entity.dart' as order_entity;
import '../../../orders/domain/enums/order_enums.dart';
import '../../../orders/domain/usecases/create_order.dart';
import '../../../payment/domain/entities/payment_entity.dart' as payment_entity;
import '../../../payment/domain/usecases/create_payment_intent.dart';
import '../../../payment/domain/usecases/confirm_payment.dart' as confirm_payment_usecase;
import 'checkout_event.dart' as checkout_event;
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<checkout_event.CheckoutEvent, CheckoutState> {
  final CreateOrder createOrder;
  final CreatePaymentIntent createPaymentIntent;
  final confirm_payment_usecase.ConfirmPayment confirmPayment;

  CheckoutBloc({
    required this.createOrder,
    required this.createPaymentIntent,
    required this.confirmPayment,
  }  ) : super(CheckoutInitial()) {
    on<checkout_event.ProceedToPayment>(_onProceedToPayment);
    on<checkout_event.ConfirmPayment>(_onConfirmPayment);
    on<checkout_event.CancelOrder>(_onCancelOrder);
  }

  Future<void> _onProceedToPayment(
    checkout_event.ProceedToPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutProcessing());

    try {
      // Create order
      final order = _createOrderFromCart(event);
      final orderResult = await createOrder(order);
      
      if (orderResult.isLeft()) {
        final failure = orderResult.fold((l) => l, (r) => throw Exception());
        emit(CheckoutError(message: _mapFailureToMessage(failure)));
        return;
      }

      final createdOrder = orderResult.fold((l) => throw Exception(), (r) => r);

      // Create payment intent
      final paymentResult = await createPaymentIntent(
        orderId: createdOrder.id,
        userId: createdOrder.userId,
        amount: createdOrder.totalAmount,
        currency: 'EUR',
        method: _mapStringToPaymentMethodEntity(event.paymentMethod),
      );

      if (paymentResult.isLeft()) {
        final failure = paymentResult.fold((l) => l, (r) => throw Exception());
        emit(CheckoutError(message: _mapFailureToMessage(failure)));
        return;
      }

      final payment = paymentResult.fold((l) => throw Exception(), (r) => r);

      // For now, we'll simulate successful payment
      // In a real app, you would handle the payment confirmation here
      emit(CheckoutSuccess(order: createdOrder));
    } catch (e) {
      emit(CheckoutError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _onConfirmPayment(
    checkout_event.ConfirmPayment event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutProcessing());

    try {
      final paymentResult = await confirmPayment(
        paymentIntentId: event.paymentIntentId,
        clientSecret: event.clientSecret,
      );

      if (paymentResult.isLeft()) {
        final failure = paymentResult.fold((l) => l, (r) => throw Exception());
        emit(CheckoutError(message: _mapFailureToMessage(failure)));
        return;
      }

      // Payment confirmed successfully
      // You would typically update the order status here
      final now = DateTime.now();
      emit(CheckoutSuccess(order: order_entity.OrderEntity(
        id: 'temp',
        userId: 'temp',
        restaurantId: 'temp',
        restaurantName: 'temp',
        restaurantImageUrl: 'temp',
        items: [],
        subtotal: 0,
        taxAmount: 0,
        deliveryFee: 0,
        tipAmount: 0,
        totalAmount: 0,
        status: OrderStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.creditCard,
        deliveryAddress: 'temp',
        estimatedDeliveryTime: now.add(const Duration(minutes: 30)),
        createdAt: now,
        updatedAt: now,
      )));
    } catch (e) {
      emit(CheckoutError(message: 'Unexpected error: $e'));
    }
  }

  Future<void> _onCancelOrder(
    checkout_event.CancelOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(CheckoutProcessing());
    
    // TODO: Implement order cancellation
    emit(CheckoutError(message: 'Order cancellation not implemented'));
  }

  order_entity.OrderEntity _createOrderFromCart(checkout_event.ProceedToPayment event) {
    final now = DateTime.now();
    final estimatedDelivery = now.add(const Duration(minutes: 30));

    return order_entity.OrderEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // TODO: Get from auth
      restaurantId: 'restaurant_id', // TODO: Get from cart context
      restaurantName: 'Restaurant Name', // TODO: Get from cart context
      restaurantImageUrl: '', // TODO: Get from cart context
      items: event.cart.items.map((cartItem) => order_entity.OrderItemEntity(
        id: cartItem.id,
        menuItemId: cartItem.menuItemId,
        name: cartItem.name,
        description: cartItem.description,
        imageUrl: cartItem.imageUrl,
        basePrice: cartItem.basePrice,
        quantity: cartItem.quantity,
        selectedOptions: cartItem.selectedOptions.map((option) => order_entity.OrderItemOptionEntity(
          id: option.id,
          name: option.name,
          value: option.value,
          price: option.price,
        )).toList(),
        specialInstructions: cartItem.specialInstructions,
        totalPrice: cartItem.totalPrice,
      )).toList(),
      subtotal: event.cart.subtotal,
      taxAmount: event.cart.taxAmount,
      deliveryFee: event.cart.deliveryFee,
      tipAmount: event.tipAmount,
      totalAmount: event.cart.totalAmount + event.tipAmount,
      status: OrderStatus.pending,
      paymentStatus: PaymentStatus.pending,
      paymentMethod: _mapStringToPaymentMethod(event.paymentMethod),
      deliveryAddress: event.deliveryAddress,
      deliveryInstructions: event.deliveryInstructions,
      specialInstructions: null,
      promoCode: event.promoCode,
      discountAmount: 0.0, // TODO: Calculate discount
      estimatedDeliveryTime: estimatedDelivery,
      createdAt: now,
      updatedAt: now,
    );
  }

  PaymentMethod _mapStringToPaymentMethod(String method) {
    switch (method) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'debit_card':
        return PaymentMethod.debitCard;
      case 'paypal':
        return PaymentMethod.paypal;
      case 'apple_pay':
        return PaymentMethod.applePay;
      case 'google_pay':
        return PaymentMethod.googlePay;
      case 'cash':
        return PaymentMethod.cash;
      default:
        return PaymentMethod.creditCard;
    }
  }

  payment_entity.PaymentMethod _mapStringToPaymentMethodEntity(String method) {
    switch (method) {
      case 'credit_card':
        return payment_entity.PaymentMethod.creditCard;
      case 'debit_card':
        return payment_entity.PaymentMethod.debitCard;
      case 'paypal':
        return payment_entity.PaymentMethod.paypal;
      case 'apple_pay':
        return payment_entity.PaymentMethod.applePay;
      case 'google_pay':
        return payment_entity.PaymentMethod.googlePay;
      case 'cash':
        return payment_entity.PaymentMethod.cash;
      default:
        return payment_entity.PaymentMethod.creditCard;
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is PaymentFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is UnimplementedFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred';
    }
  }
}
