part of 'local_article_bloc.dart';

abstract class LocalArticleEvent extends Equatable {
  const LocalArticleEvent();

  @override
  List<Object?> get props => [];
}

class SubscribeToSavedArticles extends LocalArticleEvent {}

class UpdateSavedArticles extends LocalArticleEvent {
  final List<ArticleEntity> articles;

  const UpdateSavedArticles({required this.articles});

  @override
  List<Object?> get props => [articles];
}

class SaveArticle extends LocalArticleEvent {
  final ArticleEntity article;

  const SaveArticle(this.article);

  @override
  List<Object?> get props => [article];
}

class RemoveArticle extends LocalArticleEvent {
  final ArticleEntity article;

  const RemoveArticle(this.article);

  @override
  List<Object?> get props => [article];
}
