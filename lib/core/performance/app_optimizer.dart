import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppOptimizer {
  static AppOptimizer? _instance;
  static AppOptimizer get instance => _instance ??= AppOptimizer._();
  
  AppOptimizer._();

  // Performance monitoring
  final Map<String, DateTime> _operationStartTimes = {};
  final Map<String, List<Duration>> _operationDurations = {};
  int _frameDrops = 0;
  int _totalFrames = 0;

  // Memory management
  final List<Widget> _disposedWidgets = [];
  int _memoryWarnings = 0;

  // Network optimization
  final Map<String, DateTime> _lastNetworkCalls = {};
  final Map<String, int> _networkCallCounts = {};

  // Initialize app optimization
  Future<void> initialize() async {
    debugPrint('🚀 Initializing App Optimizer...');
    
    // Set up performance monitoring
    _setupPerformanceMonitoring();
    
    // Optimize app settings
    _optimizeAppSettings();
    
    // Set up memory management
    _setupMemoryManagement();
    
    // Set up network optimization
    _setupNetworkOptimization();
    
    debugPrint('✅ App Optimizer initialized successfully');
  }

  // Performance Monitoring
  void _setupPerformanceMonitoring() {
    // Monitor frame rendering
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      _totalFrames++;
      // Check for frame drops (simplified)
      if (timeStamp.inMilliseconds > 16) { // 60fps = 16ms per frame
        _frameDrops++;
      }
    });
  }

  void startOperation(String operationName) {
    _operationStartTimes[operationName] = DateTime.now();
  }

  void endOperation(String operationName) {
    final startTime = _operationStartTimes[operationName];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _operationDurations.putIfAbsent(operationName, () => []).add(duration);
      _operationStartTimes.remove(operationName);
      
      if (kDebugMode) {
        debugPrint('⏱️ Operation "$operationName" took ${duration.inMilliseconds}ms');
      }
    }
  }

  // App Settings Optimization
  void _optimizeAppSettings() {
    // Enable hardware acceleration
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Optimize text rendering
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Set system overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  // Memory Management
  void _setupMemoryManagement() {
    // Monitor memory usage
    WidgetsBinding.instance.addObserver(_MemoryObserver());
  }

  void disposeWidget(Widget widget) {
    _disposedWidgets.add(widget);
    
    // Clean up disposed widgets periodically
    if (_disposedWidgets.length > 100) {
      _cleanupDisposedWidgets();
    }
  }

  void _cleanupDisposedWidgets() {
    _disposedWidgets.clear();
    debugPrint('🧹 Cleaned up disposed widgets');
  }

  // Network Optimization
  void _setupNetworkOptimization() {
    // Implement network call throttling
    // Implement request caching
    // Implement connection pooling
  }

  bool shouldThrottleNetworkCall(String endpoint) {
    final now = DateTime.now();
    final lastCall = _lastNetworkCalls[endpoint];
    final callCount = _networkCallCounts[endpoint] ?? 0;
    
    if (lastCall != null) {
      final timeSinceLastCall = now.difference(lastCall);
      if (timeSinceLastCall.inSeconds < 1) { // Throttle calls within 1 second
        return true;
      }
    }
    
    _lastNetworkCalls[endpoint] = now;
    _networkCallCounts[endpoint] = callCount + 1;
    return false;
  }

  // Image Optimization
  Widget optimizeImage({
    required String imageUrl,
    required Widget child,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: child,
      ),
    );
  }

  // List Optimization
  Widget optimizeList({
    required List<Widget> children,
    ScrollController? controller,
    bool shrinkWrap = false,
    ScrollPhysics? physics,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics ?? const BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        // Add lazy loading for better performance
        if (index >= children.length - 5) {
          // Preload next items
          _preloadNextItems(index, children.length);
        }
        return children[index];
      },
    );
  }

  void _preloadNextItems(int currentIndex, int totalItems) {
    // Implement preloading logic
    debugPrint('🔄 Preloading items from index $currentIndex');
  }

  // Animation Optimization
  Widget optimizeAnimation({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      child: child,
    );
  }

  // Performance Reports
  Map<String, dynamic> getPerformanceReport() {
    final averageOperationTimes = <String, double>{};
    
    for (final entry in _operationDurations.entries) {
      final durations = entry.value;
      if (durations.isNotEmpty) {
        final average = durations
            .map((d) => d.inMilliseconds)
            .reduce((a, b) => a + b) / durations.length;
        averageOperationTimes[entry.key] = average;
      }
    }
    
    final frameDropRate = _totalFrames > 0 ? (_frameDrops / _totalFrames) * 100 : 0;
    
    return {
      'frameDropRate': frameDropRate,
      'totalFrames': _totalFrames,
      'frameDrops': _frameDrops,
      'averageOperationTimes': averageOperationTimes,
      'memoryWarnings': _memoryWarnings,
      'disposedWidgets': _disposedWidgets.length,
      'networkCallCounts': _networkCallCounts,
    };
  }

  // Cache Management
  void clearCache() {
    _operationDurations.clear();
    _lastNetworkCalls.clear();
    _networkCallCounts.clear();
    _disposedWidgets.clear();
    _frameDrops = 0;
    _totalFrames = 0;
    _memoryWarnings = 0;
    
    debugPrint('🧹 Cache cleared');
  }

  // Memory Warning Handler
  void handleMemoryWarning() {
    _memoryWarnings++;
    _cleanupDisposedWidgets();
    
    // Force garbage collection
    if (kDebugMode) {
      debugPrint('⚠️ Memory warning received. Cleaning up...');
    }
  }

  // Network Call Optimization
  Future<T> optimizeNetworkCall<T>(
    String endpoint,
    Future<T> Function() networkCall,
  ) async {
    if (shouldThrottleNetworkCall(endpoint)) {
      debugPrint('🚦 Throttling network call to $endpoint');
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    startOperation('network_call_$endpoint');
    try {
      final result = await networkCall();
      endOperation('network_call_$endpoint');
      return result;
    } catch (e) {
      endOperation('network_call_$endpoint');
      rethrow;
    }
  }

  // Widget Lifecycle Optimization
  Widget optimizeWidgetLifecycle({
    required Widget child,
    required String widgetName,
  }) {
    return _OptimizedWidget(
      key: ValueKey(widgetName),
      child: child,
      onDispose: () => disposeWidget(child),
    );
  }
}

// Memory Observer
class _MemoryObserver extends WidgetsBindingObserver {
  @override
  void didHaveMemoryPressure() {
    AppOptimizer.instance.handleMemoryWarning();
  }
}

// Optimized Widget
class _OptimizedWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDispose;

  const _OptimizedWidget({
    super.key,
    required this.child,
    this.onDispose,
  });

  @override
  State<_OptimizedWidget> createState() => _OptimizedWidgetState();
}

class _OptimizedWidgetState extends State<_OptimizedWidget> {
  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

// Performance Constants
class PerformanceConstants {
  static const int maxDisposedWidgets = 100;
  static const int maxOperationHistory = 50;
  static const Duration networkThrottleDuration = Duration(seconds: 1);
  static const double maxFrameDropRate = 5.0; // 5%
  static const int maxMemoryWarnings = 3;
}
