import 'package:ap_common_flutter_ui/src/resources/ap_colors.dart';
import 'package:ap_common_flutter_ui/src/resources/resources.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/material.dart';

export 'package:cupertino_back_gesture/cupertino_back_gesture.dart';

class ApTheme extends InheritedWidget {
  ApTheme(
    this.themeMode, {
    required Widget child,
    BackGestureWidth? backGestureWidth,
  }) : super(
          child: BackGestureWidthTheme(
            backGestureWidth:
                backGestureWidth as double Function(Size Function())? ??
                    BackGestureWidth.fraction(1 / 2),
            child: child,
          ),
        );

  final ThemeMode themeMode;

  static ApTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType()!;
  }

  @override
  bool updateShouldNotify(ApTheme oldWidget) {
    return true;
  }

  // ignore: constant_identifier_names
  static const String DARK = 'dark';

  // ignore: constant_identifier_names
  static const String LIGHT = 'light';

  // ignore: constant_identifier_names
  static const String SYSTEM = 'system';

  static String code = ApTheme.LIGHT;

  Brightness get brightness {
    switch (themeMode) {
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
    }
  }

  Color get blue {
    switch (brightness) {
      case Brightness.light:
        return ApColors.blue500;
      case Brightness.dark:
        return ApColors.blueDark;
    }
  }

  Color get blueText {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.grey100;
      case Brightness.light:
        return ApColors.blue500;
    }
  }

  Color get blueAccent {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.blue300;
      case Brightness.light:
        return ApColors.blue500;
    }
  }

  Color get semesterText {
    switch (brightness) {
      case Brightness.dark:
        return const Color(0xffffffff);
      case Brightness.light:
        return ApColors.blue500;
    }
  }

  Color get grey {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.grey200;
      case Brightness.light:
        return ApColors.grey500;
    }
  }

  Color get greyText {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.grey200;
      case Brightness.light:
        return ApColors.grey500;
    }
  }

  Color get disabled {
    switch (brightness) {
      case Brightness.dark:
        return const Color(0xFF424242);
      case Brightness.light:
        return const Color(0xFFBDBDBD);
    }
  }

  Color get calendarTileSelect {
    switch (brightness) {
      case Brightness.dark:
        return const Color(0xff000000);
      case Brightness.light:
        return const Color(0xffffffff);
    }
  }

  Color get yellow {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.yellow200;
      case Brightness.light:
        return ApColors.yellow500;
    }
  }

  Color get red {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.red200;
      case Brightness.light:
        return ApColors.red500;
    }
  }

  Color get green {
    switch (brightness) {
      case Brightness.light:
        return Colors.green;
      case Brightness.dark:
        return Colors.green[300]!;
    }
  }

  Color get bottomNavigationSelect {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.grey100;
      case Brightness.light:
        return const Color(0xff737373);
    }
  }

  Color get segmentControlUnSelect {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.onyx;
      case Brightness.light:
        return const Color(0xffffffff);
    }
  }

  Color get snackBarActionTextColor {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.yellow500;
      case Brightness.light:
        return ApColors.yellow500;
    }
  }

  Color get toastBackground {
    switch (brightness) {
      case Brightness.light:
        return const Color(0xAA000000);
      case Brightness.dark:
        return const Color(0xAAFFFFFF);
    }
  }

  Color get toastText {
    switch (brightness) {
      case Brightness.light:
        return Colors.white;
      case Brightness.dark:
        return Colors.black;
    }
  }

  double get drawerIconOpacity {
    switch (brightness) {
      case Brightness.dark:
        return 0.75;
      case Brightness.light:
        return 1.0;
    }
  }

  String get dashLine {
    switch (brightness) {
      case Brightness.light:
        return ApImageAssets.dashLineLight;
      case Brightness.dark:
        return ApImageAssets.dashLineDark;
    }
  }

  String get drawerBackground {
    switch (brightness) {
      case Brightness.light:
        return ApImageAssets.drawerBackgroundLight;
      case Brightness.dark:
        return ApImageAssets.drawerBackgroundDark;
    }
  }

  Color get courseBorder {
    switch (brightness) {
      case Brightness.dark:
        return ApColors.charade;
      case Brightness.light:
        return ApColors.solitude;
    }
  }

  Color get courseText {
    switch (brightness) {
      case Brightness.dark:
        return Colors.black87;
      case Brightness.light:
        return Colors.white;
    }
  }

  Color get courseListTabletBackground {
    switch (brightness) {
      case Brightness.dark:
        return Colors.black12;
      case Brightness.light:
        return Colors.white;
    }
  }

  Color get barCode {
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  Color get background {
    switch (brightness) {
      case Brightness.dark:
        return const Color(0xff121212);
      case Brightness.light:
        return Colors.white;
    }
  }

  static ThemeData get light => ThemeData(
        //platform: TargetPlatform.iOS,
        useMaterial3: true,
        brightness: Brightness.light,
        // appBarTheme: const AppBarTheme(
        //   color: ApColors.blue500,
        // ),
        indicatorColor: ApColors.blue500,
        pageTransitionsTheme: _pageTransitionsTheme,
        unselectedWidgetColor: ApColors.grey500,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: ApColors.blue200,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ApColors.primary,
        ),
      );

  static ThemeData get dark => ThemeData(
        //platform: TargetPlatform.iOS,
        useMaterial3: true,
        brightness: Brightness.dark,
        pageTransitionsTheme: _pageTransitionsTheme,
        // appBarTheme: const AppBarTheme(
        //   color: ApColors.blueDark,
        // ),
        indicatorColor: ApColors.blue300,
        scaffoldBackgroundColor: ApColors.onyx,
        unselectedWidgetColor: ApColors.grey200,
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: ApColors.blue300,
        ),
      );
}

const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
  builders: <TargetPlatform, PageTransitionsBuilder>{
    TargetPlatform.android:
        CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.iOS: CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.macOS:
        CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.windows:
        CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.linux:
        CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
    TargetPlatform.fuchsia:
        CupertinoPageTransitionsBuilderCustomBackGestureWidth(),
  },
);
