import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_navigation_drawer/screens/dashboard_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; // Ensure you have this file for your Firebase options
import 'generated/intl/l10n.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart'; // Ensure this is correct

void main() async {
  // Ensure widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    // Handle Firebase initialization error
    print('Firebase initialization error: $e');
  }

  runApp(
    ChangeNotifierProvider<LanguageProvider>(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(360, 690), // Adjust design size as needed
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: provider.locale, // Set the locale from the provider
          supportedLocales: const [
            Locale('en', ''), // English locale
            Locale('hi', ''), // Hindi locale
            // Add more supported locales as needed
          ],
          localizationsDelegates: const [
            S.delegate, // Ensure this matches your generated localization class
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue, // Use your theme
            // You can customize other theme properties here
          ),
          home: DashboardScreen(), // Ensure SplashScreen is defined correctly
        );
      },
    );
  }
}
