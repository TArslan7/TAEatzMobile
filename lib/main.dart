import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'features/orders/data/datasources/order_remote_datasource.dart';
import 'features/orders/data/repositories/order_repository_impl.dart';
import 'features/orders/presentation/bloc/orders_bloc.dart';
import 'features/orders/domain/enums/order_enums.dart';
import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'features/tracking/data/repositories/tracking_repository_impl.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_manager.dart';
import 'core/constants/app_constants.dart';
import 'core/analytics/analytics_service.dart';
import 'core/cache/smart_cache.dart';
import 'core/services/websocket_service.dart';
import 'core/network/api_client.dart';
import 'core/security/security_manager.dart';
import 'core/performance/app_optimizer.dart';
import 'core/error/error_recovery_system.dart';
import 'core/health/app_health_monitor.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/restaurants/presentation/bloc/restaurant_bloc.dart';
import 'features/restaurants/data/datasources/restaurant_remote_datasource.dart';
import 'features/restaurants/data/datasources/restaurant_local_datasource.dart';
import 'features/restaurants/data/repositories/restaurant_repository_impl.dart';
import 'features/restaurants/domain/usecases/get_restaurants.dart';
import 'features/restaurants/domain/usecases/get_restaurant_by_id.dart';
import 'features/restaurants/domain/usecases/search_restaurants.dart';
import 'features/menu/presentation/bloc/menu_bloc.dart';
import 'features/menu/domain/usecases/get_menu_by_restaurant_id.dart';
import 'features/menu/domain/usecases/get_menu_items_by_category.dart';
import 'features/menu/domain/usecases/search_menu_items.dart';
import 'features/menu/data/datasources/menu_remote_datasource.dart';
import 'features/menu/data/repositories/menu_repository_impl.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/cart/domain/usecases/add_item_to_cart.dart' as add_item_usecase;
import 'features/cart/domain/usecases/get_cart.dart' as get_cart_usecase;
import 'features/cart/domain/usecases/update_item_quantity.dart' as update_quantity_usecase;
import 'features/cart/domain/usecases/remove_item_from_cart.dart' as remove_item_usecase;
import 'features/cart/domain/usecases/clear_cart.dart' as clear_cart_usecase;
import 'features/cart/data/datasources/cart_local_datasource.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/checkout/presentation/bloc/checkout_bloc.dart';
import 'features/orders/domain/usecases/create_order.dart';
import 'features/orders/domain/repositories/order_repository.dart';
import 'features/orders/domain/entities/order_entity.dart';
import 'features/payment/domain/usecases/create_payment_intent.dart';
import 'features/payment/domain/usecases/confirm_payment.dart';
import 'features/payment/data/datasources/stripe_payment_datasource.dart';
import 'features/payment/data/repositories/payment_repository_impl.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/orders/presentation/bloc/orders_bloc.dart';
import 'core/network/network_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';
import 'core/errors/failures.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize SharedPreferences
  sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize Hive Cache
  await HiveCache.init();
  
  // Initialize WebSocket
  await WebSocketManager.initialize();
  
  // Initialize API Client
  ApiClient.instance.initialize();
  
  // Initialize Security Manager
  SecurityManager.instance;
  
  // Initialize App Optimizer
  await AppOptimizer.instance.initialize();
  
  // Initialize Error Recovery System
  await ErrorRecoverySystem.instance.initialize();
  
  // Initialize App Health Monitor
  await AppHealthMonitor.instance.initialize();
  
  // Initialize Performance Monitor
  // PerformanceMonitor.instance.startMonitoring();
  
  // Initialize Analytics
  AnalyticsService.trackEvent('app_start', {
    'version': AppConstants.appVersion,
    'platform': defaultTargetPlatform.name,
  });
  
  // Set up error handling
  FlutterError.onError = CrashReporter.reportFlutterError;
  
  runApp(const TAEatzApp());
}

