// import 'package:dio/dio.dart';
// import 'package:news_app/core/constants/constants.dart';
// import 'package:retrofit/retrofit.dart';
// import '../../models/article.dart';
// part 'news_api_services.g.dart';

// @RestApi(baseUrl: newsApiBaseUrl)
// abstract class NewsApiServices {
//   factory NewsApiServices(Dio dio) = _NewsApiServices;

//   @GET('/top-headlines')
//   Future<HttpResponse<List<ArticleModel>>> getNewsArticles({
//     @Query('apiKey') String? apiKey,
//     @Query('country') String? country,
//     @Query('category') String? category,
//   });
// }
