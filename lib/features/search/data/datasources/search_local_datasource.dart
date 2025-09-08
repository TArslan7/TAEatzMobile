import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class SearchLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
  Future<List<String>> getPopularSearches();
  Future<void> savePopularSearches(List<String> searches);
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final SharedPreferences sharedPreferences;

  SearchLocalDataSourceImpl({required this.sharedPreferences});

  static const String _searchHistoryKey = 'search_history';
  static const String _popularSearchesKey = 'popular_searches';

  @override
  Future<List<String>> getSearchHistory() async {
    try {
      final historyJson = sharedPreferences.getString(_searchHistoryKey);
      if (historyJson != null) {
        final List<dynamic> historyList = json.decode(historyJson);
        return historyList.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    try {
      final history = await getSearchHistory();
      
      // Remove if already exists
      history.remove(query);
      
      // Add to beginning
      history.insert(0, query);
      
      // Keep only last 20 searches
      if (history.length > 20) {
        history.removeRange(20, history.length);
      }
      
      await sharedPreferences.setString(_searchHistoryKey, json.encode(history));
    } catch (e) {
      // Silently fail for local storage
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await sharedPreferences.remove(_searchHistoryKey);
    } catch (e) {
      // Silently fail for local storage
    }
  }

  @override
  Future<List<String>> getPopularSearches() async {
    try {
      final popularJson = sharedPreferences.getString(_popularSearchesKey);
      if (popularJson != null) {
        final List<dynamic> popularList = json.decode(popularJson);
        return popularList.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> savePopularSearches(List<String> searches) async {
    try {
      await sharedPreferences.setString(_popularSearchesKey, json.encode(searches));
    } catch (e) {
      // Silently fail for local storage
    }
  }
}
