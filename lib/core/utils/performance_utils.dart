import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PerformanceUtils {
  // Image optimization with better caching
  static Widget optimizedImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: (width * 2).round(), // 2x for retina displays
      memCacheHeight: (height * 2).round(),
      maxWidthDiskCache: 800, // Limit disk cache size
      maxHeightDiskCache: 800,
      placeholder: placeholder ?? (context, url) => _buildShimmerPlaceholder(width, height),
      errorWidget: errorWidget ?? (context, url, error) => _buildErrorWidget(width, height),
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }

  static Widget _buildShimmerPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  static Widget _buildErrorWidget(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }

  // Lazy loading for lists
  static Widget buildLazyListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollController? controller,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
  }) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      // Performance optimizations
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      addSemanticIndexes: false,
      cacheExtent: 200, // Cache 200 pixels worth of items
    );
  }

  // Debounced search
  static void debounce({
    required VoidCallback callback,
    Duration delay = const Duration(milliseconds: 500),
  }) {
    Timer? timer;
    timer?.cancel();
    timer = Timer(delay, callback);
  }
}

// Memory-efficient image cache
class ImageCacheManager {
  static const int maxCacheSize = 100; // Maximum number of images to cache
  
  static void clearCache() {
    CachedNetworkImage.evictFromCache('');
  }
  
  static void preloadImages(List<String> imageUrls) {
    for (final url in imageUrls) {
      CachedNetworkImage.evictFromCache(url);
    }
  }
}

// Performance monitoring
class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};
  
  static void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
  }
  
  static void endTimer(String operation) {
    final startTime = _startTimes[operation];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      debugPrint('Performance: $operation took ${duration.inMilliseconds}ms');
      _startTimes.remove(operation);
    }
  }
}
