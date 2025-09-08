import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/enums/order_enums.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/typedefs.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrderRepository repository;

  OrdersBloc({
    required this.repository,
  }) : super(const OrdersInitial()) {
    on<LoadUserOrders>(_onLoadUserOrders);
    on<LoadOrdersByStatus>(_onLoadOrdersByStatus);
    on<CreateOrder>(_onCreateOrder);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<CancelOrder>(_onCancelOrder);
    on<Reorder>(_onReorder);
    on<RefreshOrders>(_onRefreshOrders);
  }

  Future<void> _onLoadUserOrders(
    LoadUserOrders event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    
    final result = await repository.getUserOrders(event.userId);
    
    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }

  Future<void> _onLoadOrdersByStatus(
    LoadOrdersByStatus event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    
    final result = await repository.getOrdersByStatus(event.status);
    
    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (orders) => emit(OrdersLoaded(orders: orders)),
    );
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    
    final result = await repository.createOrder(event.order);
    
    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (order) {
        // Add the new order to the current list
        if (state is OrdersLoaded) {
          final currentOrders = (state as OrdersLoaded).orders;
          final updatedOrders = [order, ...currentOrders];
          emit(OrdersLoaded(orders: updatedOrders));
        } else {
          emit(OrdersLoaded(orders: [order]));
        }
      },
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrdersState> emit,
  ) async {
    if (state is! OrdersLoaded) return;
    
    final result = await repository.updateOrderStatus(event.orderId, event.status);
    
    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (updatedOrder) {
        final currentOrders = (state as OrdersLoaded).orders;
        final updatedOrders = currentOrders.map((order) {
          return order.id == event.orderId ? updatedOrder : order;
        }).toList();
        emit(OrdersLoaded(orders: updatedOrders));
      },
    );
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrdersState> emit,
  ) async {
    if (state is! OrdersLoaded) return;
    
    final result = await repository.cancelOrder(event.orderId);
    
    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (cancelledOrder) {
        final currentOrders = (state as OrdersLoaded).orders;
        final updatedOrders = currentOrders.map((order) {
          return order.id == event.orderId ? cancelledOrder : order;
        }).toList();
        emit(OrdersLoaded(orders: updatedOrders));
      },
    );
  }

  Future<void> _onReorder(
    Reorder event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    
    final result = await repository.reorder(event.orderId);
    
    result.fold(
      (failure) => emit(OrdersError(message: failure.message)),
      (newOrder) {
        // Add the new order to the current list
        if (state is OrdersLoaded) {
          final currentOrders = (state as OrdersLoaded).orders;
          final updatedOrders = <OrderEntity>[newOrder, ...currentOrders];
          emit(OrdersLoaded(orders: updatedOrders));
        } else {
          emit(OrdersLoaded(orders: [newOrder]));
        }
      },
    );
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrdersState> emit,
  ) async {
    // Reload all orders
    add(const LoadUserOrders(userId: 'user_1'));
  }
}