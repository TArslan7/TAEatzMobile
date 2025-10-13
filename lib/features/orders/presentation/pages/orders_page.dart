import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../bloc/orders_bloc.dart';
import '../bloc/orders_event.dart';
import '../bloc/orders_state.dart';
import '../widgets/order_card.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/enums/order_enums.dart';
import '../../../tracking/presentation/pages/tracking_page.dart';
import 'order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  OrderStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Load initial orders
    context.read<OrdersBloc>().add(const LoadUserOrders(userId: 'user_1'));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Orders',
              style: TextStyle(color: themeManager.textColor),
            ),
            backgroundColor: themeManager.cardColor,
            iconTheme: IconThemeData(color: themeManager.textColor),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: themeManager.textColor,
                ),
                onPressed: () {
                  _showFilterDialog();
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: themeManager.textColor,
                ),
                onPressed: () {
                  context.read<OrdersBloc>().add(const RefreshOrders());
                },
              ),
            ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textTertiaryColor,
          indicatorColor: AppTheme.primaryColor,
          onTap: (index) {
            _onTabChanged(index);
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Active'),
            Tab(text: 'Delivered'),
            Tab(text: 'Cancelled'),
            Tab(text: 'Preparing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(),
          _buildOrdersList(filter: OrderStatus.outForDelivery),
          _buildOrdersList(filter: OrderStatus.delivered),
          _buildOrdersList(filter: OrderStatus.cancelled),
          _buildOrdersList(filter: OrderStatus.preparing),
        ],
      ),
    );
      },
    );
  }

  void _onTabChanged(int index) {
    setState(() {
      switch (index) {
        case 0:
          _selectedFilter = null;
          context.read<OrdersBloc>().add(const LoadUserOrders(userId: 'user_1'));
          break;
        case 1:
          _selectedFilter = OrderStatus.outForDelivery;
          context.read<OrdersBloc>().add(const LoadOrdersByStatus(status: OrderStatus.outForDelivery));
          break;
        case 2:
          _selectedFilter = OrderStatus.delivered;
          context.read<OrdersBloc>().add(const LoadOrdersByStatus(status: OrderStatus.delivered));
          break;
        case 3:
          _selectedFilter = OrderStatus.cancelled;
          context.read<OrdersBloc>().add(const LoadOrdersByStatus(status: OrderStatus.cancelled));
          break;
        case 4:
          _selectedFilter = OrderStatus.preparing;
          context.read<OrdersBloc>().add(const LoadOrdersByStatus(status: OrderStatus.preparing));
          break;
      }
    });
  }

  Widget _buildOrdersList({OrderStatus? filter}) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is OrdersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppTheme.errorColor,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'Something went wrong',
                  style: AppTheme.heading6,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  state.message,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton(
                  onPressed: () {
                    context.read<OrdersBloc>().add(const LoadUserOrders(userId: 'user_1'));
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (state is OrdersEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: AppTheme.textTertiaryColor,
                ),
                const SizedBox(height: AppTheme.spacingM),
                Text(
                  'No orders found',
                  style: AppTheme.heading6,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  state.message,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingL),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to restaurants
                    context.showSnackBar('Navigate to restaurants coming soon!');
                  },
                  child: const Text('Order Now'),
                ),
              ],
            ),
          );
        }

        if (state is OrdersLoaded) {
          final orders = state.orders;
          
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: AppTheme.textTertiaryColor,
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  Text(
                    'No orders found',
                    style: AppTheme.heading6,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Text(
                    'You haven\'t placed any orders yet',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrdersBloc>().add(const RefreshOrders());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                print('Order ${order.id}: status=${order.status}, canTrack=${_canTrackOrder(order)}');
                return OrderCard(
                  order: order,
                  onTap: () => _onOrderTap(order),
                  onReorder: () => _onReorder(order),
                  onTrack: _canTrackOrder(order) ? () => _onTrack(order) : null,
                  onCancel: () => _onCancel(order),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  void _onOrderTap(OrderEntity order) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OrderDetailPage(order: order),
      ),
    );
  }

  void _onReorder(OrderEntity order) {
    context.read<OrdersBloc>().add(ReorderOrder(orderId: order.id));
    context.showSnackBar('Order added to cart!');
  }

  bool _canTrackOrder(OrderEntity order) {
    return order.status == OrderStatus.confirmed ||
           order.status == OrderStatus.preparing ||
           order.status == OrderStatus.ready ||
           order.status == OrderStatus.outForDelivery;
  }

  void _onTrack(OrderEntity order) {
    print('Tracking order: ${order.id} with status: ${order.status}');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrackingPage(orderId: order.id),
      ),
    );
  }

  void _onCancel(OrderEntity order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<OrdersBloc>().add(CancelOrder(orderId: order.id));
              context.showSnackBar('Order cancelled');
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Orders',
              style: AppTheme.heading6,
            ),
            const SizedBox(height: AppTheme.spacingM),
            ...OrderStatus.values.map((status) => ListTile(
              title: Text(_getStatusText(status)),
              leading: Radio<OrderStatus>(
                value: status,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = value;
                  });
                  Navigator.of(context).pop();
                  _onFilterChanged(value);
                },
              ),
            )),
            ListTile(
              title: const Text('All Orders'),
              leading: Radio<OrderStatus?>(
                value: null,
                groupValue: _selectedFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedFilter = null;
                  });
                  Navigator.of(context).pop();
                  _onFilterChanged(null);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onFilterChanged(OrderStatus? status) {
    if (status == null) {
      context.read<OrdersBloc>().add(const LoadUserOrders(userId: 'user_1'));
    } else {
      context.read<OrdersBloc>().add(LoadOrdersByStatus(status: status));
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.ready:
        return 'Ready';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.refunded:
        return 'Refunded';
    }
  }
}
