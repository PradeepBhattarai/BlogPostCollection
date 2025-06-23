import 'package:blogpost_colln/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AppTheme{
  static _border([Color color=AppPallete.borderColor])=>OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: color,
          width: 3.0,
          
        )
  );

  static final darkThemeMode=ThemeData.dark().copyWith(
    appBarTheme: const  AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,

    ),
    chipTheme: ChipThemeData(
      color:WidgetStateProperty.all(AppPallete.backgroundColor),
      side: BorderSide.none,

    ),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme:InputDecorationTheme(
      contentPadding: const EdgeInsets.all(16.0),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
      errorBorder: _border(AppPallete.errorColor),
    )
  );
  static final lightThemeMode=ThemeData.light();


}

