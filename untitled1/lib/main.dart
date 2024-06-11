import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:untitled1/router/app_router.dart';

import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Flogger.d('FirebaseService 初始化完成');
  setupLocator(); // 使用 locator 進行綁定
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _appRouter = GetIt.instance<AppRouter>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // 多國語言支援
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,

      // 防止字體大小受系統影響
      builder: (context, child) {
        return MediaQuery.withNoTextScaling(child: child!);
      },

      routerConfig: _appRouter.config(),
    );
  }
}
