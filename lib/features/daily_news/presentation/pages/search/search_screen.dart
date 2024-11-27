import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/search/cubit/search_article_cubit.dart';

import '../../../domain/entities/article.dart';
import '../../widgets/article_tile.dart';
import '../article_detail/article_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchArticleCubit>(context).resetSearch();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7), // Shadow color
                      offset: const Offset(0, 7), // Position the shadow below
                      blurRadius: 6, // Blurriness of the shadow
                      spreadRadius: 0, // Spread of the shadow
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  onTap: () {
                    final query = controller.text.trim(); // Get the query
                    if (query.isEmpty) return;
                    BlocProvider.of<SearchArticleCubit>(context)
                        .searchArticles(query: query);
                  },
                  onSubmitted: (value) {
                    final query = value.trim(); // Get the query
                    if (query.isEmpty) return;
                    BlocProvider.of<SearchArticleCubit>(context)
                        .searchArticles(query: query);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2),
                    ),
                    prefixIcon: IconButton(
                      onPressed: () {
                        final query = controller.text.trim(); // Get the query
                        if (query.isEmpty) return;
                        BlocProvider.of<SearchArticleCubit>(context)
                            .searchArticles(query: query);
                      },
                      icon: const Icon(Icons.search),
                    ),
                    suffixIcon: const Icon(Icons.mic),
                    labelText: 'Search',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 106, 106, 106),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )),
              SliverFillRemaining(
                child: _buildBody(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<SearchArticleCubit, SearchArticleState>(
      builder: (context, state) {
        if (state is SearchArticleInitial) {
          return Center(
              child: Text(
            "Start searching".toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ));
        } else if (state is SearchArticleError) {
          return Center(
            child: Text(
              state.errMessage,
              style: const TextStyle(fontSize: 18),
            ),
          );
        } else if (state is SearchArticleSuccess) {
          if (state.articles.isEmpty) {
            return Center(
              child: Text(
                "No articles available.".toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          }
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
        } else {
          return const Center(child: CupertinoActivityIndicator());
        }
      },
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
}
