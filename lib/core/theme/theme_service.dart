import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  bool isDarkModeOn = false;

  void toggleTheme() {
    isDarkModeOn = !isDarkModeOn;
    notifyListeners();
  }
}

class GinaAppTheme {
  GinaAppTheme._();

  // *****************
  // light colors
  // *****************

  static const Color lightPrimaryColor = Color(0xffFFC0CB);
  static const Color lightOnPrimaryColor = Color(0xff36344E);
  static const Color lightPrimaryContainer = Color(0xFFFFE6DC);
  static const Color lightOnPrimaryContainer = Color(0xFF251A00);
  static const Color lightSecondary = Color(0xffED708E);
  static const Color lightOnSecondary = Color(0xff36344E);
  static const Color lightSecondaryContainer = Color(0xffFFC0CB);
  static const Color lightOnSecondaryContainer = Color(0xff36344E);
  static const Color lightTertiary = Color(0xffEF968B);
  static const Color lightOnTertiary = Color(0xFFFFFFFF);
  static const Color lightTertiaryContainer = Color(0xfFFB6C85);
  static const Color lightOnTertiaryContainer = Color(0xFFFFFFFF);
  static const Color lightError = Color(0xFFBA1A1A);
  static const Color lightErrorContainer = Color(0xFFFFDAD6);
  static const Color lightOnError = Color(0xFFFFFFFF);
  static const Color lightOnErrorContainer = Color(0xFF410002);
  static const Color lightBackground = Color(0xffF3F3F3);
  static const Color lightOnBackground = Color.fromARGB(255, 64, 62, 85);
  static const Color lightSurface = Color(0xffE6E6FA);
  static const Color lightOnSurface = Color(0xFF251A00);
  static const Color lightSurfaceVariant = Color(0xFFE6E6E6);
  static const Color lightOnSurfaceVariant = Color(0xFF4D4639);
  static const Color lightOutline = Color(0xFF989898);
  static const Color lightOnInverseSurface = Color(0xffFFC0CB);
  static const Color lightInverseSurface = Color(0xff36344E);
  static const Color lightInversePrimary = Color(0xFFF0C048);
  static const Color lightShadow = Color(0xFF000000);
  static const Color lightSurfaceTint = Color(0xffEF968B);
  static const Color lightOutlineVariant = Color(0xFF9493A0);
  static const Color lightScrim = Color(0xFF000000);
  static const Color appbarColorLight = Color(0xFFFFFFFF);
  static const Color lightOnSelectedColorNavBar = Color(0xffEF968B);
  static const Color tabBarTextColor = Color(0xB4b4b4b4);
  static const Color pendingTextColor = Color(0xFFFF9839);
  static const Color approvedTextColor = Color(0xFF33D176);
  static const Color declinedTextColor = Color(0xFFD14633);
  static const Color cancelledTextColor = Color(0xFF989898);
  static const Color searchBarColor = Color(0xffF1F1F1);
// ------------------------------------------------------------------------------

  // *****************
  // Text Style - light
  // *****************
  static const TextStyle _displayLargeText = TextStyle(
    fontFamily: "SF UI Display",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _displayMediumText = TextStyle(
      color: lightOnBackground,
      fontFamily: "SF UI Display",
      fontWeight: FontWeight.bold);

  static const TextStyle _displaySmallText = TextStyle(
      color: lightOnBackground,
      fontFamily: "SF UI Display",
      fontWeight: FontWeight.bold);

  static const TextStyle _headlineLargeText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _headlineMediumText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _headlineSmallText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _bodyLargeText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _bodyMediumText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _bodySmallText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _titleLargeText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle _titleMediumText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _titleSmallText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _labelLargeText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _labelMediumText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextStyle _labelSmallText = TextStyle(
    color: lightOnBackground,
    fontFamily: "SF UI Display",
  );

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: _displayLargeText,
    displayMedium: _displayMediumText,
    displaySmall: _displaySmallText,
    headlineLarge: _headlineLargeText,
    headlineMedium: _headlineMediumText,
    headlineSmall: _headlineSmallText,
    titleLarge: _titleLargeText,
    titleMedium: _titleMediumText,
    titleSmall: _titleSmallText,
    labelLarge: _labelLargeText,
    labelMedium: _labelMediumText,
    labelSmall: _labelSmallText,
    bodyLarge: _bodyLargeText,
    bodyMedium: _bodyMediumText,
    bodySmall: _bodySmallText,
  );

