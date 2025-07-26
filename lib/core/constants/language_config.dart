import 'package:flutter/material.dart';

class LanguageConfig {
  static const Map<String, LanguageInfo> supportedLanguages = {
    'en': LanguageInfo(
      code: 'en',
      name: 'English',
      flag: '🇦🇺', // Australia flag
      locale: Locale('en'),
    ),
    'es': LanguageInfo(
      code: 'es',
      name: 'Español',
      flag: '🇨🇴', // Colombia flag
      locale: Locale('es'),
    ),
    'ja': LanguageInfo(
      code: 'ja',
      name: '日本語',
      flag: '🇯🇵', // Japan flag
      locale: Locale('ja'),
    ),
  };

  static const List<String> supportedLanguageCodes = ['en', 'es', 'ja'];

  static LanguageInfo getLanguageInfo(String languageCode) {
    return supportedLanguages[languageCode] ?? supportedLanguages['en']!;
  }

  static List<LanguageInfo> getAllLanguages() {
    return supportedLanguages.values.toList();
  }
}

class LanguageInfo {
  final String code;
  final String name;
  final String flag;
  final Locale locale;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.flag,
    required this.locale,
  });
}
