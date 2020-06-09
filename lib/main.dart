import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:qabus/pages/splash.dart';
import 'package:qabus/services/account_service.dart';
import 'package:qabus/services/language_service.dart';
import 'package:qabus/services/localization.dart';

void main() async {
  runApp(DefaultApp());
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  runApp(MyApp(
    appLanguage: appLanguage,
  ));
}

class DefaultApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(),
    );
  }
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguage>(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage>(builder: (context, model, child) {

        return Provider<AccountService>(
          create: (BuildContext context) => AccountService(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: appLanguage.appLocal,
            supportedLocales: [
              Locale('en', 'US'),
              Locale('ar', ''),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            home: SplashPage(),
            theme: ThemeData(
              fontFamily: 'Titillium Web',
              textTheme: TextTheme(
                title: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171219),
                ),
                display1: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171219),
                ),
                subhead: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171219),
                ),
                subtitle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171219),
                ),
                display2: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB8234F),
                ),
                caption: TextStyle(fontSize: 16, color: Color(0xFF171219)),
                display3: TextStyle(fontSize: 14, color: Color(0xFF171219)),
                overline: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7A7A7A),
                  letterSpacing: 0.1,
                ),
                display4: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF171219),
                ),
              ),
              accentColor: Color(0xFFB8234F),
              backgroundColor: Color(0xFFF9F8F8),
            ),
          ),
        );
      }),
    );
  }
}