  // ------------------------------------------------------------------------------

  //App Bar Theme

  static const AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: appbarColorLight,
    foregroundColor: lightOnPrimaryColor,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'SF UI Display',
      fontWeight: FontWeight.w600,
      fontSize: 20,
      color: lightOnPrimaryColor,
    ),
  );

  // ------------------------------------------------------------------------------

  //Navigation Bar Theme

  static final NavigationBarThemeData _navigationBarTheme =
      NavigationBarThemeData(
    backgroundColor: appbarColorLight,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    indicatorColor: Colors.transparent,
    indicatorShape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(100)),
    ),
    height: 90,
    elevation: 0,
    shadowColor: Colors.transparent,
    labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          // Style for selected state
          return const TextStyle(
            fontFamily: 'SF UI Display',
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: lightTertiaryContainer,
          );
        } else {
          // Style for unselected state
          return const TextStyle(
            fontFamily: 'SF UI Display',
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: lightOutline,
          );
        }
      },
    ),
  );

  // ------------------------------------------------------------------------------

  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 1.50,
        color: lightOutline,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    labelStyle: const TextStyle(
      fontSize: 14,
      fontFamily: 'SF UI Display',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      color: lightOutlineVariant,
    ),
  );
  // ------------------------------------------------------------------------------

  // *****************
  // Theme light
  // *****************

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'SF UI Display',
    useMaterial3: true,
    scaffoldBackgroundColor: lightBackground,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: lightTertiaryContainer,
      onPrimary: lightOnError,
      primaryContainer: lightPrimaryContainer,
      onPrimaryContainer: lightOnPrimaryContainer,
      secondary: lightSecondary,
      onSecondary: lightOnSecondary,
      secondaryContainer: lightSecondaryContainer,
      onSecondaryContainer: lightOnSecondaryContainer,
      tertiary: lightTertiary,
      onTertiary: lightOnTertiary,
      tertiaryContainer: lightTertiaryContainer,
      onTertiaryContainer: lightOnTertiaryContainer,
      error: lightError,
      errorContainer: lightErrorContainer,
      onError: lightOnError,
      onErrorContainer: lightOnErrorContainer,
      surface: lightSurface,
      onSurface: lightOnSurface,
      surfaceVariant: lightSurfaceVariant,
      onSurfaceVariant: lightOnSurfaceVariant,
      outline: lightOutline,
      onInverseSurface: lightOnInverseSurface,
      inverseSurface: lightInverseSurface,
      inversePrimary: lightInversePrimary,
      shadow: lightShadow,
      surfaceTint: lightSurfaceTint,
      outlineVariant: lightOutlineVariant,
      scrim: lightScrim,
    ),
    textTheme: _lightTextTheme,
    appBarTheme: _appBarTheme,
    navigationBarTheme: _navigationBarTheme,
    inputDecorationTheme: _inputDecorationTheme,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      shape: CircleBorder(),
      backgroundColor: lightSecondary,
      foregroundColor: lightOnTertiary,
    ),
    datePickerTheme: DatePickerThemeData(
      todayBorder: const BorderSide(
        color: lightSecondary,
        width: .5,
      ),
      backgroundColor: lightSurface,
      // TODO:  CHANGED THIS
      confirmButtonStyle: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(lightPrimaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(lightOnPrimaryColor),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(lightOnPrimaryColor),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: appbarColorLight,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      elevation: 2,
    ),
  );
}
