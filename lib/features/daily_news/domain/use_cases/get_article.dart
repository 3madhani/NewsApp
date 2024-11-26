import 'package:either_dart/either.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/core/use_cases/use_case.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import '../repository/article_repo.dart';

class GetArticleUseCase implements UseCase<Either<Failure, List<ArticleEntity>>, String?> {
  final ArticleRepository _articleRepository;

  GetArticleUseCase(this._articleRepository);

  @override
  Future<Either<Failure, List<ArticleEntity>>> call({String? params}) {
    return _articleRepository.getNewsArticles(country: params);
  }
}

