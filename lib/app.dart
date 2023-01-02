// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/constants.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:provider/provider.dart' as pr;
// import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uuid/uuid.dart';

import 'controller/providers/call_end_provider.dart';
import 'core/helpers/call_helper.dart';
import 'core/utils.dart';
import 'core/helpers/extensions.dart';
import 'core/routes.dart';
import 'core/theme/apptheme.dart';
import 'core/ui_core.dart';
import 'data/models/models.dart';
import 'data/services/fcm_api_service.dart';
import 'ui/screen/welcome/splash.dart';

// final callEndProvier = StateProvider.family<bool, String>((ref, id) => false);

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class ResponsiveApp extends StatelessWidget {
  const ResponsiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return pr.ChangeNotifierProvider(
          create: (context) => ClassEndProvider(),
          child: const BVideyApp(),
        );
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
    setupCallKit();
    getCurrentCall();
    
  }

  getCurrentCall() async {
    final list = await FlutterCallkitIncoming.activeCalls();
    
    print('List-> ${list[0]}');
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
      debugPrint(
          'onMessage Received:  ${message.data['type']} - ${message.data}');
      // onNewFireabseMessage(message, true);
      if (message.data['type'] == 'p2p_call') {
        final String? action = message.data['action'];
        //print('action: $action');
        if (action == 'START_CALL') {
          showIncomingCall(message);
        } else if (action == 'END_CALL') {
          closeIncomingCall(message);
        }
      }
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
    // print('OnBuild Called');
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
      ChatClient.getInstance.logout(false);
    } catch (e) {
      print('object $e');
    }
    WidgetsBinding.instance.removeObserver(this);
    // ChatClient.getInstance.chatManager.removeEventHandler("MAIN_HANDLER_ID");
    super.dispose();
  }
}

onCallAccept(String callerIdFrom, String callerName, String callerImage,
    CallBody body, bool hasVideo) async {
  User? user = await getMeAsUser();
  if (user == null) {
    return;
  }
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    print('Build Context is NULL');
    return;
  }
  Map<String, dynamic> map = {
    'name': callerName,
    'image': callerImage,
    'call_info': body,
    'call_direction_type': CallDirectionType.incoming
  };

  Navigator.pushNamed(
      context, hasVideo ? RouteList.bChatVideoCall : RouteList.bChatAudioCall,
      arguments: map);

  // await receiveCall(
  //     user.authToken, body.callId, callerImage, hasVideo, context);
}

// onHoldAnswer(
//     String callerIdFrom, String callerName, CallBody body, bool hasVideo) {}

// onMuteCall(
//     String callerIdFrom, String callerName, CallBody uuid, bool hasVideo) {}

onDeclineCall(String senderFCM, String callerIdFrom, String callerName,
    String image, CallBody body, bool hasVideo) async {
  User? user = await getMeAsUser();
  if (user == null) {
    return;
  }
  FCMApiService.instance.sendCallPush(senderFCM, '', 'END_CALL', body,
      body.callId, user.id.toString(), user.name, image, true);
}

setupCallKit() {
  FlutterCallkitIncoming.onEvent.listen((event) {
    if (event == null) {
      print('onCall Event Null');
      return;
    }
    final map = event.body;
    if (map == null) {
      return;
    }
    String? fromId = map['from_id'];
    if (fromId == null) {
      return;
    }

    String fromName = map['from_name'];
    String callerFCM = map['caller_fcm'];
    String image = map['image'];
    CallBody body = CallBody.fromJson(jsonDecode(map['caller_fcm']));
    bool hasVideo = map['has_video'];

    print('onCall Event ${event.event}  - ${event.body}');

    switch (event.event) {
      case Event.ACTION_CALL_ACCEPT:
        onCallAccept(fromId, fromName, image, body, hasVideo);
        break;
      case Event.ACTION_CALL_DECLINE:
        onDeclineCall(callerFCM, fromId, fromName, image, body, hasVideo);
        break;
      case Event.ACTION_CALL_START:
        break;
      case Event.ACTION_CALL_ENDED:
        break;
      default:
    }
  });
}

