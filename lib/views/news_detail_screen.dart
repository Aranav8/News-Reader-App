import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  final News article;

  const NewsDetailScreen({super.key, required this.article});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isLaunching = false;

  String _cleanContent(String text) {
    return text.replaceAll(RegExp(r'\[\+\d+\s+chars\]'), '').trim();
  }

  Future<void> _launchURL() async {
    if (widget.article.url.isEmpty) {
      _showSnackBar('No URL available for this article');
      return;
    }

    setState(() => _isLaunching = true);

    try {
      final Uri url = Uri.parse(widget.article.url);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(url, mode: LaunchMode.inAppWebView)) {
          _showSnackBar('Could not launch the article URL');
        }
      }
    } catch (e) {
      _showSnackBar('Error opening article: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLaunching = false);
      }
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red[600],
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  String _formatTimeAgo(String publishedAt) {
    try {
      final date = DateTime.parse(publishedAt);
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 60) return "${diff.inMinutes} minutes ago";
      if (diff.inHours < 24) return "${diff.inHours} hours ago";
      return "${diff.inDays} days ago";
    } catch (_) {
      return "Recently";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String displayText = widget.article.content.isNotEmpty
        ? _cleanContent(widget.article.content)
        : widget.article.description;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.article.urlToImage.isNotEmpty) _buildHeroImage(),
              SizedBox(height: 16),
              _buildMetaInfo(),
              SizedBox(height: 16),
              _buildTitle(),
              SizedBox(height: 16),
              if (widget.article.author.isNotEmpty) _buildAuthor(),
              SizedBox(height: 20),
              _buildContent(displayText),
              SizedBox(height: 30),
              _buildReadMoreButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: Image.network(
          widget.article.urlToImage,
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
              child: Icon(Icons.image, color: Colors.grey[400], size: 60),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Text(
          widget.article.sourceName,
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
          _formatTimeAgo(widget.article.publishedAt),
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.article.title,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildAuthor() {
    return Text(
      'By ${widget.article.author}',
      style: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildContent(String displayText) {
    return Text(
      displayText,
      style: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
    );
  }

  Widget _buildReadMoreButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLaunching ? null : _launchURL,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[400],
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLaunching
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('Opening...'),
                ],
              )
            : Text(
                'Read Full Article',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
