// import 'package:dio/dio.dart';
// import 'package:get_it/get_it.dart';
// import 'package:news_app/features/daily_news/data/repository/article_repo_impl.dart';
// import 'package:news_app/features/daily_news/domain/repository/article_repo.dart';
// import '../../features/daily_news/data/data_sources/remote/api_service.dart';

// final getIt = GetIt.instance;

// void setupServiceLocator() {
//   getIt.registerSingleton<ApiService>(
//     ApiService(
//       Dio(),
//     ),
//   );
//   getIt.registerSingleton<ArticleRepository>(
//     ArticleRepoImpl(
//       getIt.get<ApiService>(), 
//     ),
//   );
// }
