import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // زبان پیش‌فرض
  bool _isLanguageSelected = false; // آیا کاربر قبلا زبان را انتخاب کرده؟

  Locale get locale => _locale;
  bool get isLanguageSelected => _isLanguageSelected;

  // بارگذاری زبان ذخیره شده هنگام شروع برنامه
  Future<void> fetchLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString('language_code');

    if (languageCode != null) {
      _locale = Locale(languageCode);
      _isLanguageSelected = true;
    } else {
      _isLanguageSelected = false;
    }
    notifyListeners();
  }

  // تغییر زبان و ذخیره در حافظه
  Future<void> setLocale(Locale locale) async {
    if (!['en', 'fa', 'zh', 'ru', 'tr'].contains(locale.languageCode)) return;

    _locale = locale;
    _isLanguageSelected = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    notifyListeners();
  }
}
