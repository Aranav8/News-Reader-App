import '../models/news_model.dart';
import '../services/news_service.dart';

class NewsController {
  final NewsService _service = NewsService();

  Future<List<News>> getNews({String category = 'general'}) {
    return _service.fetchNews(category: category);
  }

  Future<List<News>> searchNews(String query) {
    return _service.searchNews(query);
  }
}
