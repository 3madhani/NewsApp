import 'package:floor/floor.dart';
import 'package:news_app/features/daily_news/data/models/article.dart';

@dao
abstract class ArticleDao {
  // Insert a single article
  @Insert(onConflict: OnConflictStrategy.replace) // Replace on conflict
  Future<void> insertArticle(ArticleModel article);

  // Delete a single article
  @delete
  Future<void> deleteArticle(ArticleModel article);

  // Fetch all articles
  @Query('SELECT * FROM article') // Match table name in ArticleModel
  Future<List<ArticleModel>> getAllArticles();

  // Insert multiple articles (Batch Insert)
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertArticles(List<ArticleModel> articles);

  // Delete all articles (Optional utility)
  @Query('DELETE FROM article')
  Future<void> deleteAllArticles();
}
