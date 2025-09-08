import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Column(
          children: [
            _buildPaymentOption(
              'credit_card',
              'Credit Card',
              Icons.credit_card,
              'Pay with your credit card',
            ),
            _buildPaymentOption(
              'debit_card',
              'Debit Card',
              Icons.account_balance_wallet,
              'Pay with your debit card',
            ),
            _buildPaymentOption(
              'paypal',
              'PayPal',
              Icons.payment,
              'Pay with PayPal',
            ),
            _buildPaymentOption(
              'apple_pay',
              'Apple Pay',
              Icons.apple,
              'Pay with Apple Pay',
            ),
            _buildPaymentOption(
              'google_pay',
              'Google Pay',
              Icons.g_mobiledata,
              'Pay with Google Pay',
            ),
            _buildPaymentOption(
              'cash',
              'Cash on Delivery',
              Icons.money,
              'Pay when your order arrives',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = selectedMethod == value;
    
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      elevation: isSelected ? 4 : 1,
      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
      child: RadioListTile<String>(
        value: value,
        groupValue: selectedMethod,
        onChanged: (value) {
          if (value != null) {
            onMethodChanged(value);
          }
        },
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodySmall,
        ),
        secondary: Icon(
          icon,
          color: isSelected ? AppTheme.primaryColor : null,
        ),
        activeColor: AppTheme.primaryColor,
      ),
    );
  }
}
