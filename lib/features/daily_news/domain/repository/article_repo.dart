import 'package:either_dart/either.dart';
import 'package:news_app/core/errors/failure.dart';

import '../entities/article.dart';

abstract class ArticleRepository {
  Future<Either<Failure, List<ArticleEntity>>> getNewsArticles({String? country});
  // Database methods
  Future<List<ArticleEntity>> getSavedArticles();
  Future<void> saveArticle(ArticleEntity article);
  Future<void> deleteArticle(ArticleEntity article);

  // New method to provide a stream for saved articles
  Stream<List<ArticleEntity>> watchSavedArticles();
}
