import 'dart:async';

 
import 'package:distance_edu/data/hive/model/chat_bot/chat_bot.dart';
import 'package:distance_edu/translates.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'UI/SplashScreen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Firebase.initializeApp();
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive
      ..init(appDocumentDir.path)
      ..registerAdapter(ChatBotAdapter());
    await Hive.openBox<ChatBot>('chatbots');
    await SentryFlutter.init((options) {
      options.dsn =
          'https://b2c7ee75f00e241fe524db04b8c602a5@o4506263171629056.ingest.us.sentry.io/4507094842408960';

      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
    });

    runApp(EasyLocalization(
        supportedLocales: Translates.all,
        path: "assets/translates",
        fallbackLocale: Translates.all[0],
        child: const ProviderScope(
          child: MyApp(),
        )));
  }, (error, stackTrace) async {
    print("Error FROM OUT_SIDE FRAMEWORK ");
    print("--------------------------------");
    print("Error :  $error");
    print("StackTrace :  $stackTrace");
    await Sentry.captureException(error, stackTrace: stackTrace);
  });
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        title: 'Distant Edu ',
        navigatorKey: navigatorKey,
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF6F30C0),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // text color
                  backgroundColor: const Color(0xFF6F30C0)),
            ),
            primaryColor: const Color(0xFF6F30C0),
            fontFamily: "Poppins"),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
