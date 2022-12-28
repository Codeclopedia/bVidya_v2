import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/routes.dart';
import 'core/theme/apptheme.dart';
import 'core/ui_core.dart';
import 'ui/screen/welcome/splash.dart';

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const BVideyApp();
      },
    );
  }
}

initLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.hourGlass
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class BVideyApp extends StatefulWidget {
  const BVideyApp({Key? key}) : super(key: key);

  @override
  State<BVideyApp> createState() => _BVideyAppState();
}

class _BVideyAppState extends State<BVideyApp> {
  @override
  void initState() {
    super.initState();
    initLoading();
    _firebase();
    // _addChatListener();
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    int i = 0;
    for (var msg in messages) {
      i++;
      switch (msg.body.type) {
        case MessageType.TXT:
          {
            ChatTextMessageBody body = msg.body as ChatTextMessageBody;

            print(
              "receive $i text message: ${body.content}, from: ${msg.from}",
            );
          }
          break;
        case MessageType.IMAGE:
          {
            ChatImageMessageBody body = msg.body as ChatImageMessageBody;

            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VIDEO:
          {
            ChatVideoMessageBody body = msg.body as ChatVideoMessageBody;
            print(
              "receive video message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.LOCATION:
          {
            ChatLocationMessageBody body = msg.body as ChatLocationMessageBody;
            print(
              "receive location message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.VOICE:
          {
            ChatVoiceMessageBody body = msg.body as ChatVoiceMessageBody;
            print(
              "receive voice message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.FILE:
          {
            ChatFileMessageBody body = msg.body as ChatFileMessageBody;
            print(
              "receive image message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CUSTOM:
          {
            ChatCustomMessageBody body = msg.body as ChatCustomMessageBody;
            print(
              "receive custom message, from: ${msg.from}",
            );
          }
          break;
        case MessageType.CMD:
          {}
          break;
      }
    }
  }

  void _addChatListener() {

    ChatClient.getInstance.chatManager.addEventHandler(
      "MAIN_HANDLER_ID",
      ChatEventHandler(onMessagesReceived: onMessagesReceived),
    );
  }

  void _firebase() async {
    // FirebaseMessaging? messaging = FirebaseMessaging.instance;
    // if (messaging == null) return;
    // NotificationSettings settings =
    //     await FirebaseMessaging.instance.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );

    // print('User granted permission: ${settings.authorizationStatus}');
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('token : $token');

    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      debugPrint('getInitialMessage : ${message.data}');
    }
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint('onMessage Received: ${message.data}');
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      debugPrint('onTokenRefresh: $token');
    }, onDone: () {
      debugPrint('onTokenRefresh DONE');
    }, onError: (e) {
      debugPrint('onTokenRefresh Error $e');
    });
  }
  // 1. This method only call when App in background it mean app must be closed

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeLight,
      darkTheme: AppTheme.themeDark,
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
      onGenerateRoute: Routes.generateRoute,
      home: const SplashScreen(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  @override
  void dispose() {
    // ChatClient.getInstance.chatManager.removeEventHandler("MAIN_HANDLER_ID");
    super.dispose();
  }
}
