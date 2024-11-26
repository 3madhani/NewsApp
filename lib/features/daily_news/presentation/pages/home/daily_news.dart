import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'package:news_app/features/daily_news/presentation/pages/saved_article/saved_article.dart';
import 'package:news_app/features/daily_news/presentation/widgets/article_tile.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/article/remote/remote_article_bloc.dart';
import '../../bloc/article/remote/remote_article_state.dart';
import '../../widgets/country_drop_down.dart';
import '../article_detail/article_detail.dart';

class DailyNewsScreen extends StatelessWidget {
  const DailyNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 154,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CountryDropdown(
            onSelected: (selectedCountryCode) {
              selectedCountryCode;
            },
          ),
        ),
        title: const Text(
          "Daily News",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => _onShowSavedArticlesTapped(context),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.bookmark,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: BlocBuilder<RemoteArticleBloc, RemoteArticleState>(
        builder: (context, state) {
          if (state is RemoteArticleLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is RemoteArticleError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 48),
                  const SizedBox(height: 8),
                  const Text("Failed to load articles. Tap to retry."),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<RemoteArticleBloc>(context)
                          .add(const GetRemoteArticleEvent(
                        country: "us",
                      ));
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is RemoteArticleDone) {
            return ListView.builder(
              itemCount: state.articles.length,
              itemBuilder: (context, index) {
                return ArticleTile(
                  article: state.articles[index],
                  onArticleTapped: (article) =>
                      _onArticleTapped(context, state.articles[index]),
                );
              },
            );
          } else if (state is RemoteArticleDone) {
            return const Center(child: Text("No articles available."));
          } else {
            return const Center(child: Text("Something went wrong."));
          }
        },
      ),
    );
  }

  void _onArticleTapped(BuildContext context, ArticleEntity article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetail(article: article),
      ),
    );
  }

  void _onShowSavedArticlesTapped(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SavedArticle(),
      ),
    );
  }
}
