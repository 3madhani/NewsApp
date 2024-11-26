import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/domain/use_cases/gat_saved_article.dart';
import 'package:news_app/features/daily_news/domain/use_cases/saved_article.dart';
import 'package:news_app/features/daily_news/domain/use_cases/remove_article.dart';
import 'dart:async';

import '../../../../../domain/entities/article.dart';

part 'local_article_event.dart';
part 'local_article_state.dart';

class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticleState> {
  final GetSavedArticleUseCase _getSavedArticlesUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  StreamSubscription<List<ArticleEntity>>? _articleSubscription;

  LocalArticleBloc(
    this._getSavedArticlesUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
  ) : super(LocalArticleLoading()) {
    // Listen for events and handle them
    on<SubscribeToSavedArticles>(_onSubscribeToSavedArticles);
    on<UpdateSavedArticles>(_onUpdateSavedArticles);
    on<SaveArticle>(_onSaveArticle);
    on<RemoveArticle>(_onRemoveArticle);

    // Automatically subscribe to changes in saved articles
    add(SubscribeToSavedArticles());
  }

  // Subscribe to saved articles stream
  void _onSubscribeToSavedArticles(
      SubscribeToSavedArticles event, Emitter<LocalArticleState> emit) {
    _articleSubscription?.cancel(); // Cancel any existing subscription

    _articleSubscription = _getSavedArticlesUseCase.watchArticles().listen(
      (articles) {
        add(UpdateSavedArticles(articles: articles));
      },
      onError: (error) {
        emit(LocalArticleError(error.toString()));
      },
    );
  }

  // Update state when new articles are received
  void _onUpdateSavedArticles(
      UpdateSavedArticles event, Emitter<LocalArticleState> emit) {
    emit(LocalArticleDone(event.articles));
  }

  // Save an article and refresh the state
  void _onSaveArticle(
      SaveArticle event, Emitter<LocalArticleState> emit) async {
    try {
      final state = this.state;

      // Prevent saving if the article is already in the list
      if (state is LocalArticleDone &&
          state.articles.any((saved) => saved.title == event.article.title)) {
        return; // Article is already saved, no action needed
      }

      await _saveArticleUseCase(params: event.article);
      add(SubscribeToSavedArticles()); // Trigger subscription update
    } catch (error) {
      emit(LocalArticleError(error.toString()));
    }
  }

  // Remove an article and refresh the state
  void _onRemoveArticle(
      RemoveArticle event, Emitter<LocalArticleState> emit) async {
    try {
      await _removeArticleUseCase(params: event.article);
    } catch (error) {
      emit(LocalArticleError(error.toString()));
    }
  }

  // Dispose of the subscription when the bloc is closed
  @override
  Future<void> close() {
    _articleSubscription?.cancel();
    return super.close();
  }
}
