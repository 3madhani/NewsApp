import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/features/daily_news/domain/repository/article_repo.dart';
import 'package:news_app/features/daily_news/domain/use_cases/gat_saved_article.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';

import 'features/daily_news/data/data_sources/local/app_database.dart';
import 'features/daily_news/data/data_sources/remote/api_service.dart';
import 'features/daily_news/data/repository/article_repo_impl.dart';
import 'features/daily_news/domain/use_cases/get_article.dart';
import 'features/daily_news/domain/use_cases/remove_article.dart';
import 'features/daily_news/domain/use_cases/saved_article.dart';
import 'features/daily_news/presentation/bloc/article/local/bloc/local_article_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  sl.registerSingleton<AppDatabase>(database);

  // Register Dio instance
  sl.registerSingleton<Dio>(Dio());

  // Register ApiService
  sl.registerSingleton<ApiService>(
    ApiService(
      sl<Dio>(), // Use the Dio instance registered above
    ),
  );

  // Register ArticleRepository
  sl.registerSingleton<ArticleRepository>(
    ArticleRepoImpl(
      sl<ApiService>(),
      sl<AppDatabase>(),
    ),
  );

  // Use cases
  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));
  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));
  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));

  // Bloc
  sl.registerFactory<RemoteArticleBloc>(() => RemoteArticleBloc(sl()));
  sl.registerFactory<LocalArticleBloc>(() => LocalArticleBloc(
        sl(),
        sl(),
        sl(),
      ));
}
