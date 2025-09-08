import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../cart/presentation/bloc/cart_event.dart';
import '../../../orders/presentation/bloc/orders_bloc.dart';
import '../../../orders/presentation/bloc/orders_event.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/enums/order_enums.dart';

class SimpleCheckoutPage extends StatefulWidget {
  const SimpleCheckoutPage({super.key});

  @override
  State<SimpleCheckoutPage> createState() => _SimpleCheckoutPageState();
}

class _SimpleCheckoutPageState extends State<SimpleCheckoutPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  PaymentMethod _selectedPaymentMethod = PaymentMethod.creditCard;
  bool _isPlacingOrder = false;

  @override
  void initState() {
    super.initState();
    _addressController.text = '123 Main St, Amsterdam, 1012 AB'; // Default address
  }

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoaded && !state.cart.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Delivery Address
                  Text(
                    'Delivery Address',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      hintText: 'Enter delivery address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Special Instructions
                  Text(
                    'Special Instructions',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  TextField(
                    controller: _instructionsController,
                    decoration: const InputDecoration(
                      hintText: 'Any special instructions?',
                      prefixIcon: Icon(Icons.note),
                    ),
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Payment Method
                  Text(
                    'Payment Method',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  ...PaymentMethod.values.map((method) => RadioListTile<PaymentMethod>(
                    title: Text(_getPaymentMethodText(method)),
                    subtitle: Text(_getPaymentMethodDescription(method)),
                    value: method,
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  )),
                  
                  const SizedBox(height: AppTheme.spacingL),
                  
                  // Order Summary
                  Text(
                    'Order Summary',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Subtotal:', style: AppTheme.bodyMedium),
                              Text('€${state.cart.subtotal.toStringAsFixed(2)}', style: AppTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Fee:', style: AppTheme.bodyMedium),
                              Text('€${state.cart.deliveryFee.toStringAsFixed(2)}', style: AppTheme.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tax:', style: AppTheme.bodyMedium),
                              Text('€${state.cart.taxAmount.toStringAsFixed(2)}', style: AppTheme.bodyMedium),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:', style: AppTheme.heading6),
                              Text('€${state.cart.totalAmount.toStringAsFixed(2)}', 
                                   style: AppTheme.heading6.copyWith(color: AppTheme.primaryColor)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isPlacingOrder ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                      ),
                      child: _isPlacingOrder
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Place Order - €${state.cart.totalAmount.toStringAsFixed(2)}',
                              style: AppTheme.button,
                            ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text('Your cart is empty'),
            );
          }
        },
      ),
    );
  }

  void _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
    });

    // Get cart state
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      // Create order from cart
      final order = OrderEntity(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'user_1', // TODO: Get actual user ID
        restaurantId: cartState.cart.restaurantId,
        restaurantName: cartState.cart.restaurantName,
        restaurantImageUrl: cartState.cart.restaurantImageUrl,
        items: cartState.cart.items.map((cartItem) => OrderItemEntity(
          id: cartItem.id,
          menuItemId: cartItem.menuItemId,
          name: cartItem.name,
          description: cartItem.description,
          imageUrl: cartItem.imageUrl,
          basePrice: cartItem.basePrice,
          quantity: cartItem.quantity,
          selectedOptions: cartItem.selectedOptions.map((option) => OrderItemOptionEntity(
            id: option.id,
            name: option.name,
            value: option.value,
            price: option.price,
          )).toList(),
          specialInstructions: cartItem.specialInstructions,
          totalPrice: cartItem.totalPrice,
        )).toList(),
        subtotal: cartState.cart.subtotal,
        taxAmount: cartState.cart.taxAmount,
        deliveryFee: cartState.cart.deliveryFee,
        tipAmount: 0.0, // No tip for now
        totalAmount: cartState.cart.totalAmount,
        status: OrderStatus.pending,
        paymentStatus: PaymentStatus.pending,
        paymentMethod: _selectedPaymentMethod,
        deliveryAddress: _addressController.text,
        deliveryInstructions: _instructionsController.text,
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add order to orders bloc
      context.read<OrdersBloc>().add(CreateOrder(order: order));
      
      // Clear cart
      context.read<CartBloc>().add(const ClearCart());
      
      // Show success message
      if (mounted) {
        context.showSnackBar('Order placed successfully!');
        Navigator.of(context).pop();
      }
    }

    setState(() {
      _isPlacingOrder = false;
    });
  }

  String _getPaymentMethodText(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.debitCard:
        return 'Debit Card';
      case PaymentMethod.paypal:
        return 'PayPal';
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.googlePay:
        return 'Google Pay';
      case PaymentMethod.cash:
        return 'Cash on Delivery';
    }
  }

  String _getPaymentMethodDescription(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'Pay with your credit card';
      case PaymentMethod.debitCard:
        return 'Pay with your debit card';
      case PaymentMethod.paypal:
        return 'Pay with PayPal';
      case PaymentMethod.applePay:
        return 'Pay with Apple Pay';
      case PaymentMethod.googlePay:
        return 'Pay with Google Pay';
      case PaymentMethod.cash:
        return 'Pay when your order arrives';
    }
  }
}
