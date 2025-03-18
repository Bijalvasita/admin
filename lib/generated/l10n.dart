
// lib/generated/l10n.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class L10n {
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('ar', ''), // Arabic
  ];

  static String get greeting {
    return Intl.message(
      'Hello',
      name: 'greeting',
      desc: 'Greeting message',
      locale: Intl.getCurrentLocale(),
    );
  }

  static String get welcome {
    return Intl.message(
      'Welcome to our application!',
      name: 'welcome',
      desc: 'Welcome message',
      locale: Intl.getCurrentLocale(),
    );
  }

  static String get goodbye {
    return Intl.message(
      'Goodbye',
      name: 'goodbye',
      desc: 'Goodbye message',
      locale: Intl.getCurrentLocale(),
    );
  }

  // Add more localized strings as needed
}
