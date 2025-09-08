import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../utils/performance_utils.dart';
import 'animated_widgets.dart';

// Advanced pull-to-refresh widget
class AdvancedPullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? backgroundColor;
  final Color? color;
  final double displacement;
  final double edgeOffset;
  final bool showRefreshIndicator;

  const AdvancedPullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.backgroundColor,
    this.color,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.showRefreshIndicator = true,
  });

  @override
  State<AdvancedPullToRefresh> createState() => _AdvancedPullToRefreshState();
}

class _AdvancedPullToRefreshState extends State<AdvancedPullToRefresh>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    
    setState(() {
      _isRefreshing = true;
    });
    
    _animationController.forward();
    
    try {
      await widget.onRefresh();
    } finally {
      _animationController.reverse();
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).cardColor,
      color: widget.color ?? Theme.of(context).primaryColor,
      displacement: widget.displacement,
      edgeOffset: widget.edgeOffset,
      child: Stack(
        children: [
          widget.child,
          if (_isRefreshing && widget.showRefreshIndicator)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor ?? Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.color ?? Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Refreshing...',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// Infinite scroll list widget
class InfiniteScrollList<T> extends StatefulWidget {
  final Future<List<T>> Function(int page, int limit) loadData;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget Function(BuildContext)? loadingWidget;
  final Widget Function(BuildContext)? errorWidget;
  final Widget Function(BuildContext)? emptyWidget;
  final int pageSize;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final Axis scrollDirection;

  const InfiniteScrollList({
    super.key,
    required this.loadData,
    required this.itemBuilder,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.pageSize = 20,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
  });

  @override
  State<InfiniteScrollList<T>> createState() => _InfiniteScrollListState<T>();
}

class _InfiniteScrollListState<T> extends State<InfiniteScrollList<T>> {
  final List<T> _items = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  bool _hasError = false;
  int _currentPage = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final newItems = await widget.loadData(0, widget.pageSize);
      setState(() {
        _items.clear();
        _items.addAll(newItems);
        _hasMore = newItems.length == widget.pageSize;
        _currentPage = 0;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newItems = await widget.loadData(_currentPage + 1, widget.pageSize);
      setState(() {
        _items.addAll(newItems);
        _hasMore = newItems.length == widget.pageSize;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> refresh() async {
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _items.isEmpty) {
      return widget.errorWidget?.call(context) ?? 
             Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                   const SizedBox(height: 16),
                   Text(
                     'Error loading data',
                     style: Theme.of(context).textTheme.headlineSmall,
                   ),
                   const SizedBox(height: 8),
                   Text(
                     _errorMessage ?? 'Unknown error',
                     style: Theme.of(context).textTheme.bodyMedium,
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: 16),
                   ElevatedButton(
                     onPressed: _loadInitialData,
                     child: const Text('Retry'),
                   ),
                 ],
               ),
             );
    }

    if (_items.isEmpty && !_isLoading) {
      return widget.emptyWidget?.call(context) ?? 
             Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                   const SizedBox(height: 16),
                   Text(
                     'No data available',
                     style: Theme.of(context).textTheme.headlineSmall,
                   ),
                 ],
               ),
             );
    }

    return ListView.builder(
      controller: widget.controller ?? _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      itemCount: _items.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _items.length) {
          return FadeInWidget(
            duration: const Duration(milliseconds: 300),
            delay: Duration(milliseconds: index * 50),
            child: widget.itemBuilder(context, _items[index], index),
          );
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    if (!_isLoading) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              'Loading more...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Smart list view with performance optimizations
class SmartListView extends StatelessWidget {
  final List<Widget> children;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final Axis scrollDirection;
  final bool enablePullToRefresh;
  final Future<void> Function()? onRefresh;
  final bool enableInfiniteScroll;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const SmartListView({
    super.key,
    required this.children,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.enablePullToRefresh = false,
    this.onRefresh,
    this.enableInfiniteScroll = false,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget listView = PerformanceUtils.buildLazyListView(
      itemCount: children.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < children.length) {
          return children[index];
        } else {
          return _buildLoadingIndicator();
        }
      },
      controller: controller,
      padding: padding,
      shrinkWrap: shrinkWrap,
    );

    if (enablePullToRefresh && onRefresh != null) {
      listView = AdvancedPullToRefresh(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }

  Widget _buildLoadingIndicator() {
    if (!isLoadingMore) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// Staggered grid view
class StaggeredGridView extends StatelessWidget {
  final List<Widget> children;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final ScrollController? controller;

  const StaggeredGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: controller,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return FadeInWidget(
          duration: const Duration(milliseconds: 300),
          delay: Duration(milliseconds: index * 100),
          child: children[index],
        );
      },
    );
  }
}
