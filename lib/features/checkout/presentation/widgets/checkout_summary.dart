import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cart/domain/entities/cart_entity.dart';

class CheckoutSummary extends StatelessWidget {
  final CartEntity cart;
  final double tipAmount;
  final String? promoCode;

  const CheckoutSummary({
    super.key,
    required this.cart,
    required this.tipAmount,
    this.promoCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: AppTheme.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
            
            // Items
            ...cart.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacingS),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.name}',
                      style: AppTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    '€${item.totalPrice.toStringAsFixed(2)}',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )),
            
            const Divider(),
            
            // Subtotal
            _buildSummaryRow('Subtotal', cart.subtotal),
            
            // Tax
            _buildSummaryRow('Tax (21%)', cart.taxAmount),
            
            // Delivery Fee
            _buildSummaryRow('Delivery Fee', cart.deliveryFee),
            
            // Tip
            if (tipAmount > 0)
              _buildSummaryRow('Tip', tipAmount),
            
            // Promo Code Discount
            if (promoCode != null)
              _buildSummaryRow('Promo Code ($promoCode)', -5.0, isDiscount: true),
            
            const Divider(thickness: 2),
            
            // Total
            _buildSummaryRow(
              'Total',
              cart.totalAmount + tipAmount - (promoCode != null ? 5.0 : 0.0),
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingXS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal 
                ? AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : AppTheme.bodyMedium,
          ),
          Text(
            '${isDiscount ? '-' : ''}€${amount.toStringAsFixed(2)}',
            style: (isTotal 
                ? AppTheme.bodyLarge 
                : AppTheme.bodyMedium).copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
}
