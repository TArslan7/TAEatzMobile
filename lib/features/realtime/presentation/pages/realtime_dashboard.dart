import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_event.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_state.dart';
import 'package:taeatz_mobile/features/realtime/presentation/widgets/live_orders_widget.dart';
import 'package:taeatz_mobile/features/realtime/presentation/widgets/notifications_widget.dart';
import 'package:taeatz_mobile/features/realtime/presentation/widgets/connection_status_widget.dart';

class RealtimeDashboard extends StatefulWidget {
  const RealtimeDashboard({super.key});

  @override
  State<RealtimeDashboard> createState() => _RealtimeDashboardState();
}

class _RealtimeDashboardState extends State<RealtimeDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
    
    // Initialize real-time connection
    context.read<RealtimeBloc>().add(InitializeRealtime());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Dashboard'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.track_changes), text: 'Live Orders'),
            Tab(icon: Icon(Icons.notifications), text: 'Notifications'),
            Tab(icon: Icon(Icons.wifi), text: 'Connection'),
          ],
        ),
      ),
      body: BlocBuilder<RealtimeBloc, RealtimeState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              LiveOrdersWidget(),
              NotificationsWidget(),
              ConnectionStatusWidget(),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<RealtimeBloc, RealtimeState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state is RealtimeConnected) {
                context.read<RealtimeBloc>().add(DisconnectRealtime());
              } else {
                context.read<RealtimeBloc>().add(ConnectRealtime());
              }
            },
            backgroundColor: state is RealtimeConnected ? Colors.green : Colors.red,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: state is RealtimeConnected ? _pulseAnimation.value : 1.0,
                  child: Icon(
                    state is RealtimeConnected ? Icons.wifi : Icons.wifi_off,
                    color: Colors.white,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
