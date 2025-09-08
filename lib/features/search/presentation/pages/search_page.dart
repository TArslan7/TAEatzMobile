import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/theme_manager.dart';
import '../../../../core/utils/extensions.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_bar.dart' as custom;
import '../widgets/search_result_card.dart';
import '../widgets/search_suggestion_item.dart';
import '../widgets/popular_search_chip.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    // Load popular searches and search history
    context.read<SearchBloc>().add(const GetPopularSearches());
    context.read<SearchBloc>().add(const LoadSearchHistory());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      _currentQuery = query;
    });
    
    context.read<SearchBloc>().add(SearchQueryChanged(query: query));
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    
    context.read<SearchBloc>().add(SearchSubmitted(query: query.trim()));
  }

  void _onClearSearch() {
    setState(() {
      _currentQuery = '';
    });
    _searchController.clear();
    context.read<SearchBloc>().add(const ClearSearch());
  }

  void _onSuggestionTapped(String suggestion) {
    _searchController.text = suggestion;
    _onSearchSubmitted(suggestion);
  }

  void _onPopularSearchTapped(String searchTerm) {
    _searchController.text = searchTerm;
    _onSearchSubmitted(searchTerm);
  }

  void _onResultTapped(result) {
    // TODO: Navigate to appropriate page based on result type
    context.showSnackBar('Navigation to ${result.title} coming soon!');
  }

  void _onFilterTap() {
    // TODO: Open search filters
    context.showSnackBar('Search filters coming soon!');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return Scaffold(
          backgroundColor: themeManager.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Search',
              style: TextStyle(color: themeManager.textColor),
            ),
            backgroundColor: themeManager.cardColor,
            elevation: 0,
            iconTheme: IconThemeData(color: themeManager.textColor),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.brightness_6_outlined,
                  color: themeManager.textColor,
                ),
                onPressed: () => themeManager.toggleTheme(),
              ),
              if (_currentQuery.isNotEmpty)
                TextButton(
                  onPressed: _onClearSearch,
                  child: Text(
                    'Clear',
                    style: TextStyle(color: themeManager.primaryRed),
                  ),
                ),
            ],
          ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: custom.SearchBar(
              initialQuery: _currentQuery,
              onQueryChanged: _onQueryChanged,
              onSubmitted: _onSearchSubmitted,
              onClear: _onClearSearch,
              onFilterTap: _onFilterTap,
            ),
          ),
          // Search Results
          Expanded(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is SearchError) {
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
                            if (_currentQuery.isNotEmpty) {
                              _onSearchSubmitted(_currentQuery);
                            }
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is SearchEmpty) {
                  return _buildEmptyState();
                }

                if (state is SearchResultsLoaded) {
                  return _buildSearchResults(state.results);
                }

                if (state is SearchSuggestionsLoaded) {
                  return _buildSuggestions(state.suggestions);
                }

                if (state is PopularSearchesLoaded) {
                  return _buildPopularSearches(state.popularSearches);
                }

                if (state is SearchHistoryLoaded) {
                  return _buildSearchHistory(state.searchHistory);
                }

                return _buildInitialState();
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildInitialState() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is PopularSearchesLoaded) {
          return _buildPopularSearches(state.popularSearches);
        }
        
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppTheme.textTertiaryColor,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'No results found',
            style: AppTheme.heading6,
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            'Try searching for something else',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return SearchResultCard(
          result: result,
          onTap: () => _onResultTapped(result),
        );
      },
    );
  }

  Widget _buildSuggestions(List<String> suggestions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Text(
            'Suggestions',
            style: AppTheme.heading6,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];
              return SearchSuggestionItem(
                suggestion: suggestion,
                onTap: () => _onSuggestionTapped(suggestion),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularSearches(List<String> popularSearches) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Searches',
            style: AppTheme.heading6,
          ),
          const SizedBox(height: AppTheme.spacingM),
          Wrap(
            spacing: AppTheme.spacingS,
            runSpacing: AppTheme.spacingS,
            children: popularSearches.map((searchTerm) {
              return PopularSearchChip(
                searchTerm: searchTerm,
                onTap: () => _onPopularSearchTapped(searchTerm),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory(List<String> searchHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTheme.heading6,
              ),
              TextButton(
                onPressed: () {
                  context.read<SearchBloc>().add(const ClearSearchHistory());
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final historyItem = searchHistory[index];
              return SearchSuggestionItem(
                suggestion: historyItem,
                onTap: () => _onSuggestionTapped(historyItem),
                onRemove: () {
                  // TODO: Remove individual history item
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
