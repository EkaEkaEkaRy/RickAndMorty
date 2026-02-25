import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,

  /// основной цвет приложения (кнопки, иконки, индикаторы)
  primary: Color.fromARGB(255, 7, 216, 52),
  onPrimary: Colors.black,
  primaryContainer: Colors.white,
  onPrimaryContainer: Colors.black,

  /// второстепенный цвет
  secondary: Colors.black,
  onSecondary: Colors.white,
  secondaryContainer: Colors.black,
  onSecondaryContainer: Colors.white,

  /// Серый цвет и оттенки
  tertiary: Colors.grey,
  tertiaryContainer: Colors.white,
  onTertiaryContainer: Colors.black,

  /// ошибки
  error: Colors.red,
  onError: Colors.white,
  errorContainer: Colors.white,
  onErrorContainer: Colors.black,

  /// цвет фона / поверхности
  surface: Colors.white,
  onSurface: Colors.black,
  onSurfaceVariant: Colors.grey,
  surfaceContainer: Colors.white,
  surfaceContainerHighest: Colors.white,
);

final ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,

  /// основной цвет приложения (кнопки, иконки, индикаторы)
  primary: Color.fromARGB(255, 7, 216, 52),
  onPrimary: Colors.black,
  primaryContainer: Colors.black,
  onPrimaryContainer: Colors.white,

  /// второстепенный цвет
  secondary: Colors.white,
  onSecondary: Colors.black,
  secondaryContainer: Colors.white,
  onSecondaryContainer: Colors.black,

  /// Серый цвет и оттенки
  tertiary: Colors.grey,
  tertiaryContainer: Colors.black,
  onTertiaryContainer: Colors.white,

  /// ошибки
  error: Colors.pink,
  onError: Colors.black,
  errorContainer: Colors.black,
  onErrorContainer: Colors.white,

  /// цвет фона / поверхности
  surface: Colors.black,
  onSurface: Colors.white,
  onSurfaceVariant: Colors.grey,
  surfaceContainer: Colors.black,
  surfaceContainerHighest: Colors.black,
);
