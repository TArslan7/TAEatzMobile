import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/usecases/add_item_to_cart.dart' as add_item_usecase;
import '../../domain/usecases/get_cart.dart' as get_cart_usecase;
import '../../domain/usecases/update_item_quantity.dart' as update_quantity_usecase;
import '../../domain/usecases/remove_item_from_cart.dart' as remove_item_usecase;
import '../../domain/usecases/clear_cart.dart' as clear_cart_usecase;
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final get_cart_usecase.GetCart getCart;
  final add_item_usecase.AddItemToCart addItemToCart;
  final update_quantity_usecase.UpdateItemQuantity updateItemQuantity;
  final remove_item_usecase.RemoveItemFromCart removeItemFromCart;
  final clear_cart_usecase.ClearCart clearCart;
  final CartRepository repository;

  CartBloc({
    required this.getCart,
    required this.addItemToCart,
    required this.updateItemQuantity,
    required this.removeItemFromCart,
    required this.clearCart,
    required this.repository,
  }) : super(const CartInitial()) {
    on<GetCart>(_onGetCart);
    on<AddItemToCart>(_onAddItemToCart);
    on<UpdateItemQuantity>(_onUpdateItemQuantity);
    on<RemoveItemFromCart>(_onRemoveItemFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onGetCart(GetCart event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    
    final result = await getCart();
    result.fold(
      (failure) => emit(CartError('Failed to load cart')),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onAddItemToCart(AddItemToCart event, Emitter<CartState> emit) async {
    final result = await addItemToCart(event.item);
    result.fold(
      (failure) => emit(CartError('Failed to add item to cart')),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onUpdateItemQuantity(UpdateItemQuantity event, Emitter<CartState> emit) async {
    final result = await updateItemQuantity(event.itemId, event.quantity);
    result.fold(
      (failure) => emit(CartError('Failed to update item quantity')),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onRemoveItemFromCart(RemoveItemFromCart event, Emitter<CartState> emit) async {
    final result = await removeItemFromCart(event.itemId);
    result.fold(
      (failure) => emit(CartError('Failed to remove item from cart')),
      (cart) => emit(CartLoaded(cart)),
    );
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    final result = await clearCart();
    result.fold(
      (failure) => emit(CartError('Failed to clear cart')),
      (cart) => emit(CartLoaded(cart)),
    );
  }
}
