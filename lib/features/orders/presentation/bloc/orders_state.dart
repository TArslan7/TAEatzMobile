import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final List<OrderEntity> orders;
  final OrderStatus? filteredStatus;
  final bool hasReachedMax;

  const OrdersLoaded({
    required this.orders,
    this.filteredStatus,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [orders, filteredStatus, hasReachedMax];
}

class OrderDetailLoaded extends OrdersState {
  final OrderEntity order;

  const OrderDetailLoaded({required this.order});

  @override
  List<Object?> get props => [order];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrdersEmpty extends OrdersState {
  final String message;

  const OrdersEmpty({required this.message});

  @override
  List<Object?> get props => [message];
}

class OrderCancelled extends OrdersState {
  final String orderId;

  const OrderCancelled({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrderReordered extends OrdersState {
  final OrderEntity order;

  const OrderReordered({required this.order});

  @override
  List<Object?> get props => [order];
}
