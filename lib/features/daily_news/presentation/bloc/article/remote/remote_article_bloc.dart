import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/domain/use_cases/get_article.dart';
import 'remote_article_event.dart';
import 'remote_article_state.dart';

class RemoteArticleBloc extends Bloc<RemoteArticleEvent, RemoteArticleState> {
  final GetArticleUseCase _getArticleUseCase;

  RemoteArticleBloc(this._getArticleUseCase,)
      : super(const RemoteArticleLoading()) {
    on<GetRemoteArticleEvent>(onGetArticles);
  }

  void onGetArticles(
      GetRemoteArticleEvent event, Emitter<RemoteArticleState> emit) async {
    emit(const RemoteArticleLoading()); // Emit loading state initially

    final dataState = await _getArticleUseCase(params: event.country);

    dataState.fold(
      (failure) {
        emit(RemoteArticleError(message: failure.errMessage));
      },
      (articles) => emit(RemoteArticleDone(articles: articles)),
    );
  }

}
