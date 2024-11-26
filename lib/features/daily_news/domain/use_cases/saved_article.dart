import 'package:news_app/core/use_cases/use_case.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import '../repository/article_repo.dart';

class SaveArticleUseCase implements UseCase<void, ArticleEntity> {
  final ArticleRepository _articleRepository;

  SaveArticleUseCase(this._articleRepository);

  @override
  Future<void> call({ArticleEntity? params}) async {
    if (params == null) {
      throw ArgumentError('Article cannot be null');
    }
    try {
      await _articleRepository.saveArticle(params);
    } catch (e) {
      throw Exception('Failed to save article: $e');
    }
  }
}
