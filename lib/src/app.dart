import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodfinder/src/config/utils/managers/app_constants.dart';
import 'package:foodfinder/src/data/local/localData_cubit/local_data_cubit.dart';
import 'package:foodfinder/src/domain/NaviController.dart';
import 'package:foodfinder/src/presentation/Cubits/theme_bloc/theme_bloc.dart';
import 'package:foodfinder/src/presentation/Modules/Home/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocalDataCubit(),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return AdaptiveTheme(
            light: ThemeState.lightTheme.themeData,
            dark: ThemeState.darkTheme.themeData,
            debugShowFloatingThemeButton: false,
            initial: AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppConstants.appTitle,
              theme: state.themeData,
              home: getHomePlatform(),
            ),
          );
        },
      ),
    );
  }

  getHomePlatform() {
    if (kIsWeb) {
      return const Scaffold(body: HomePage(isWeb: true));
    } else {
      return const NavigationController();
    }
  }
}
