import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
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
import 'core/network/network_info.dart';
// import 'core/network/api_client.dart'; // Temporarily disabled

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  runApp(const TAEatzApp());
}

class TAEatzApp extends StatelessWidget {
  const TAEatzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => _createRestaurantBloc()),
        BlocProvider(create: (context) => _createMenuBloc()),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
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

