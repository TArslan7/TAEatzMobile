import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../checkout/presentation/pages/simple_checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded && !state.cart.isEmpty) {
                return TextButton(
                  onPressed: () {
                    context.read<CartBloc>().add(const ClearCart());
                  },
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppTheme.errorColor,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    state.message,
                    style: AppTheme.heading6,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(const GetCart());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          
          if (state is CartLoaded) {
            if (state.cart.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: AppTheme.textTertiaryColor,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      'Your cart is empty',
                      style: AppTheme.heading6.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      'Add some delicious items to get started!',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textTertiaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            
            return Column(
              children: [
                // Cart Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    itemCount: state.cart.items.length,
                    itemBuilder: (context, index) {
                      final item = state.cart.items[index];
                      return CartItemCard(
                        item: item,
                        onIncrement: () {
                          context.read<CartBloc>().add(
                            UpdateItemQuantity(item.id, item.quantity + 1),
                          );
                        },
                        onDecrement: () {
                          context.read<CartBloc>().add(
                            UpdateItemQuantity(item.id, item.quantity - 1),
                          );
                        },
                        onRemove: () {
                          context.read<CartBloc>().add(
                            RemoveItemFromCart(item.id),
                          );
                        },
                        onSpecialInstructionsChanged: (instructions) {
                          context.read<CartBloc>().add(
                            UpdateSpecialInstructions(item.id, instructions),
                          );
                        },
                      );
                    },
                  ),
                ),
                
                // Cart Summary
                CartSummary(
                  cart: state.cart,
                  onCheckout: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SimpleCheckoutPage(),
                      ),
                    );
                  },
                ),
              ],
            );
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
