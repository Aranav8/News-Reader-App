import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/news_model.dart';

class StorageService {
  static const String _articlesBoxName = 'articles_cache';
  static const String _searchResultsBoxName = 'search_results_cache';
  static const String _timestampsBoxName = 'timestamps_cache';

  Future<Box<List>> _openArticlesBox() async {
    return await Hive.openBox<List>(_articlesBoxName);
  }

  Future<Box<List>> _openSearchResultsBox() async {
    return await Hive.openBox<List>(_searchResultsBoxName);
  }

  Future<Box<String>> _openTimestampsBox() async {
    return await Hive.openBox<String>(_timestampsBoxName);
  }

  Future<void> saveArticles(List<News> articles, String category) async {
    try {
      final articlesBox = await _openArticlesBox();
      await articlesBox.put(category, articles);

      final timestampsBox = await _openTimestampsBox();
      final timestampKey = 'category_$category';
      await timestampsBox.put(timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving articles to Hive: $e');
      }
    }
  }

  Future<List<News>> loadArticles(String category) async {
    try {
      final articlesBox = await _openArticlesBox();
      final articles = articlesBox.get(category);

      if (articles != null) {
        return List<News>.from(articles);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading articles from Hive: $e');
      }
    }
    return [];
  }

  Future<void> saveSearchResults(List<News> articles, String query) async {
    try {
      final searchBox = await _openSearchResultsBox();
      await searchBox.put(query, articles);

      final timestampsBox = await _openTimestampsBox();
      final timestampKey = 'search_$query';
      await timestampsBox.put(timestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving search results to Hive: $e');
      }
    }
  }

  Future<List<News>> loadSearchResults(String query) async {
    try {
      final searchBox = await _openSearchResultsBox();
      final articles = searchBox.get(query);

      if (articles != null) {
        return List<News>.from(articles);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading search results from Hive: $e');
      }
    }
    return [];
  }

  Future<DateTime?> getLastUpdateTime(String key) async {
    try {
      final timestampsBox = await _openTimestampsBox();
      final timeString = timestampsBox.get(key);
      if (timeString != null) {
        return DateTime.parse(timeString);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting last update time from Hive: $e');
      }
    }
    return null;
  }

  Future<bool> hasOfflineData(String category) async {
    try {
      final articlesBox = await _openArticlesBox();
      return articlesBox.containsKey(category);
    } catch (e) {
      return false;
    }
  }

  Future<bool> isDataStale(String key) async {
    final lastUpdate = await getLastUpdateTime(key);
    if (lastUpdate == null) return true;

    final thirtyMinutesAgo = DateTime.now().subtract(
      const Duration(minutes: 30),
    );
    return lastUpdate.isBefore(thirtyMinutesAgo);
  }

  Future<void> clearAllCache() async {
    try {
      await Hive.deleteBoxFromDisk(_articlesBoxName);
      await Hive.deleteBoxFromDisk(_searchResultsBoxName);
      await Hive.deleteBoxFromDisk(_timestampsBoxName);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing Hive cache: $e');
      }
    }
  }
}
