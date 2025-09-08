import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SearchBar extends StatefulWidget {
  final String? initialQuery;
  final String hintText;
  final Function(String) onQueryChanged;
  final Function(String) onSubmitted;
  final VoidCallback? onClear;
  final bool showFilter;
  final VoidCallback? onFilterTap;

  const SearchBar({
    super.key,
    this.initialQuery,
    this.hintText = 'Search for restaurants or dishes...',
    required this.onQueryChanged,
    required this.onSubmitted,
    this.onClear,
    this.showFilter = true,
    this.onFilterTap,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onQueryChanged(String query) {
    widget.onQueryChanged(query);
  }

  void _onSubmitted(String query) {
    widget.onSubmitted(query);
    _focusNode.unfocus();
  }

  void _onClear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _isFocused ? Colors.white : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: _isFocused ? AppTheme.primaryColor : AppTheme.borderColor,
          width: _isFocused ? 2 : 1,
        ),
        boxShadow: _isFocused ? AppTheme.shadowM : null,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.spacingM),
            child: Icon(
              Icons.search,
              color: _isFocused ? AppTheme.primaryColor : AppTheme.textTertiaryColor,
              size: 20,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: _onQueryChanged,
              onSubmitted: _onSubmitted,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textTertiaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                  vertical: AppTheme.spacingM,
                ),
              ),
              style: AppTheme.bodyMedium,
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, size: 20),
              onPressed: _onClear,
              color: AppTheme.textTertiaryColor,
            ),
          if (widget.showFilter)
            IconButton(
              icon: const Icon(Icons.tune, size: 20),
              onPressed: widget.onFilterTap,
              color: _isFocused ? AppTheme.primaryColor : AppTheme.textTertiaryColor,
            ),
        ],
      ),
    );
  }
}
