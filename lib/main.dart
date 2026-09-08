import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_ideas/core/theme/app_theme.dart';
import 'package:startup_ideas/features/home/data/repositories/idea_repository_impl.dart';
import 'package:startup_ideas/features/home/data/sources/idea_local_datasource.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_bloc.dart';
import 'package:startup_ideas/features/home/presentation/bloc/bloc/idea_event.dart';
import 'package:startup_ideas/features/home/presentation/cubit/theme_cubit.dart';
import 'package:startup_ideas/features/home/presentation/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final dataSource = IdeaLocalDataSourceImpl(prefs: prefs);
  final repository = IdeaRepositoryImpl(localDataSource: dataSource);

  runApp(StartupIdeaApp(repository: repository, prefs: prefs));
}

class StartupIdeaApp extends StatelessWidget {
  final IdeaRepositoryImpl repository;
  final SharedPreferences prefs;
  const StartupIdeaApp({
    super.key,
    required this.repository,
    required this.prefs,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              IdeaBloc(repository: repository)..add(LoadIdeasEvent()),
        ),
        BlocProvider(create: (context) => ThemeCubit(prefs: prefs)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'The Startup Idea Evaluator By Yogesh',
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
