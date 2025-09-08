import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getUserOrders(String userId);
  Future<OrderModel> getOrderById(String orderId);
  Future<OrderModel> createOrder(OrderModel order);
  Future<OrderModel> updateOrderStatus(String orderId, String status);
  Future<OrderModel> cancelOrder(String orderId);
  Future<OrderModel> reorder(String orderId);
  Future<List<OrderModel>> getOrdersByStatus(OrderStatus status);
  Future<List<OrderModel>> getRestaurantOrders(String restaurantId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  OrderRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return [
      OrderModel(
        id: 'order_1',
        userId: userId,
        restaurantId: 'restaurant_1',
        restaurantName: 'Pizza Palace',
        restaurantImageUrl: 'https://example.com/pizza.jpg',
        items: [],
        subtotal: 25.99,
        taxAmount: 2.60,
        deliveryFee: 3.99,
        tipAmount: 5.00,
        totalAmount: 37.58,
        status: OrderStatus.delivered,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.creditCard,
        deliveryAddress: '123 Main St, Amsterdam',
        deliveryInstructions: 'Ring the doorbell',
        estimatedDeliveryTime: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      OrderModel(
        id: 'order_2',
        userId: userId,
        restaurantId: 'restaurant_2',
        restaurantName: 'Burger King',
        restaurantImageUrl: 'https://example.com/burger.jpg',
        items: [],
        subtotal: 18.50,
        taxAmount: 1.85,
        deliveryFee: 2.99,
        tipAmount: 3.00,
        totalAmount: 26.34,
        status: OrderStatus.outForDelivery,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.googlePay,
        deliveryAddress: '456 Oak Ave, Amsterdam',
        deliveryInstructions: 'Leave at front door',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 15)),
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      OrderModel(
        id: 'order_3',
        userId: userId,
        restaurantId: 'restaurant_3',
        restaurantName: 'Sushi Master',
        restaurantImageUrl: 'https://example.com/sushi.jpg',
        items: [],
        subtotal: 45.00,
        taxAmount: 4.50,
        deliveryFee: 4.99,
        tipAmount: 8.00,
        totalAmount: 62.49,
        status: OrderStatus.preparing,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.creditCard,
        deliveryAddress: '789 Pine St, Amsterdam',
        deliveryInstructions: 'Call when arrived',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 45)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      OrderModel(
        id: 'order_4',
        userId: userId,
        restaurantId: 'restaurant_1',
        restaurantName: 'Pizza Palace',
        restaurantImageUrl: 'https://example.com/pizza.jpg',
        items: [],
        subtotal: 25.00,
        taxAmount: 2.50,
        deliveryFee: 3.99,
        tipAmount: 5.00,
        totalAmount: 36.49,
        status: OrderStatus.confirmed,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.applePay,
        deliveryAddress: '321 Elm St, Amsterdam',
        deliveryInstructions: 'Ring doorbell',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 30)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      OrderModel(
        id: 'order_5',
        userId: userId,
        restaurantId: 'restaurant_2',
        restaurantName: 'Burger King',
        restaurantImageUrl: 'https://example.com/burger.jpg',
        items: [],
        subtotal: 15.00,
        taxAmount: 1.50,
        deliveryFee: 2.99,
        tipAmount: 2.00,
        totalAmount: 21.49,
        status: OrderStatus.ready,
        paymentStatus: PaymentStatus.paid,
        paymentMethod: PaymentMethod.cash,
        deliveryAddress: '654 Maple Ave, Amsterdam',
        deliveryInstructions: 'Leave with neighbor',
        estimatedDeliveryTime: DateTime.now().add(const Duration(minutes: 10)),
        createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
  }

  @override
  Future<OrderModel> getOrderById(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final orders = await getUserOrders('user_1');
    return orders.firstWhere((order) => order.id == orderId);
  }

  @override
  Future<OrderModel> createOrder(OrderModel order) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    return order;
  }

  @override
  Future<OrderModel> updateOrderStatus(String orderId, String status) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final order = await getOrderById(orderId);
    return order.copyWith(
      status: OrderStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => OrderStatus.pending,
      ),
    );
  }

  @override
  Future<OrderModel> cancelOrder(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final order = await getOrderById(orderId);
    return order.copyWith(
      status: OrderStatus.cancelled,
    );
  }

  @override
  Future<OrderModel> reorder(String orderId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final originalOrder = await getOrderById(orderId);
    return originalOrder.copyWith(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}',
      status: OrderStatus.pending,
      paymentStatus: PaymentStatus.pending,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<OrderModel>> getOrdersByStatus(OrderStatus status) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final allOrders = await getUserOrders('user_1');
    return allOrders.where((order) => order.status == status).toList();
  }

  @override
  Future<List<OrderModel>> getRestaurantOrders(String restaurantId) async {
    // Mock implementation
    await Future.delayed(const Duration(seconds: 1));
    
    final allOrders = await getUserOrders('user_1');
    return allOrders.where((order) => order.restaurantId == restaurantId).toList();
  }
}