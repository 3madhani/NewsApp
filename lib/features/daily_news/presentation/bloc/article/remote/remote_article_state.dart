import 'package:equatable/equatable.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';

abstract class RemoteArticleState extends Equatable {
  const RemoteArticleState();

  @override
  List<Object?> get props => [];
}

class RemoteArticleInitial extends RemoteArticleState {
  const RemoteArticleInitial();
}

class RemoteArticleLoading extends RemoteArticleState {
  const RemoteArticleLoading();
}

class RemoteArticleDone extends RemoteArticleState {
  final List<ArticleEntity> articles;

  const RemoteArticleDone({required this.articles});
}

class RemoteArticleError extends RemoteArticleState {
  final String? message;

  const RemoteArticleError({this.message});
}
