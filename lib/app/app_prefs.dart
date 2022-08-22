import 'package:shared_preferences/shared_preferences.dart';

import '../presentations/resources/language_manager.dart';

const String PREFS_KEY_LANGUAGE = 'PREFS_KEY_LANGUAGE';

const String PREFS_KEY_ONBOARDING_SCREEN_VIEWED =
    'PREFS_KEY_ONBOARDING_SCREEN_VIEWED';

const String PREFS_KEY_IS_USER_LOGGED_IN = 'PREFS_KEY_IS_USER_LOGGED_IN';

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(PREFS_KEY_LANGUAGE);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      /// return default language
      return LanguageType.ENGLISH.getValue();
    }
  }

  /// on boarding
  Future<void> setOnBoardingScreen() async {
    await _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, true);
  }

  Future<bool> isOnBoardingScreen() async {
    return _sharedPreferences.getBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED) ??
        false;
  }

  /// login screen
  Future<void> setUserLoggedIn() async {
    await _sharedPreferences.setBool(PREFS_KEY_IS_USER_LOGGED_IN, true);
  }

  Future<bool> isUserLoggedIn() async {
    return _sharedPreferences.getBool(PREFS_KEY_IS_USER_LOGGED_IN) ?? false;
  }

  Future<void> logout() async {
    _sharedPreferences.remove(PREFS_KEY_IS_USER_LOGGED_IN);

    /// await _sharedPreferences.setBool(PREFS_KEY_ONBOARDING_SCREEN_VIEWED, false);
  }
}
