import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/extensions.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/usecases/create_order.dart';
import '../../../payment/domain/entities/payment_entity.dart';
import '../../../payment/domain/usecases/create_payment_intent.dart';
import '../../../payment/domain/usecases/confirm_payment.dart';
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';
import '../widgets/checkout_summary.dart';
import '../widgets/delivery_address_form.dart';
import '../widgets/payment_method_selector.dart';
import '../widgets/promo_code_form.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _promoCodeController = TextEditingController();
  
  String _selectedPaymentMethod = 'credit_card';
  double _tipAmount = 0.0;
  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    _instructionsController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  void _proceedToPayment() {
    if (_formKey.currentState!.validate()) {
      final cartState = context.read<CartBloc>().state;
      if (cartState is CartLoaded) {
        context.read<CheckoutBloc>().add(ProceedToPayment(
          cart: cartState.cart,
          deliveryAddress: _addressController.text,
          deliveryInstructions: _instructionsController.text,
          paymentMethod: _selectedPaymentMethod,
          tipAmount: _tipAmount,
          promoCode: _promoCodeController.text.isNotEmpty ? _promoCodeController.text : null,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutProcessing) {
            setState(() {
              _isProcessing = true;
            });
          } else if (state is CheckoutSuccess) {
            setState(() {
              _isProcessing = false;
            });
            context.showSnackBar('Order placed successfully!');
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else if (state is CheckoutError) {
            setState(() {
              _isProcessing = false;
            });
            context.showSnackBar('Error: ${state.message}');
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            if (cartState is! CartLoaded || cartState.cart.isEmpty) {
              return const Center(
                child: Text('Your cart is empty'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address
                    DeliveryAddressForm(
                      controller: _addressController,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Delivery Instructions
                    Text(
                      'Delivery Instructions',
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    TextFormField(
                      controller: _instructionsController,
                      decoration: const InputDecoration(
                        hintText: 'Any special instructions for delivery?',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Payment Method
                    PaymentMethodSelector(
                      selectedMethod: _selectedPaymentMethod,
                      onMethodChanged: (method) {
                        setState(() {
                          _selectedPaymentMethod = method;
                        });
                      },
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Tip Amount
                    Text(
                      'Tip Amount',
                      style: AppTheme.heading3,
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _tipAmount,
                            min: 0.0,
                            max: 20.0,
                            divisions: 20,
                            label: '€${_tipAmount.toStringAsFixed(2)}',
                            onChanged: (value) {
                              setState(() {
                                _tipAmount = value;
                              });
                            },
                          ),
                        ),
                        Text(
                          '€${_tipAmount.toStringAsFixed(2)}',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Promo Code
                    PromoCodeForm(
                      controller: _promoCodeController,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingL),
                    
                    // Order Summary
                    CheckoutSummary(
                      cart: cartState.cart,
                      tipAmount: _tipAmount,
                      promoCode: _promoCodeController.text.isNotEmpty ? _promoCodeController.text : null,
                    ),
                    
                    const SizedBox(height: AppTheme.spacingXL),
                    
                    // Place Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _proceedToPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusL),
                          ),
                        ),
                        child: _isProcessing
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Place Order - €${(cartState.cart.totalAmount + _tipAmount).toStringAsFixed(2)}',
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
