import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    fontFamily: 'Noto',
    primaryColor: const Color(0xff264980),
    secondaryHeaderColor: const Color(0xffD6E6F2),
    appBarTheme: AppBarTheme(color: Color(0xfff2f8fd),titleTextStyle: const TextStyle(color: Color(0xff5F6979)), surfaceTintColor: const Color(0xfff2f8fd)),
    disabledColor: const Color(0xff8b8b8b),
    scaffoldBackgroundColor : const Color(0xffF9FBFD),
    hintColor: Colors.grey.shade600,
    canvasColor: Colors.transparent,
    colorScheme: const ColorScheme.light(primary: Color(0xff852165)),
    // textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.black)),
    shadowColor: const Color(0xfff5f5f5),
    dividerColor: const Color(0xffdbe1ea) //Color(0xffd8bfd8)
  // colorScheme: ColorScheme.fromSwatch()
  //     .copyWith(secondary: kBaseAccentColor),

);

