import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class DeliveryAddressForm extends StatelessWidget {
  final TextEditingController controller;

  const DeliveryAddressForm({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: AppTheme.spacingS),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your delivery address',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your delivery address';
            }
            return null;
          },
          maxLines: 2,
        ),
      ],
    );
  }
}
