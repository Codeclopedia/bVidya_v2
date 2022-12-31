import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:callkeep/callkeep.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bvidya/core/helpers/extensions.dart';

// import 'controller/providers/user_auth_provider.dart';
// import 'core/constants/route_list.dart';
import 'core/routes.dart';
// import 'core/state.dart';
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

class _BVideyAppState extends State<BVideyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    initLoading();
    _firebase();
    setupCallKeep(context);
    // _addChatListener();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // AndroidForegroundService.stopForeground();
    }
    if (state == AppLifecycleState.paused) {
      print('Hello I m here background');
      // background = true;
    }

    if (state == AppLifecycleState.detached) {
      print('Hello I m here in termination');

      // background = false;
    }
  }

  void onMessagesReceived(List<ChatMessage> messages) {
    int i = 0;
    for (var msg in messages) {
      i++;
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
    print('OnBuild Called');
    // return Consumer(builder: (_, ref, child) {
    //   ref.read(userAuthChangeProvider).loadUser();

    //   ref.listen(userAuthChangeProvider, ((previous, next) {
    //     print('listen called ${next.isUserSigned}');
    //     if (next.user == null && next.isUserSigned) {
    //       ref.read(userAuthChangeProvider).setUserSigned(false);
    //       print('User is null');
    //       Navigator.pushNamedAndRemoveUntil(
    //           context, RouteList.login, (route) => route.isFirst);
    //     }
    //   }));

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
    // });
  }

  @override
  void dispose() {
    try {
      ChatClient.getInstance.logout(false);
    } catch (e) {}
    WidgetsBinding.instance.removeObserver(this);

    // ChatClient.getInstance.chatManager.removeEventHandler("MAIN_HANDLER_ID");
    super.dispose();
  }
}

onCallAnswer(
    String callerIdFrom, String callerName, String uuid, bool hasVideo) {}
onHoldAnswer(
    String callerIdFrom, String callerName, String uuid, bool hasVideo) {}

onEndCall(String callerIdFrom, String callerName, String uuid, bool hasVideo) {}

onMuteCall(
    String callerIdFrom, String callerName, String uuid, bool hasVideo) {}

Future<void> showIncomingCall(
  BuildContext context,
  RemoteMessage remoteMessage,
  FlutterCallkeep callKeep,
) async {
  String uuid = remoteMessage.payload()["call_id"] as String;
  String callerIdFrom = remoteMessage.payload()["caller_id"] as String;
  String callerName = remoteMessage.payload()["caller_name"] as String;

  bool hasVideo = remoteMessage.payload()["has_video"] == "true";

  callKeep.on(CallKeepDidToggleHoldAction(),
      onCallAnswer(callerIdFrom, callerName, uuid, hasVideo));
  callKeep.on(CallKeepPerformAnswerCallAction(),
      onHoldAnswer(callerIdFrom, callerName, uuid, hasVideo));
  callKeep.on(CallKeepPerformEndCallAction(),
      onEndCall(callerIdFrom, callerName, uuid, hasVideo));
  callKeep.on(CallKeepDidPerformSetMutedCallAction(),
      onMuteCall(callerIdFrom, callerName, uuid, hasVideo));

  print('backgroundMessage: displayIncomingCall ($uuid)');

  bool hasPhoneAccount = await callKeep.hasPhoneAccount();
  if (!hasPhoneAccount) {
    hasPhoneAccount =
        await callKeep.hasDefaultPhoneAccount(context, callSetup["android"]);
  }

  if (!hasPhoneAccount) {
    return;
  }
  await callKeep.displayIncomingCall(uuid, callerIdFrom,
      localizedCallerName: callerName, hasVideo: hasVideo);
  callKeep.backToForeground();
}

Future<void> closeIncomingCall(
  RemoteMessage remoteMessage,
  FlutterCallkeep callKeep,
) async {
  String uuid = remoteMessage.payload()['call_id'] as String;
  print('backgroundMessage: closeIncomingCall ($uuid)');
  bool hasPhoneAccount = await callKeep.hasPhoneAccount();
  if (!hasPhoneAccount) {
    return;
  }
  await callKeep.endAllCalls();
}

final FlutterCallkeep callKeep = FlutterCallkeep();
bool _callKeepStarted = false;

final callSetup = <String, dynamic>{
  'ios': {
    'appName': 'bVidyaDemo',
  },
  'android': {
    'alertTitle': 'Permissions required',
    'alertDescription': 'This application needs to access your phone accounts',
    'cancelButton': 'Cancel',
    'okButton': 'ok',
    // Required to get audio in background when using Android 11
    'foregroundService': {
      'channelId': 'com.company.my',
      'channelName': 'Foreground service for my app',
      'notificationTitle': 'My app is running on background',
      'notificationIcon': 'mipmap/ic_notification_launcher',
    },
  },
};

setupCallKeep(BuildContext context) async {
  if (!_callKeepStarted) {
    try {
      await callKeep.setup(context, callSetup, backgroundMode: true);
      _callKeepStarted = true;
    } catch (e) {
      print(e);
    }
  }
}