Future<void> showIncomingCall(
  RemoteMessage remoteMessage,
  // FlutterCallkeep callKeep,
) async {
  // String uuid = remoteMessage.payload()["call_id"] as String;
  CallBody? body = remoteMessage.payload();
  if (body == null) {
    return;
  }

  String callerIdFrom = remoteMessage.data["from_id"];
  String callerName = remoteMessage.data["from_name"];
  String senderFCM = remoteMessage.data['caller_fcm'];
  String callerImage = remoteMessage.data['image'];
  bool hasVideo = remoteMessage.data['has_video'] == 'true';
  // makeFakeCallInComing();
  showIncomingCallScreen(
      body, callerName, callerIdFrom, senderFCM, callerImage, hasVideo);
}

// Future<void> showIncomingCall(
//   // BuildContext context,
//   RemoteMessage remoteMessage,
//   FlutterCallkeep callKeep,
// ) async {
//   // String uuid = remoteMessage.payload()["call_id"] as String;
//   String callerIdFrom = remoteMessage.data["from_id"] as String;
//   String callerName = remoteMessage.data["from_name"] as String;
//   String senderFCM = remoteMessage.data['caller_fcm'] as String;
//   String callerImage = remoteMessage.data['image'] as String;
//   CallBody? body = remoteMessage.payload();
//   if (body == null) {
//     return;
//   }
//   bool hasVideo = remoteMessage.data['has_video'] == 'true';

//   // callKeep.on(CallKeepDidToggleHoldAction(),
//   //     onCallAnswer(callerIdFrom, callerName, callerImage, body, hasVideo));
//   // callKeep.on(CallKeepPerformAnswerCallAction(),
//   //     onHoldAnswer(callerIdFrom, callerName, body, hasVideo));
//   // callKeep.on(
//   //     CallKeepPerformEndCallAction(),
//   //     onEndCall(
//   //         senderFCM, callerIdFrom, callerName, callerImage, body, hasVideo));
//   // callKeep.on(CallKeepDidPerformSetMutedCallAction(),
//   //     onMuteCall(callerIdFrom, callerName, body, hasVideo));

//   print('backgroundMessage: displayIncomingCall (${body.callId})');
//   BuildContext? context = navigatorKey.currentContext;
//   if (context == null) {
//     print('Build Context is NULL');
//     return;
//   }
//   // bool hasPhoneAccount = await callKeep.hasPhoneAccount();
//   // if (!hasPhoneAccount) {
//   //   hasPhoneAccount =
//   //       await callKeep.hasDefaultPhoneAccount(context, callSetup["android"]);
//   // }

//   // if (!hasPhoneAccount) {
//   //   return;
//   // }
//   await callKeep.displayIncomingCall(body.callId, callerIdFrom,
//       handleType: '', localizedCallerName: callerName, hasVideo: hasVideo);
//   callKeep.backToForeground();
// }

Future<void> closeIncomingCall(RemoteMessage remoteMessage) async {
  CallBody? body = remoteMessage.payload();
  if (body == null) {
    await FlutterCallkitIncoming.endAllCalls();
    return;
  }

  await FlutterCallkitIncoming.endCall(body.callId);
// await FlutterCallkitIncoming.startCall(Calll)
  BuildContext? context = navigatorKey.currentContext;
  if (context == null) {
    print('Build Context is NULL');
    return;
  }
  pr.Provider.of<ClassEndProvider>(context, listen: false).setCallEnd();
  // context.watch(callEndProvier(body.callId)).
  // context.read();
}

// final FlutterCallkeep callKeep = FlutterCallkeep();
// bool _callKeepStarted = false;

// final callSetup = <String, dynamic>{
//   'ios': {
//     'appName': 'bVidyaDemo',
//   },
//   'android': {
//     'alertTitle': 'Permissions required',
//     'alertDescription': 'This application needs to access your phone accounts',
//     'cancelButton': 'Cancel',
//     'okButton': 'ok',
//     // Required to get audio in background when using Android 11
//     'foregroundService': {
//       'channelId': 'com.company.my',
//       'channelName': 'Foreground service for my app',
//       'notificationTitle': 'My app is running on background',
//       'notificationIcon': 'mipmap/ic_notification_launcher',
//     },
//   },
// };

// setupCallKeep() async {
//   if (!_callKeepStarted) {
//     try {
//       BuildContext? context = navigatorKey.currentContext;
//       if (context == null) {
//         print('Build Context is NULL');
//         return;
//       }

//       await callKeep.setup(context, callSetup, backgroundMode: true);
//       _callKeepStarted = true;
//     } catch (e) {
//       print(e);
//     }
//   }
// }

