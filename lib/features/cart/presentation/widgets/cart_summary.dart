import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/cart_entity.dart';

class CartSummary extends StatelessWidget {
  final CartEntity cart;
  final VoidCallback? onCheckout;

  const CartSummary({
    super.key,
    required this.cart,
    this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppTheme.bodyMedium,
              ),
              Text(
                cart.formattedSubtotal,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee',
                style: AppTheme.bodyMedium,
              ),
              Text(
                cart.formattedDeliveryFee,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax (21%)',
                style: AppTheme.bodyMedium,
              ),
              Text(
                cart.formattedTax,
                style: AppTheme.bodyMedium,
              ),
            ],
          ),
          
          const Divider(),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTheme.heading6.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                cart.formattedTotal,
                style: AppTheme.heading6.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingM),
          
          // Checkout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: cart.isEmpty ? null : onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingM),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                ),
              ),
              child: Text(
                cart.isEmpty ? 'Cart is Empty' : 'Checkout',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
