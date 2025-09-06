import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class NewsService {
  String get apiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  String get baseUrl => 'https://newsapi.org/v2';

  Future<List<News>> fetchNews({String category = 'general'}) async {
    try {
      String url = _buildUrl(category);

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NewsReaderApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'ok') {
          final List articles = data['articles'] ?? [];
          return articles
              .map((json) => News.fromJson(json))
              .where(_isValidArticle)
              .toList()
              .cast<News>();
        } else {
          throw Exception('News API returned status: ${data['status']}');
        }
      } else {
        throw Exception('Failed to fetch news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching news: $e');
    }
  }

  Future<List<News>> searchNews(String query) async {
    try {
      if (query.trim().isEmpty) {
        return [];
      }

      final url =
          '$baseUrl/everything?q=${Uri.encodeComponent(query)}&language=en&sortBy=relevancy&pageSize=20&apiKey=$apiKey';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'NewsReaderApp/1.0',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'ok') {
          final List articles = data['articles'] ?? [];
          return articles
              .map((json) => News.fromJson(json))
              .where(_isValidArticle)
              .toList()
              .cast<News>();
        } else {
          throw Exception('News API returned status: ${data['status']}');
        }
      } else {
        throw Exception('Failed to search news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching news: $e');
    }
  }

  String _buildUrl(String category) {
    switch (category) {
      case 'All':
      case 'general':
        return '$baseUrl/top-headlines?sources=bbc-news&apiKey=$apiKey';
      case 'World':
        return '$baseUrl/everything?q=world&language=en&sortBy=publishedAt&pageSize=20&apiKey=$apiKey';
      case 'Politics':
        return '$baseUrl/everything?q=politics&language=en&sortBy=publishedAt&pageSize=20&apiKey=$apiKey';
      case 'Business':
        return '$baseUrl/top-headlines?category=business&apiKey=$apiKey';
      case 'Technology':
        return '$baseUrl/top-headlines?category=technology&apiKey=$apiKey';
      case 'Entertainment':
        return '$baseUrl/top-headlines?category=entertainment&apiKey=$apiKey';
      case 'Sports':
        return '$baseUrl/top-headlines?category=sports&apiKey=$apiKey';
      case 'Science':
        return '$baseUrl/top-headlines?category=science&apiKey=$apiKey';
      case 'Health':
        return '$baseUrl/top-headlines?category=health&apiKey=$apiKey';
      default:
        return '$baseUrl/top-headlines?country=us&apiKey=$apiKey';
    }
  }

  bool _isValidArticle(News article) {
    return article.title.isNotEmpty &&
        article.description.isNotEmpty &&
        article.title != '[Removed]' &&
        article.description != '[Removed]' &&
        !article.title.contains('[Removed]');
  }
}