class TAEatzApp extends StatelessWidget {
  const TAEatzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeManager(),
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AuthBloc()),
              BlocProvider(create: (context) => _createRestaurantBloc()),
              BlocProvider(create: (context) => _createMenuBloc()),
              BlocProvider(create: (context) => _createCartBlocSync()),
              BlocProvider(create: (context) => _createCheckoutBloc()),
              BlocProvider(create: (context) => _createSearchBloc()),
              BlocProvider(create: (context) => _createOrdersBloc()),
              BlocProvider(create: (context) => _createProfileBloc()),
              BlocProvider(create: (context) => _createTrackingBloc()),
            ],
            child: MaterialApp.router(
              title: AppConstants.appName,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeManager.themeMode,
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }

  RestaurantBloc _createRestaurantBloc() {
    final remoteDataSource = RestaurantRemoteDataSourceImpl();
    final localDataSource = RestaurantLocalDataSourceImpl();
    final networkInfo = NetworkInfoImpl(connectivity: Connectivity());
    final repository = RestaurantRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
    
    return RestaurantBloc(
      getRestaurants: GetRestaurants(repository),
      getRestaurantById: GetRestaurantById(repository),
      searchRestaurants: SearchRestaurants(repository),
      repository: repository,
    );
  }

  MenuBloc _createMenuBloc() {
    final remoteDataSource = MenuRemoteDataSourceImpl();
    final networkInfo = NetworkInfoImpl(connectivity: Connectivity());
    final repository = MenuRepositoryImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    return MenuBloc(
      getMenuByRestaurantId: GetMenuByRestaurantId(repository),
      getMenuItemsByCategory: GetMenuItemsByCategory(repository),
      searchMenuItems: SearchMenuItems(repository),
      repository: repository,
    );
  }

  CartBloc _createCartBlocSync() {
    final localDataSource = CartLocalDataSourceImpl(sharedPreferences: sharedPreferences);
    final repository = CartRepositoryImpl(localDataSource: localDataSource);

    return CartBloc(
      getCart: get_cart_usecase.GetCart(repository),
      addItemToCart: add_item_usecase.AddItemToCart(repository),
      updateItemQuantity: update_quantity_usecase.UpdateItemQuantity(repository),
      removeItemFromCart: remove_item_usecase.RemoveItemFromCart(repository),
      clearCart: clear_cart_usecase.ClearCart(repository),
      repository: repository,
    );
  }

  CheckoutBloc _createCheckoutBloc() {
    // TODO: Implement proper order and payment repositories
    // For now, we'll create mock implementations
    final dio = Dio();
    final paymentDataSource = StripePaymentDataSourceImpl(
      dio: dio,
      baseUrl: 'https://api.taeatz.com', // TODO: Use actual API URL
    );
    final paymentRepository = PaymentRepositoryImpl(dataSource: paymentDataSource);

    return CheckoutBloc(
      createOrder: CreateOrder(_MockOrderRepository()),
      createPaymentIntent: CreatePaymentIntent(paymentRepository),
      confirmPayment: ConfirmPayment(paymentRepository),
    );
  }

  SearchBloc _createSearchBloc() {
    return createSearchBloc();
  }

  OrdersBloc _createOrdersBloc() {
    final dio = Dio();
    final orderRemoteDataSource = OrderRemoteDataSourceImpl(
      dio: dio,
      baseUrl: 'https://api.taeatz.com',
    );
    final orderRepository = OrderRepositoryImpl(
      remoteDataSource: orderRemoteDataSource,
      networkInfo: NetworkInfoImpl(connectivity: Connectivity()),
    );
    return OrdersBloc(repository: orderRepository);
  }

  ProfileBloc _createProfileBloc() {
    final dio = Dio();
    final profileRemoteDataSource = ProfileRemoteDataSourceImpl(
      dio: dio,
      baseUrl: 'https://api.taeatz.com',
    );
    final profileRepository = ProfileRepositoryImpl(
      remoteDataSource: profileRemoteDataSource,
      networkInfo: NetworkInfoImpl(connectivity: Connectivity()),
    );
    return ProfileBloc(repository: profileRepository);
  }

  TrackingBloc _createTrackingBloc() {
    final dio = Dio();
    final trackingRemoteDataSource = TrackingRemoteDataSourceImpl(
      dio: dio,
      baseUrl: 'https://api.taeatz.com',
    );
    final trackingRepository = TrackingRepositoryImpl(
      remoteDataSource: trackingRemoteDataSource,
      networkInfo: NetworkInfoImpl(connectivity: Connectivity()),
    );
    return TrackingBloc(repository: trackingRepository);
  }
}

// Mock order repository for now
class _MockOrderRepository implements OrderRepository {
  // TODO: Implement actual order repository
  @override
  Future<Either<Failure, OrderEntity>> createOrder(OrderEntity order) async {
    return Right(order.copyWith(id: 'mock_order_id_${DateTime.now().millisecondsSinceEpoch}'));
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrder(String orderId) async {
    return Left(const UnimplementedFailure(message: 'GetOrder not implemented'));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getUserOrders(String userId) async {
    return Left(const UnimplementedFailure(message: 'GetUserOrders not implemented'));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getRestaurantOrders(String restaurantId) async {
    return Left(const UnimplementedFailure(message: 'GetRestaurantOrders not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> updateOrderStatus(String orderId, OrderStatus status) async {
    return Left(const UnimplementedFailure(message: 'UpdateOrderStatus not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> updatePaymentStatus(String orderId, PaymentStatus status) async {
    return Left(const UnimplementedFailure(message: 'UpdatePaymentStatus not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> cancelOrder(String orderId) async {
    return Left(const UnimplementedFailure(message: 'CancelOrder not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> reorder(String orderId) async {
    return Left(const UnimplementedFailure(message: 'Reorder not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> refundOrder(String orderId) async {
    return Left(const UnimplementedFailure(message: 'RefundOrder not implemented'));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrdersByStatus(OrderStatus status) async {
    return Left(const UnimplementedFailure(message: 'GetOrdersByStatus not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> assignDeliveryDriver(String orderId, String driverId) async {
    return Left(const UnimplementedFailure(message: 'AssignDeliveryDriver not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> updateDeliveryTime(String orderId, DateTime deliveryTime) async {
    return Left(const UnimplementedFailure(message: 'UpdateDeliveryTime not implemented'));
  }

  @override
  Future<Either<Failure, OrderEntity>> addTrackingUrl(String orderId, String trackingUrl) async {
    return Left(const UnimplementedFailure(message: 'AddTrackingUrl not implemented'));
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);

