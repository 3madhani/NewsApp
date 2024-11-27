import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/presentation/bloc/article/remote/remote_article_bloc.dart';
import 'package:news_app/features/daily_news/presentation/pages/splash/splash_view.dart';

import 'config/theme/app_theme.dart';
import 'features/daily_news/presentation/bloc/article/remote/remote_article_event.dart';
import 'injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteArticleBloc>(
      create: (context) => sl()
        ..add(const GetRemoteArticleEvent(
          country: 'us',
        )),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashView(),
        theme: appTheme(),
      ),
    );
  }
}
