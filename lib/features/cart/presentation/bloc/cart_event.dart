import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class GetCart extends CartEvent {
  const GetCart();
}

class AddItemToCart extends CartEvent {
  final CartItemEntity item;

  const AddItemToCart(this.item);

  @override
  List<Object?> get props => [item];
}

class UpdateItemQuantity extends CartEvent {
  final String itemId;
  final int quantity;

  const UpdateItemQuantity(this.itemId, this.quantity);

  @override
  List<Object?> get props => [itemId, quantity];
}

class RemoveItemFromCart extends CartEvent {
  final String itemId;

  const RemoveItemFromCart(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearCart extends CartEvent {
  const ClearCart();
}

class UpdateSpecialInstructions extends CartEvent {
  final String itemId;
  final String? instructions;

  const UpdateSpecialInstructions(this.itemId, this.instructions);

  @override
  List<Object?> get props => [itemId, instructions];
}


