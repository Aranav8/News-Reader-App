import 'package:flutter/material.dart';
import 'package:news_reader_app/models/news_model.dart';
import 'package:news_reader_app/views/news_detail_screen.dart';
import 'package:news_reader_app/views/search_screen.dart';
import 'package:news_reader_app/widgets/news_card.dart';
import 'package:provider/provider.dart';

import '../viewmodels/news_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> categories = [
    "All",
    "World",
    "Politics",
    "Business",
    "Technology",
    "Entertainment",
    "Sports",
    "Science",
    "Health",
  ];
  String selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NewsViewModel>(
        context,
        listen: false,
      ).fetchArticles(category: selectedCategory),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewsViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (viewModel.isOfflineMode) _buildOfflineBanner(),
          _buildCategoryList(),
          _buildContentArea(viewModel),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(Icons.apps, color: Colors.white, size: 16),
          ),
          SizedBox(width: 8),
          Text(
            "News reader",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange[100],
      child: Row(
        children: [
          Icon(Icons.wifi_off, size: 16, color: Colors.orange[800]),
          SizedBox(width: 8),
          Text(
            'Showing offline content',
            style: TextStyle(
              color: Colors.orange[800],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() => selectedCategory = category);
              Provider.of<NewsViewModel>(
                context,
                listen: false,
              ).fetchArticles(category: category);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemCount: categories.length,
      ),
    );
  }

  Widget _buildContentArea(NewsViewModel viewModel) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => viewModel.fetchArticles(category: selectedCategory),
        child: viewModel.isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.black))
            : viewModel.errorMessage.isNotEmpty
            ? _buildErrorState(viewModel)
            : _buildNewsList(viewModel),
      ),
    );
  }

  Widget _buildErrorState(NewsViewModel viewModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Failed to load news',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () =>
                viewModel.fetchArticles(category: selectedCategory),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(NewsViewModel viewModel) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: viewModel.articles.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        final article = viewModel.articles[index];
        return NewsCard(
          article: article,
          onTap: () => _navigateToDetail(article),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(Icons.home, color: Colors.black, size: 28),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            ),
            child: Icon(Icons.search, color: Colors.grey, size: 28),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(News article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(article: article),
      ),
    );
  }
}
