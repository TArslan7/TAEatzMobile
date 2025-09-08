import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_bloc.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_event.dart';
import 'package:taeatz_mobile/features/realtime/presentation/bloc/realtime_state.dart';

class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget({super.key});

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RealtimeBloc, RealtimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConnectionStatusCard(state),
              const SizedBox(height: 20),
              _buildConnectionStats(),
              const SizedBox(height: 20),
              _buildConnectionControls(state),
              const SizedBox(height: 20),
              _buildConnectionHistory(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConnectionStatusCard(RealtimeState state) {
    final isConnected = state is RealtimeConnected;
    final statusText = _getStatusText(state);
    final statusColor = _getStatusColor(state);
    final statusIcon = _getStatusIcon(state);

    if (isConnected) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    } else {
      _pulseController.stop();
      _waveController.stop();
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withOpacity(0.1),
              statusColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: isConnected ? _pulseAnimation.value : 1.0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusIcon,
                      size: 48,
                      color: statusColor,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 8),
            if (state is RealtimeConnected) ...[
              Text(
                'Connected since ${_formatTime(state.connectedAt)}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Connection ID: ${state.connectionId}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ] else if (state is RealtimeError) ...[
              Text(
                state.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red[600],
                ),
              ),
            ],
            if (isConnected) ...[
              const SizedBox(height: 16),
              _buildWaveAnimation(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return SizedBox(
      height: 40,
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 40),
            painter: WavePainter(_waveAnimation.value),
          );
        },
      ),
    );
  }

  Widget _buildConnectionStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow('Messages Sent', '1,247', Icons.send),
            _buildStatRow('Messages Received', '2,891', Icons.inbox),
            _buildStatRow('Uptime', '99.8%', Icons.timer),
            _buildStatRow('Latency', '45ms', Icons.speed),
            _buildStatRow('Reconnections', '3', Icons.refresh),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionControls(RealtimeState state) {
    final isConnected = state is RealtimeConnected;
    final isConnecting = state is RealtimeConnecting;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection Controls',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isConnecting
                        ? null
                        : () {
                            if (isConnected) {
                              context.read<RealtimeBloc>().add(const DisconnectRealtime());
                            } else {
                              context.read<RealtimeBloc>().add(const ConnectRealtime());
                            }
                          },
                    icon: Icon(isConnected ? Icons.wifi_off : Icons.wifi),
                    label: Text(isConnected ? 'Disconnect' : 'Connect'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isConnecting ? null : () => _testConnection(),
                    icon: const Icon(Icons.network_check),
                    label: const Text('Test'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (isConnecting) ...[
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionHistory() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connection History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHistoryItem('Connected', '2:45 PM', Colors.green),
            _buildHistoryItem('Disconnected', '2:30 PM', Colors.red),
            _buildHistoryItem('Connected', '2:15 PM', Colors.green),
            _buildHistoryItem('Error: Timeout', '2:10 PM', Colors.orange),
            _buildHistoryItem('Connected', '2:00 PM', Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String event, String time, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              event,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(RealtimeState state) {
    if (state is RealtimeConnected) {
      return 'Connected';
    } else if (state is RealtimeConnecting) {
      return 'Connecting...';
    } else if (state is RealtimeDisconnected) {
      return 'Disconnected';
    } else if (state is RealtimeError) {
      return 'Error';
    } else {
      return 'Not Connected';
    }
  }

  Color _getStatusColor(RealtimeState state) {
    if (state is RealtimeConnected) {
      return Colors.green;
    } else if (state is RealtimeConnecting) {
      return Colors.orange;
    } else if (state is RealtimeDisconnected) {
      return Colors.grey;
    } else if (state is RealtimeError) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  IconData _getStatusIcon(RealtimeState state) {
    if (state is RealtimeConnected) {
      return Icons.wifi;
    } else if (state is RealtimeConnecting) {
      return Icons.wifi_find;
    } else if (state is RealtimeDisconnected) {
      return Icons.wifi_off;
    } else if (state is RealtimeError) {
      return Icons.error;
    } else {
      return Icons.wifi_off;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _testConnection() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Testing connection...'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final waveLength = size.width / 3;
    final amplitude = size.height / 4;

    for (double x = 0; x <= size.width; x += 1) {
      final y = size.height / 2 + 
          amplitude * 
          sin(animationValue * 2 * 3.14159 * x / waveLength);
      
      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
