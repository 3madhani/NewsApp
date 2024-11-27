import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import 'package:news_app/features/daily_news/domain/repository/article_repo.dart';

part 'search_article_state.dart';

class SearchArticleCubit extends Cubit<SearchArticleState> {
  final ArticleRepository _articleRepository;
  SearchArticleCubit(this._articleRepository) : super(SearchArticleInitial());

  void searchArticles({required String query}) async {
    emit(SearchArticleLoading());
    var result = await _articleRepository.getQueryArticles(query: query);

    

    result.fold((failure) {
      emit(
        SearchArticleError(
          errMessage: failure.errMessage,
        ),
      );
    }, (articles) {
      emit(
        SearchArticleSuccess(
          articles: articles,
        ),
      );
    });
  }

  void resetSearch() {
    emit(SearchArticleInitial());
  }
}
