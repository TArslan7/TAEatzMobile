import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/cart_model.dart';

abstract class CartLocalDataSource {
  Future<CartModel?> getCart();
  Future<void> saveCart(CartModel cart);
  Future<void> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CART_KEY = 'cart';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<CartModel?> getCart() async {
    final cartJson = sharedPreferences.getString(CART_KEY);
    if (cartJson != null) {
      final cartMap = json.decode(cartJson) as Map<String, dynamic>;
      return CartModel.fromJson(cartMap);
    }
    return null;
  }

  @override
  Future<void> saveCart(CartModel cart) async {
    final cartJson = json.encode(cart.toJson());
    await sharedPreferences.setString(CART_KEY, cartJson);
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(CART_KEY);
  }
}