Future<void> makeFakeCallInComing() async {
  // await Future.delayed(const Duration(seconds: 10), () async {
  final currentUuid = const Uuid().v4();
  final params = CallKitParams(
    id: currentUuid,
    nameCaller: 'Hien Nguyen',
    appName: 'bVidya',
    avatar: 'https://i.pravatar.cc/100',
    handle: '0123456789',
    type: 0,
    duration: 30000,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textMissedCall: 'Missed call',
    textCallback: 'Call back',
    extra: <String, dynamic>{'userId': '1a2b3c4d'},
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
      isShowLogo: false,
      isShowCallback: true,
      isShowMissedCallNotification: true,
      ringtonePath: 'system_ringtone_default',
      backgroundColor: '#0955fa',
      backgroundUrl: 'assets/test.png',
      actionColor: '#4CAF50',
      incomingCallNotificationChannelName: 'Incoming Call',
      missedCallNotificationChannelName: 'Missed Call',
    ),
    ios: IOSParams(
      iconName: 'bVidya',
      handleType: '',
      supportsVideo: true,
      maximumCallGroups: 2,
      maximumCallsPerCallGroup: 1,
      audioSessionMode: 'default',
      audioSessionActive: true,
      audioSessionPreferredSampleRate: 44100.0,
      audioSessionPreferredIOBufferDuration: 0.005,
      supportsDTMF: true,
      supportsHolding: true,
      supportsGrouping: false,
      supportsUngrouping: false,
      ringtonePath: 'system_ringtone_default',
    ),
  );
  await FlutterCallkitIncoming.showCallkitIncoming(params);
  // });
}

showIncomingCallScreen(CallBody callBody, String callerName, String callerId,
    String callerFCM, String callerImage, bool hasVideo) async {
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: '$baseImageApi$callerImage',
    id: callBody.callId,
    nameCaller: callerName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'no_listen': false,
      'from_id': callerId,
      'from_name': callerName,
      'caller_fcm': callerFCM,
      'image': callerImage,
      'has_video': hasVideo,
      'body': jsonEncode(callBody.toJson())
    },
    android: const AndroidParams(
      // backgroundUrl: '$baseImageApi$callerImage',
      isShowLogo: true,
      incomingCallNotificationChannelName: 'call_channel',
      missedCallNotificationChannelName: 'call_channel',
      ringtonePath: 'system_ringtone_default',
      isShowCallback: false,
      isCustomNotification: false,

      isShowMissedCallNotification: true,
      // actionColor: AppColors.primaryColor,
    ),
    ios: IOSParams(
      ringtonePath: 'system_ringtone_default',
      supportsVideo: hasVideo,
    ),
    type: hasVideo ? 1 : 0,
    handle: callerName,
  );
  try {
    final result = await FlutterCallkitIncoming.showCallkitIncoming(kitParam);
    print(' showing UI : $result');
    BuildContext? context = navigatorKey.currentContext;
    if (context == null) {
      print('Build Context is NULL');
      return;
    }
    pr.Provider.of<ClassEndProvider>(context, listen: false).setCallStart();
  } catch (e) {
    print('error showing UI : $e');
  }
}

showOutGoingCall(CallBody callBody, bool hasVideo) async {
  final kitParam = CallKitParams(
    appName: 'bVidya',
    avatar: '',
    id: callBody.callId,
    nameCaller: callBody.callerName,
    textAccept: 'Accept',
    textDecline: 'Decline',
    textCallback: 'Call back',
    extra: {
      'no_listen': true,
      'from_id': '',
      'from_name': callBody.calleeName,
      'caller_fcm': '',
      'image': '',
      'has_video': hasVideo,
      'body': jsonEncode(callBody.toJson())
    },
    android: const AndroidParams(
      // backgroundUrl: '$baseImageApi$callerImage',
      isShowLogo: true,
      incomingCallNotificationChannelName: 'call_channel',
      missedCallNotificationChannelName: 'call_channel',
      ringtonePath: 'system_ringtone_default',
      isShowCallback: false,
      isCustomNotification: false,
      isShowMissedCallNotification: true,
      // actionColor: AppColors.primaryColor,
    ),
    ios: IOSParams(
      ringtonePath: 'system_ringtone_default',
      supportsVideo: hasVideo,
    ),
    type: hasVideo ? 1 : 0,
    handle: callBody.callerName,
  );
  try {
    await FlutterCallkitIncoming.startCall(kitParam);
  } catch (_) {}
}
