part of 'local_article_bloc.dart';

abstract class LocalArticleState extends Equatable {
  const LocalArticleState();

  @override
  List<Object?> get props => [];
}

class LocalArticleLoading extends LocalArticleState {}

class LocalArticleDone extends LocalArticleState {
  final List<ArticleEntity> articles;

  const LocalArticleDone(this.articles);

  @override
  List<Object?> get props => [articles];
}

class LocalArticleError extends LocalArticleState {
  final String message;

  const LocalArticleError(this.message);

  @override
  List<Object?> get props => [message];
}
