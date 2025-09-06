import 'package:flutter/foundation.dart';
import 'package:news_reader_app/services/connectivity_service.dart';

import '../models/news_model.dart';
import '../services/news_service.dart';
import '../services/storage_service.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsService _newsService = NewsService();
  final StorageService _storageService = StorageService();
  final ConnectivityService _connectivityService = ConnectivityService();

  List<News> _articles = [];
  List<News> _searchResults = [];

  List<News> get articles => _articles;
  List<News> get searchResults => _searchResults;

  bool isLoading = false;
  bool isSearching = false;
  bool isOfflineMode = false;
  String errorMessage = '';
  String searchErrorMessage = '';
  String _currentCategory = 'All';

  String get currentCategory => _currentCategory;

  Future<void> fetchArticles({String category = 'All'}) async {
    isLoading = true;
    errorMessage = '';
    _currentCategory = category;
    notifyListeners();

    final bool isOnline = await _connectivityService.isConnected();
    isOfflineMode = !isOnline;

    try {
      final cacheKey = 'category_$category';

      if (isOnline) {
        final dataIsStale = await _storageService.isDataStale(cacheKey);
        if (!dataIsStale) {
          if (kDebugMode) {
            print("'$category' data is fresh. Loading from Hive cache.");
          }
          _articles = await _storageService.loadArticles(category);
        } else {
          if (kDebugMode) {
            print("'$category' data is stale or not found. Fetching from API.");
          }
          _articles = await _newsService.fetchNews(category: category);
          await _storageService.saveArticles(_articles, category);
        }
      } else {
        if (kDebugMode) {
          print("Device is offline. Loading '$category' from Hive cache.");
        }
        final offlineArticles = await _storageService.loadArticles(category);
        if (offlineArticles.isNotEmpty) {
          _articles = offlineArticles;
        } else {
          errorMessage = 'No connection and no offline data available.';
          _articles = [];
        }
      }
    } catch (e) {
      errorMessage = 'An error occurred: ${e.toString()}';
      _articles = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchArticles(String query) async {
    try {
      isSearching = true;
      searchErrorMessage = '';
      notifyListeners();

      try {
        _searchResults = await _newsService.searchNews(query);
        await _storageService.saveSearchResults(_searchResults, query);
      } catch (e) {
        if (kDebugMode) {
          print('Search API failed, trying offline data: $e');
        }
        final offlineResults = await _storageService.loadSearchResults(query);

        if (offlineResults.isNotEmpty) {
          _searchResults = offlineResults;
          searchErrorMessage = 'Showing offline results';
        } else {
          searchErrorMessage =
              'No internet connection and no offline results available';
          _searchResults = [];
        }
      }
    } catch (e) {
      searchErrorMessage = e.toString();
      _searchResults = [];
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  Future<bool> hasOfflineData(String category) async {
    return await _storageService.hasOfflineData(category);
  }

  Future<void> clearCache() async {
    await _storageService.clearAllCache();
  }

  void clearSearchResults() {
    _searchResults = [];
    searchErrorMessage = '';
    notifyListeners();
  }
}
