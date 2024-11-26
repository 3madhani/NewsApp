import 'dart:async';

import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:news_app/features/daily_news/data/data_sources/local/app_database.dart';
import 'package:news_app/features/daily_news/data/data_sources/remote/api_service.dart';
import 'package:news_app/features/daily_news/data/models/article.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/repository/article_repo.dart';

class ArticleRepoImpl implements ArticleRepository {
  final ApiService _apiService;
  final AppDatabase _appDatabase;

  // StreamController to manage real-time updates
  final StreamController<List<ArticleEntity>> _articleStreamController =
      StreamController<List<ArticleEntity>>.broadcast();

  ArticleRepoImpl(this._apiService, this._appDatabase);

  @override
  Future<Either<Failure, List<ArticleEntity>>> getNewsArticles({
    String? country,
  }) async {
    try {
      final httpResponse = await _apiService.get(
        endPoint: 'top-headlines',
        queryParams: {
          'country': country!, // Default to 'us' if no country is provided
        },
      );

      final articles = (httpResponse['articles'] as List)
          .map((json) => ArticleModel.fromJson(json))
          .toList();

      return Right(articles);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }

  // Future<DataState<List<ArticleModel>>> getNewsArticles({
  //   String? country,
  // }) async {
  //   try {
  //     final httpResponse = await _newsApiServices.getNewsArticles(
  //       apiKey: apiKey,
  //       country: country,
  //       category: category,
  //     );

  //     if (httpResponse.response.statusCode == HttpStatus.ok) {
  //       return DataSuccess(httpResponse.data);
  //     } else {
  //       return DataFailed(
  //         DioException(
  //           error: httpResponse.response.statusMessage,
  //           response: httpResponse.response,
  //           type: DioExceptionType.badResponse,
  //           requestOptions: httpResponse.response.requestOptions,
  //         ),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     return DataFailed(e);
  //   }
  // }

  @override
  Future<void> deleteArticle(ArticleEntity article) async {
    await _appDatabase.articleDAO
        .deleteArticle(ArticleModel.fromEntity(article));
    _emitUpdatedArticles();
  }

  @override
  Future<List<ArticleEntity>> getSavedArticles() {
    return _appDatabase.articleDAO.getAllArticles();
  }

  @override
  Future<void> saveArticle(ArticleEntity article) async {
    await _appDatabase.articleDAO
        .insertArticle(ArticleModel.fromEntity(article));
    _emitUpdatedArticles();
  }

  @override
  Stream<List<ArticleEntity>> watchSavedArticles() {
    _emitUpdatedArticles(); // Emit initial data
    return _articleStreamController.stream;
  }

  // Emit the latest saved articles
  void _emitUpdatedArticles() async {
    final articles = await getSavedArticles();
    _articleStreamController.add(articles);
  }

  // Dispose the StreamController when no longer needed
  void dispose() {
    _articleStreamController.close();
  }
}
