import 'package:either_dart/either.dart';
import 'package:news_app/core/errors/failure.dart';
import 'package:news_app/core/use_cases/use_case.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import '../repository/article_repo.dart';

class GetQueryArticleUseCase implements UseCase<Either<Failure, List<ArticleEntity>>, String> {
  final ArticleRepository _articleRepository;

  GetQueryArticleUseCase(this._articleRepository);

 @override
Future<Either<Failure, List<ArticleEntity>>> call({String? params}) async {
  if (params == null || params.isEmpty) {
    return Left(ServerFailure(errMessage: "Query cannot be null or empty"));
  }
  return _articleRepository.getQueryArticles(query: params);
}

}
