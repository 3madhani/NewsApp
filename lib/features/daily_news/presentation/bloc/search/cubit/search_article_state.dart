part of 'search_article_cubit.dart';

sealed class SearchArticleState extends Equatable {
  const SearchArticleState();

  @override
  List<Object> get props => [];
}

final class SearchArticleInitial extends SearchArticleState {}

final class SearchArticleLoading extends SearchArticleState {}

final class SearchArticleError extends SearchArticleState {
  final String errMessage;

  const SearchArticleError({required this.errMessage});
}

final class SearchArticleSuccess extends SearchArticleState {
  final List<ArticleEntity> articles;

  const SearchArticleSuccess({required this.articles});
}
