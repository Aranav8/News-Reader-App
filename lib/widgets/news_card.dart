import 'package:flutter/material.dart';

import '../models/news_model.dart';

class NewsCard extends StatelessWidget {
  final News article;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),
          SizedBox(width: 16),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 100,
        width: 140,
        child: article.urlToImage.isNotEmpty
            ? Image.network(
                article.urlToImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[400], size: 40),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: Icon(Icons.image, color: Colors.grey[400], size: 40),
              ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          article.title,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.3,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          article.description.length > 100
              ? '${article.description.substring(0, 100)}...'
              : article.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.2),
        ),
        SizedBox(height: 8),
        _buildMetaInfo(),
      ],
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Text(
          _getCategoryFromSource(article.sourceName),
          style: TextStyle(
            color: Colors.blue[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 3,
          height: 3,
          decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
        ),
        SizedBox(width: 8),
        Text(
          _formatTimeAgo(article.publishedAt),
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  String _getCategoryFromSource(String sourceName) {
    final sourceCategories = {
      'CNN': 'World',
      'BBC News': 'World',
      'Reuters': 'World',
      'Associated Press': 'World',
      'The New York Times': 'Politics',
      'The Washington Post': 'Politics',
      'Entertainment Weekly': 'Entertainment',
      'Variety': 'Entertainment',
      'Scientific American': 'Science',
      'National Geographic': 'Science',
      'TechCrunch': 'Technology',
      'Wired': 'Technology',
      'ESPN': 'Sports',
      'Bloomberg': 'Business',
      'WebMD': 'Health',
    };

    return sourceCategories[sourceName] ?? 'General';
  }

  String _formatTimeAgo(String publishedAt) {
    try {
      final date = DateTime.parse(publishedAt);
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "${diff.inHours}h ago";
      return "${diff.inDays}d ago";
    } catch (_) {
      return "";
    }
  }
}
