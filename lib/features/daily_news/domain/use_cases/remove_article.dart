import 'package:news_app/core/use_cases/use_case.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import '../repository/article_repo.dart';

class RemoveArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _articleRepository;

  RemoveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({ArticleEntity? params}) async {
    if (params == null) {
      throw ArgumentError('Article cannot be null');
    }
    try {
      await _articleRepository.deleteArticle(params);
    } catch (e) {
      throw Exception('Failed to remove article: $e');
    }
  }
}
