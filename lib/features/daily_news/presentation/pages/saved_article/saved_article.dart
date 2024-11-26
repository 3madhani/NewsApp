import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ionicons/ionicons.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import 'package:news_app/features/daily_news/presentation/widgets/article_tile.dart';

import '../../../../../injection_container.dart';
import '../../bloc/article/local/bloc/local_article_bloc.dart';
import '../article_detail/article_detail.dart';

class SavedArticle extends HookWidget {
  const SavedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocalArticleBloc>()..add(SubscribeToSavedArticles()),
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: _buildBackButton(),
      title: const Text(
        "Saved Articles",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Builder(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onBackButtonTapped(context),
          child: const Icon(
            Ionicons.chevron_back,
            color: Colors.black,
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return BlocBuilder<LocalArticleBloc, LocalArticleState>(
      builder: (context, state) {
        if (state is LocalArticleLoading) {
          return _buildLoadingIndicator();
        } else if (state is LocalArticleDone) {
          return _buildArticleList(state.articles);
        }
        return const SizedBox(); // Default state handling
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget _buildArticleList(List<ArticleEntity> articles) {
    if (articles.isEmpty) {
      return _buildNoArticlesMessage();
    }

    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return ArticleTile(
          article: articles[index],
          isRemovable: true,
          onRemove: (article) => _onRemoveArticle(context, article),
          onArticleTapped: (article) => _onArticleTapped(context, article),
        );
      },
    );
  }

  Widget _buildNoArticlesMessage() {
    return Center(
      child: Text(
        "No saved articles".toUpperCase(),
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onBackButtonTapped(BuildContext context) {
    Navigator.pop(context);
  }

  void _onRemoveArticle(BuildContext context, ArticleEntity article) {
    BlocProvider.of<LocalArticleBloc>(context).add(RemoveArticle(article));
  }

  void _onArticleTapped(BuildContext context, ArticleEntity article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetail(article: article),
      ),
    );
  }
}
