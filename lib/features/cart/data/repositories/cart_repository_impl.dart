import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_datasource.dart';
import '../models/cart_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, CartEntity>> getCart() async {
    try {
      final cartModel = await localDataSource.getCart();
      if (cartModel != null) {
        return Right(cartModel.toEntity());
      } else {
        // Return empty cart
        final emptyCart = CartEntity(
          id: 'empty',
          restaurantId: '',
          restaurantName: '',
          restaurantImageUrl: '',
          items: [],
          subtotal: 0.0,
          deliveryFee: 0.0,
          tax: 0.0,
          total: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return Right(emptyCart);
      }
    } on CacheException {
      return Left(const CacheFailure(message: 'Failed to load cart'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addItemToCart(CartItemEntity item) async {
    try {
      final currentCart = await localDataSource.getCart();
      CartModel updatedCart;

      if (currentCart == null) {
        // Create new cart
        updatedCart = CartModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          restaurantId: '', // Will be set when adding first item
          restaurantName: '',
          restaurantImageUrl: '',
          items: [CartItemModel(
            id: item.id,
            menuItemId: item.menuItemId,
            name: item.name,
            description: item.description,
            imageUrl: item.imageUrl,
            basePrice: item.basePrice,
            quantity: item.quantity,
            selectedOptions: item.selectedOptions.map((option) => CartItemOptionModel(
              id: option.id,
              name: option.name,
              value: option.value,
              price: option.price,
            )).toList(),
            specialInstructions: item.specialInstructions,
            totalPrice: item.totalPrice,
          )],
          subtotal: item.totalPrice,
          deliveryFee: 2.99, // Default delivery fee
          tax: _calculateTax(item.totalPrice),
          total: item.totalPrice + 2.99 + _calculateTax(item.totalPrice),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        // Check if item already exists
        final existingItemIndex = currentCart.items.indexWhere(
          (existingItem) => existingItem.menuItemId == item.menuItemId &&
              _areOptionsEqual(existingItem.selectedOptions.map((option) => CartItemOptionEntity(
                id: option.id,
                name: option.name,
                value: option.value,
                price: option.price,
              )).toList(), item.selectedOptions),
        );

        List<CartItemModel> updatedItems = List.from(currentCart.items);

        if (existingItemIndex != -1) {
          // Update existing item quantity
          final existingItem = updatedItems[existingItemIndex];
          updatedItems[existingItemIndex] = CartItemModel(
            id: existingItem.id,
            menuItemId: existingItem.menuItemId,
            name: existingItem.name,
            description: existingItem.description,
            imageUrl: existingItem.imageUrl,
            basePrice: existingItem.basePrice,
            quantity: existingItem.quantity + item.quantity,
            selectedOptions: existingItem.selectedOptions.map((option) => CartItemOptionModel(
              id: option.id,
              name: option.name,
              value: option.value,
              price: option.price,
            )).toList(),
            specialInstructions: existingItem.specialInstructions,
            totalPrice: existingItem.basePrice * (existingItem.quantity + item.quantity) +
                existingItem.selectedOptions.fold(0.0, (sum, option) => sum + option.price),
          );
        } else {
          // Add new item
          updatedItems.add(CartItemModel(
            id: item.id,
            menuItemId: item.menuItemId,
            name: item.name,
            description: item.description,
            imageUrl: item.imageUrl,
            basePrice: item.basePrice,
            quantity: item.quantity,
            selectedOptions: item.selectedOptions.map((option) => CartItemOptionModel(
              id: option.id,
              name: option.name,
              value: option.value,
              price: option.price,
            )).toList(),
            specialInstructions: item.specialInstructions,
            totalPrice: item.totalPrice,
          ));
        }

        final subtotal = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
        final tax = _calculateTax(subtotal);
        final total = subtotal + currentCart.deliveryFee + tax;

        updatedCart = CartModel(
          id: currentCart.id,
          restaurantId: currentCart.restaurantId,
          restaurantName: currentCart.restaurantName,
          restaurantImageUrl: currentCart.restaurantImageUrl,
          items: updatedItems,
          subtotal: subtotal,
          deliveryFee: currentCart.deliveryFee,
          tax: tax,
          total: total,
          createdAt: currentCart.createdAt,
          updatedAt: DateTime.now(),
        );
      }

      await localDataSource.saveCart(updatedCart);
      return Right(updatedCart.toEntity());
    } on CacheException {
      return Left(const CacheFailure(message: 'Failed to load cart'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateItemQuantity(String itemId, int quantity) async {
    try {
      final currentCart = await localDataSource.getCart();
      if (currentCart == null) {
        return Left(const CacheFailure(message: 'Failed to load cart'));
      }

      final updatedItems = currentCart.items.map((item) {
        if (item.id == itemId) {
          return CartItemModel(
            id: item.id,
            menuItemId: item.menuItemId,
            name: item.name,
            description: item.description,
            imageUrl: item.imageUrl,
            basePrice: item.basePrice,
            quantity: quantity,
            selectedOptions: item.selectedOptions.map((option) => CartItemOptionModel(
              id: option.id,
              name: option.name,
              value: option.value,
              price: option.price,
            )).toList(),
            specialInstructions: item.specialInstructions,
            totalPrice: item.basePrice * quantity +
                item.selectedOptions.fold(0.0, (sum, option) => sum + option.price),
          );
        }
        return item;
      }).toList();

      final subtotal = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
      final tax = _calculateTax(subtotal);
      final total = subtotal + currentCart.deliveryFee + tax;

      final updatedCart = CartModel(
        id: currentCart.id,
        restaurantId: currentCart.restaurantId,
        restaurantName: currentCart.restaurantName,
        restaurantImageUrl: currentCart.restaurantImageUrl,
        items: updatedItems,
        subtotal: subtotal,
        deliveryFee: currentCart.deliveryFee,
        tax: tax,
        total: total,
        createdAt: currentCart.createdAt,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveCart(updatedCart);
      return Right(updatedCart.toEntity());
    } on CacheException {
      return Left(const CacheFailure(message: 'Failed to load cart'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> removeItemFromCart(String itemId) async {
    try {
      final currentCart = await localDataSource.getCart();
      if (currentCart == null) {
        return Left(const CacheFailure(message: 'Failed to load cart'));
      }

      final updatedItems = currentCart.items.where((item) => item.id != itemId).toList();

      if (updatedItems.isEmpty) {
        await localDataSource.clearCart();
        return Right(CartEntity(
          id: 'empty',
          restaurantId: '',
          restaurantName: '',
          restaurantImageUrl: '',
          items: [],
          subtotal: 0.0,
          deliveryFee: 0.0,
          tax: 0.0,
          total: 0.0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }

      final subtotal = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
      final tax = _calculateTax(subtotal);
      final total = subtotal + currentCart.deliveryFee + tax;

      final updatedCart = CartModel(
        id: currentCart.id,
        restaurantId: currentCart.restaurantId,
        restaurantName: currentCart.restaurantName,
        restaurantImageUrl: currentCart.restaurantImageUrl,
        items: updatedItems,
        subtotal: subtotal,
        deliveryFee: currentCart.deliveryFee,
        tax: tax,
        total: total,
        createdAt: currentCart.createdAt,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveCart(updatedCart);
      return Right(updatedCart.toEntity());
    } on CacheException {
      return Left(const CacheFailure(message: 'Failed to load cart'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> clearCart() async {
    try {
      await localDataSource.clearCart();
      return Right(CartEntity(
        id: 'empty',
        restaurantId: '',
        restaurantName: '',
        restaurantImageUrl: '',
        items: [],
        subtotal: 0.0,
        deliveryFee: 0.0,
        tax: 0.0,
        total: 0.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    } on CacheException {
      return Left(const CacheFailure(message: 'Failed to load cart'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> updateSpecialInstructions(String itemId, String? instructions) async {
    try {
      final currentCart = await localDataSource.getCart();
      if (currentCart == null) {
        return Left(const CacheFailure(message: 'Failed to load cart'));
      }

      final updatedItems = currentCart.items.map((item) {
        if (item.id == itemId) {
          return CartItemModel(
            id: item.id,
            menuItemId: item.menuItemId,
            name: item.name,
            description: item.description,
            imageUrl: item.imageUrl,
            basePrice: item.basePrice,
            quantity: item.quantity,
            selectedOptions: item.selectedOptions.map((option) => CartItemOptionModel(
              id: option.id,
              name: option.name,
              value: option.value,
              price: option.price,
            )).toList(),
            specialInstructions: instructions,
            totalPrice: item.totalPrice,
          );
        }
        return item;
      }).toList();

      final updatedCart = CartModel(
        id: currentCart.id,
        restaurantId: currentCart.restaurantId,
        restaurantName: currentCart.restaurantName,
        restaurantImageUrl: currentCart.restaurantImageUrl,
        items: updatedItems,
        subtotal: currentCart.subtotal,
        deliveryFee: currentCart.deliveryFee,
        tax: currentCart.tax,
        total: currentCart.total,
        createdAt: currentCart.createdAt,
        updatedAt: DateTime.now(),
      );

      await localDataSource.saveCart(updatedCart);
      return Right(updatedCart.toEntity());
    } on CacheException {
      return Left(const CacheFailure(message: 'Failed to load cart'));
    }
  }

  @override
  Future<Either<Failure, CartEntity>> addItemOption(String itemId, CartItemOptionEntity option) async {
    // Implementation for adding item options
    // This would be similar to updateItemQuantity but for options
    return Left(const UnimplementedFailure());
  }

  @override
  Future<Either<Failure, CartEntity>> removeItemOption(String itemId, String optionId) async {
    // Implementation for removing item options
    // This would be similar to updateItemQuantity but for options
    return Left(const UnimplementedFailure());
  }

  double _calculateTax(double subtotal) {
    // 21% VAT (Dutch tax rate)
    return subtotal * 0.21;
  }

  bool _areOptionsEqual(List<CartItemOptionEntity> options1, List<CartItemOptionEntity> options2) {
    if (options1.length != options2.length) return false;
    
    for (int i = 0; i < options1.length; i++) {
      if (options1[i].id != options2[i].id) return false;
    }
    
    return true;
  }
}

