import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/local/bloc/local_article_bloc.dart';
import '../../../../../injection_container.dart';

class ArticleDetail extends StatelessWidget {
  final ArticleEntity? article;

  const ArticleDetail({this.article, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(SubscribeToSavedArticles()),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildArticleTitleAndDate(),
              _buildArticleImage(),
              _buildArticleDescription(),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Ionicons.chevron_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildArticleTitleAndDate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article?.title ?? "No title",
            style: const TextStyle(
              fontFamily: 'Butler',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Ionicons.time_outline, size: 16),
              const SizedBox(width: 5),
              Text(
                article?.publishedAt ?? "No date",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleImage() {
    // Check if the image URL is null, empty, or invalid
    if (article?.urlToImage == null || article!.urlToImage!.isEmpty) {
      return const Center(
        child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
      );
    }

    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.only(top: 14),
      child: CachedNetworkImage(
        imageUrl: article!.urlToImage!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Center(
            child: Icon(Icons.error, size: 100, color: Colors.red)),
      ),
    );
  }

  Widget _buildArticleDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
      child: Text(
        "${article?.description ?? 'No description available.'}\n\n${article?.content ?? ''}",
        style: const TextStyle(fontSize: 16, height: 1.5),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return BlocBuilder<LocalArticleBloc, LocalArticleState>(
      builder: (context, state) {
        final isSaved = state is LocalArticleDone &&
            state.articles.any((saved) => saved.title == article?.title);
        return FloatingActionButton(
          backgroundColor: isSaved ? Colors.red : Colors.blue,
          onPressed: () {
            if (isSaved) {
              context.read<LocalArticleBloc>().add(RemoveArticle(article!));
              _showSnackBar(
                  context, 'Article removed successfully', Colors.red);
            } else {
              context.read<LocalArticleBloc>().add(SaveArticle(article!));
              _showSnackBar(
                  context, 'Article saved successfully', Colors.green);
            }
          },
          child: Icon(
            isSaved ? Icons.delete : Ionicons.bookmark,
            color: Colors.white,
            size: 26,
          ),
        );
      },
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        duration: const Duration(milliseconds: 500),
        content: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
