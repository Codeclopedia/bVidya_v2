// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/utils/chat_utils.dart';
import 'package:bvidya/data/models/conversation_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/constants.dart';
import 'core/helpers/bchat_handler.dart';
import 'core/routes.dart';
import 'core/theme/apptheme.dart';
import 'core/ui_core.dart';
import 'core/utils/call_utils.dart';
import 'ui/screen/welcome/splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return const BVidyaApp();
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

class BVidyaApp extends StatefulWidget {
  const BVidyaApp({Key? key}) : super(key: key);

  @override
  State<BVidyaApp> createState() => _BVidyaAppState();
}

class _BVidyaAppState extends State<BVidyaApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initLoading();
    _firebase();
    setupCallKit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print('Hello I m here foreground');
      // AndroidForegroundService.stopForeground();
    }
    if (state == AppLifecycleState.paused) {
      print('Hello I m here background');
    }

    if (state == AppLifecycleState.detached) {
      print('Hello I m here in termination');
    }
  }

//phone  cizrHqoEQ9eQ-qIhBsiNmh:APA91bGGAQJ_jX3CxDH7yppIRmRTLqWsjPqXm76wZdLmqqF6KwnYm7hwETnFz_cjbesXiRutNHpEOG_DhqX4-i4mObuzohBgKotvY8sOWkYpfu6R8BeSXg3xnXXtk-EM_MjVWGqJbnnn
//Tablet coto9ZIQQx6JnETPcwmNXP:APA91bE-APmjhr2dX9MwyA58DttecVdQMlxirOovMdejgf27Tb-ivAx11K95p1YRoGpwvGycLJCGpyWZbT-ML6exlypQpoHcRH27jtePK1yC1JjaD15NRFkLz1sYskABtt7ayjy6oFvP
  void onMessagesReceived(List<ChatMessage> messages) {
    // int i = 0;
    // for (var msg in messages) {
    // i++;
    // switch (msg.body.type) {
    //   case MessageType.TXT:
    //     {
    //       ChatTextMessageBody body = msg.body as ChatTextMessageBody;
    //       print(
    //         "receive $i text message: ${body.content}, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.IMAGE:
    //     {
    //       ChatImageMessageBody body = msg.body as ChatImageMessageBody;
    //       print(
    //         "receive image message, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.VIDEO:
    //     {
    //       ChatVideoMessageBody body = msg.body as ChatVideoMessageBody;
    //       print(
    //         "receive video message, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.LOCATION:
    //     {
    //       ChatLocationMessageBody body = msg.body as ChatLocationMessageBody;
    //       print(
    //         "receive location message, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.VOICE:
    //     {
    //       ChatVoiceMessageBody body = msg.body as ChatVoiceMessageBody;
    //       print(
    //         "receive voice message, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.FILE:
    //     {
    //       ChatFileMessageBody body = msg.body as ChatFileMessageBody;
    //       print(
    //         "receive image message, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.CUSTOM:
    //     {
    //       ChatCustomMessageBody body = msg.body as ChatCustomMessageBody;
    //       print(
    //         "receive custom message, from: ${msg.from}",
    //       );
    //     }
    //     break;
    //   case MessageType.CMD:
    //     {}
    //     break;
    // }
    // }
  }

  void _addChatListener() {
    registerForNewMessage(
      'app_message_handler',
      (p0) {
        onMessagesReceived(p0);
      },
    );
  }

  void _firebase() async {
    // FirebaseMessaging? messaging = FirebaseMessaging.instance;
    // if (messaging == null) return;
    // NotificationSettings settings =
    //  await FirebaseMessaging.instance.requestPermission(
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

    FirebaseMessaging.onMessage.listen((message) {
      //For P2P Call
      print('firebase:onMessage -> ${message.toMap()} ');
      if (message.data['type'] == NotiConstants.typeCall) {
        final String? action = message.data['action'];
        if (action == NotiConstants.actionCallStart) {
          showIncomingCall(message);
        } else if (action == NotiConstants.actionCallEnd) {
          closeIncomingCall(message);
        }
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      if (Platform.isIOS) {
        await ChatClient.getInstance.pushManager.updateAPNsDeviceToken(
          token,
        );
      } else if (Platform.isAndroid) {
        await ChatClient.getInstance.pushManager.updateFCMPushToken(
          token,
        );
      }
      debugPrint('onTokenRefresh: $token');
    }, onDone: () {
      debugPrint('onTokenRefresh DONE');
    }, onError: (e) {
      debugPrint('onTokenRefresh Error $e');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data['alert'] != null && message.data['f'] != null) {
        //open specific screen
        String from = message.data['f'];
        // String to = message.data['t'];
        final model = await getConversationModel(from);
        if (model != null) {
          // await Navigator.pushNamed(context, RouteList.chatScreen,
          //     arguments: model);
        }
      }
    });
  }

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
      navigatorKey: navigatorKey,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
    // });
  }

  @override
  void dispose() {
    try {
      // unregisterForNewMessage('app_message_handler');
      ChatClient.getInstance.logout(false);
    } catch (e) {
      print('object $e');
    }
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
