import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logging_flutter/logging_flutter.dart';
import 'package:untitled1/router/app_router.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'locator.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Flogger.d('FirebaseService 初始化完成');
  setupLocator(); // 使用 locator 進行綁定

  // region 本地通知初始化設定，套件：flutter_local_notifications
  tz.initializeTimeZones(); // 初始化通知的時區

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid,
    iOS: DarwinInitializationSettings(),);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (payload != null && payload.isNotEmpty) {
        // 當螢幕顯示通知訊息時，使用者點擊，處理通知點擊事件
        print('notification payload: $payload');
        // 根據 payload 導航到對應的頁面或執行對應的操作
        // 例如：AutoRouter.of(context).push(TaskDetailRoute(taskId: payload));
      }
    },
  );

  // 請求精確鬧鐘權限
  bool granted = await requestScheduleExactAlarmPermission();
  if (!granted) {
    print("Exact alarm permission not granted.");
  }
  // endregion 本地通知初始化設定，套件：flutter_local_notifications

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

Future<bool> requestScheduleExactAlarmPermission() async {
  const MethodChannel channel = MethodChannel('com.example.untitled1/permission');
  try {
    final bool granted = await channel.invokeMethod('requestScheduleExactAlarm');
    return granted;
  } on PlatformException catch (e) {
    print("Failed to request exact alarm permission: '${e.message}'.");
    return false;
  }
}
