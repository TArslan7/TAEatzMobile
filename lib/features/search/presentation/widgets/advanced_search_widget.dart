import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/animated_widgets.dart';

class AdvancedSearchWidget extends StatefulWidget {
  final String? initialQuery;
  final Function(String) onSearch;
  final Function()? onVoiceSearch;
  final List<String> recentSearches;
  final List<String> suggestions;
  final bool showFilters;
  final VoidCallback? onFilterTap;

  const AdvancedSearchWidget({
    super.key,
    this.initialQuery,
    required this.onSearch,
    this.onVoiceSearch,
    this.recentSearches = const [],
    this.suggestions = const [],
    this.showFilters = true,
    this.onFilterTap,
  });

  @override
  State<AdvancedSearchWidget> createState() => _AdvancedSearchWidgetState();
}

class _AdvancedSearchWidgetState extends State<AdvancedSearchWidget>
    with TickerProviderStateMixin {
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isSearching = false;
  bool _showSuggestions = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _focusNode.addListener(_onFocusChange);
    _searchController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus;
    });
    if (_focusNode.hasFocus) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onTextChanged() {
    setState(() {
      _currentQuery = _searchController.text;
      _isSearching = _currentQuery.isNotEmpty;
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.onSearch(query.trim());
      _focusNode.unfocus();
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  void _onVoiceSearch() {
    HapticFeedback.lightImpact();
    widget.onVoiceSearch?.call();
  }

  void _onFilterTap() {
    HapticFeedback.lightImpact();
    widget.onFilterTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onSubmitted: _performSearch,
            decoration: InputDecoration(
              hintText: 'Search restaurants, dishes, or cuisines...',
              hintStyle: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textTertiaryColor,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: _isSearching ? AppTheme.primaryColor : AppTheme.textTertiaryColor,
              ),
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isSearching)
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                          _currentQuery = '';
                        });
                      },
                      icon: Icon(
                        Icons.clear,
                        color: AppTheme.textTertiaryColor,
                      ),
                    ),
                  if (widget.onVoiceSearch != null)
                    IconButton(
                      onPressed: _onVoiceSearch,
                      icon: Icon(
                        Icons.mic,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  if (widget.showFilters && widget.onFilterTap != null)
                    IconButton(
                      onPressed: _onFilterTap,
                      icon: Icon(
                        Icons.tune,
                        color: AppTheme.textTertiaryColor,
                      ),
                    ),
                ],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),

        // Suggestions Panel
        if (_showSuggestions)
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.recentSearches.isNotEmpty) ...[
                      _buildSectionHeader('Recent Searches'),
                      ...widget.recentSearches.take(3).map((search) => _buildSuggestionItem(
                        search,
                        Icons.history,
                        () => _performSearch(search),
                      )),
                      const Divider(height: 1),
                    ],
                    if (widget.suggestions.isNotEmpty) ...[
                      _buildSectionHeader('Suggestions'),
                      ...widget.suggestions.take(5).map((suggestion) => _buildSuggestionItem(
                        suggestion,
                        Icons.search,
                        () => _performSearch(suggestion),
                      )),
                    ],
                    if (widget.recentSearches.isEmpty && widget.suggestions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Start typing to search...',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.textTertiaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Text(
        title,
        style: AppTheme.caption.copyWith(
          color: AppTheme.textTertiaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSuggestionItem(String text, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: AppTheme.textTertiaryColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: AppTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Voice Search Widget
class VoiceSearchWidget extends StatefulWidget {
  final Function(String) onResult;
  final VoidCallback? onError;

  const VoiceSearchWidget({
    super.key,
    required this.onResult,
    this.onError,
  });

  @override
  State<VoiceSearchWidget> createState() => _VoiceSearchWidgetState();
}

class _VoiceSearchWidgetState extends State<VoiceSearchWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });
    _pulseController.repeat(reverse: true);
    
    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onResult('Pizza near me');
        _stopListening();
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _pulseController.stop();
    _pulseController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isListening ? _stopListening : _startListening,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isListening ? _pulseAnimation.value : 1.0,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening ? AppTheme.errorColor : AppTheme.primaryColor,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? AppTheme.errorColor : AppTheme.primaryColor)
                        .withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                _isListening ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 32,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Search Filters Widget
class SearchFiltersWidget extends StatefulWidget {
  final List<String> selectedCategories;
  final List<String> selectedPriceRanges;
  final double? maxDistance;
  final double? minRating;
  final Function(List<String>) onCategoriesChanged;
  final Function(List<String>) onPriceRangesChanged;
  final Function(double?) onMaxDistanceChanged;
  final Function(double?) onMinRatingChanged;
  final VoidCallback onApply;
  final VoidCallback onClear;

  const SearchFiltersWidget({
    super.key,
    required this.selectedCategories,
    required this.selectedPriceRanges,
    this.maxDistance,
    this.minRating,
    required this.onCategoriesChanged,
    required this.onPriceRangesChanged,
    required this.onMaxDistanceChanged,
    required this.onMinRatingChanged,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<SearchFiltersWidget> createState() => _SearchFiltersWidgetState();
}

class _SearchFiltersWidgetState extends State<SearchFiltersWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: AppTheme.headlineSmall,
              ),
              TextButton(
                onPressed: widget.onClear,
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Categories
          Text('Categories', style: AppTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.restaurantCategories.map((category) {
              final isSelected = widget.selectedCategories.contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  final newCategories = List<String>.from(widget.selectedCategories);
                  if (selected) {
                    newCategories.add(category);
                  } else {
                    newCategories.remove(category);
                  }
                  widget.onCategoriesChanged(newCategories);
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Price Range
          Text('Price Range', style: AppTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['€', '€€', '€€€', '€€€€'].map((price) {
              final isSelected = widget.selectedPriceRanges.contains(price);
              return FilterChip(
                label: Text(price),
                selected: isSelected,
                onSelected: (selected) {
                  final newPrices = List<String>.from(widget.selectedPriceRanges);
                  if (selected) {
                    newPrices.add(price);
                  } else {
                    newPrices.remove(price);
                  }
                  widget.onPriceRangesChanged(newPrices);
                },
              );
            }).toList(),
          ),
          
          const SizedBox(height: 16),
          
          // Distance
          Text('Max Distance', style: AppTheme.titleMedium),
          const SizedBox(height: 8),
          Slider(
            value: widget.maxDistance ?? 5.0,
            min: 0.5,
            max: 20.0,
            divisions: 39,
            label: '${(widget.maxDistance ?? 5.0).toStringAsFixed(1)} km',
            onChanged: (value) {
              widget.onMaxDistanceChanged(value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Rating
          Text('Min Rating', style: AppTheme.titleMedium),
          const SizedBox(height: 8),
          Slider(
            value: widget.minRating ?? 3.0,
            min: 1.0,
            max: 5.0,
            divisions: 8,
            label: '${(widget.minRating ?? 3.0).toStringAsFixed(1)} ⭐',
            onChanged: (value) {
              widget.onMinRatingChanged(value);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Apply Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onApply,
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
