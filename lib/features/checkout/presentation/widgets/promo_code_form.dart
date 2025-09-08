import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PromoCodeForm extends StatelessWidget {
  final TextEditingController controller;

  const PromoCodeForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Promo Code',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppTheme.spacingS),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter promo code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_offer),
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingS),
            ElevatedButton(
              onPressed: () {
                // TODO: Validate promo code
                if (controller.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Promo code applied!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingS,
                ),
              ),
              child: const Text('Apply'),
            ),
          ],
        ),
      ],
    );
  }
}
