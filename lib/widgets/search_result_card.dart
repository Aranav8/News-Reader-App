import 'package:flutter/material.dart';

import '../models/news_model.dart';
import '../views/news_detail_screen.dart';

class SearchResultCard extends StatelessWidget {
  final News article;

  const SearchResultCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsDetailScreen(article: article),
        ),
      ),
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
        if (article.author.isNotEmpty)
          Text(
            'By ${article.author}',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        SizedBox(height: 4),
        _buildMetaInfo(),
      ],
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Text(
          article.sourceName,
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
