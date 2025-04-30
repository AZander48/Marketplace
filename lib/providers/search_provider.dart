import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/search_history.dart';

class SearchProvider with ChangeNotifier {
  List<SearchHistory> _searchHistory = [];
  static const String _storageKey = 'search_history';

  List<SearchHistory> get searchHistory => _searchHistory;

  SearchProvider() {
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(_storageKey) ?? [];
      _searchHistory = historyJson
          .map((json) => SearchHistory.fromJson(jsonDecode(json)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading search history: $e');
    }
  }

  Future<void> addSearchQuery(String query) async {
    if (query.trim().isEmpty) return;

    // Remove any existing entry with the same query
    _searchHistory.removeWhere((item) => item.query.toLowerCase() == query.toLowerCase());

    // Add new query at the beginning
    _searchHistory.insert(0, SearchHistory(
      query: query,
      timestamp: DateTime.now(),
    ));

    // Keep only the last 10 searches
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await _saveSearchHistory();
    notifyListeners();
  }

  Future<void> _saveSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _searchHistory
          .map((item) => jsonEncode(item.toJson()))
          .toList();
      await prefs.setStringList(_storageKey, historyJson);
    } catch (e) {
      debugPrint('Error saving search history: $e');
    }
  }

  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
    await _saveSearchHistory();
    notifyListeners();
  }

  Future<void> addToHistory(String query) async {
    if (query.trim().isEmpty) return;

    // Remove if already exists to avoid duplicates
    _searchHistory.removeWhere((item) => item.query.toLowerCase() == query.toLowerCase());
    // Add to the beginning of the list
    _searchHistory.insert(0, SearchHistory(
      query: query,
      timestamp: DateTime.now(),
    ));
    // Keep only the last 10 searches
    if (_searchHistory.length > 10) {
      _searchHistory = _searchHistory.sublist(0, 10);
    }

    await _saveSearchHistory();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _searchHistory.clear();
    await _saveSearchHistory();
    notifyListeners();
  }
} 