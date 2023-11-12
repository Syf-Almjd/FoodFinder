import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:foodfinder/src/config/themes/theme_manager.dart';
import 'package:foodfinder/src/presentation/Cubits/theme_bloc/theme_event.dart';

part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState.lightTheme) {
    on<ThemeEventChange>((event, emit) {
      switch (event.currentTheme) {
        case ThemeEventType.toggleDark:
          emit(ThemeState.darkTheme);
          break;
        case ThemeEventType.toggleLight:
          emit(ThemeState.lightTheme);
          break;
      }
    });
  }
}
