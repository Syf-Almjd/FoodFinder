part of 'theme_bloc.dart';

@immutable
class ThemeState {
  final ThemeData themeData;

  const ThemeState(this.themeData);

  static ThemeState get darkTheme => ThemeState(getDarkApplicationTheme());

  static ThemeState get lightTheme => ThemeState(getApplicationTheme());
}
