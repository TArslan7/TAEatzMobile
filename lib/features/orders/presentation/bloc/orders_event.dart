import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserOrders extends OrdersEvent {
  final String userId;

  const LoadUserOrders({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadOrderById extends OrdersEvent {
  final String orderId;

  const LoadOrderById({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class LoadOrdersByStatus extends OrdersEvent {
  final OrderStatus status;

  const LoadOrdersByStatus({required this.status});

  @override
  List<Object?> get props => [status];
}

class RefreshOrders extends OrdersEvent {
  const RefreshOrders();
}

class CreateOrder extends OrdersEvent {
  final OrderEntity order;

  const CreateOrder({required this.order});

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatus extends OrdersEvent {
  final String orderId;
  final OrderStatus status;

  const UpdateOrderStatus({
    required this.orderId,
    required this.status,
  });

  @override
  List<Object?> get props => [orderId, status];
}

class Reorder extends OrdersEvent {
  final String orderId;

  const Reorder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class CancelOrder extends OrdersEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class ReorderOrder extends OrdersEvent {
  final String orderId;

  const ReorderOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class TrackOrder extends OrdersEvent {
  final String orderId;

  const TrackOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class FilterOrdersByStatus extends OrdersEvent {
  final OrderStatus? status;

  const FilterOrdersByStatus({this.status});

  @override
  List<Object?> get props => [status];
}

class ClearOrdersFilter extends OrdersEvent {
  const ClearOrdersFilter();
}
