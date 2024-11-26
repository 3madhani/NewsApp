import 'package:news_app/features/daily_news/domain/entities/article.dart';
import '../repository/article_repo.dart';

class GetSavedArticleUseCase {
  final ArticleRepository _articleRepository;

  GetSavedArticleUseCase(this._articleRepository);

  // Expose a Stream for real-time updates
  Stream<List<ArticleEntity>> watchArticles() {
    return _articleRepository.watchSavedArticles();
  }
}
