// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/core/sdk_helpers/bchat_sdk_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/core/sdk_helpers/bchat_handler.dart';
import '/core/state.dart';
import '/core/utils.dart';
import '/core/utils/chat_utils.dart';
import 'controller/providers/bchat/chat_conversation_provider.dart';
import 'controller/providers/bchat/groups_conversation_provider.dart';
import 'core/constants.dart';
import 'core/routes.dart';
import 'core/theme/apptheme.dart';
import 'core/ui_core.dart';
import 'core/utils/callkit_utils.dart';
import 'core/utils/notification_controller.dart';
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
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.yellowAccent
    ..backgroundColor = AppColors.primaryColor
    ..indicatorColor = AppColors.yellowAccent
    ..textColor = AppColors.yellowAccent
    ..maskColor = AppColors.primaryColor
    ..userInteractions = false
    ..dismissOnTap = false;
}

class BVidyaApp extends ConsumerStatefulWidget {
  const BVidyaApp({Key? key}) : super(key: key);

  @override
  ConsumerState<BVidyaApp> createState() => _BVidyaAppState();
}

class _BVidyaAppState extends ConsumerState<BVidyaApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initLoading();
    _firebase();
    NotificationController.startListeningNotificationEvents();
    setupCallKit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      debugPrint('Hello I m here foreground');
      // BChatSDKController.instance.loginOnlyInForeground();
      // AndroidForegroundService.stopForeground();
    } else if (state == AppLifecycleState.paused) {
      debugPrint('Hello I m here background');
      // BChatSDKController.instance.logoutOnlyInBackground();
    }

    if (state == AppLifecycleState.detached) {
      debugPrint('Hello I m here in termination');
    }
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

    // FirebaseMessaging.instance.subscribeToTopic('news');

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('token : $token');
    FirebaseMessaging.onMessage.listen((message) async {
      if ((await getMeAsUser()) == null) return;
      //For P2P Call
      debugPrint('firebase:onMessage -> ${message.toMap()} ');
      if (message.data['type'] == NotiConstants.typeCall) {
        final String? action = message.data['action'];
        if (action == NotiConstants.actionCallStart) {
          // handlShowIncomingCallNotification(message, ref: ref);
        } else if (action == NotiConstants.actionCallEnd) {
          closeIncomingCall(message);
        }
      } else {
        // NotificationController.showErrorMessage('New Foreground : ${message.senderId}');
        NotificationController.handleRemoteMessage(message, true);
        // NotificationController.shouldShowChatNotification(message);
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
      if (message.data['alert'] != null && message.data['e'] != null) {
        handleRemoteMessage(message, context, fallbackScreen: '');
      }
    });
    if ((await getMeAsUser()) == null) return;
    registerForNewMessage(
      'bVidyaApp',
      (msgs) {
        for (var lastMessage in msgs) {
          if (lastMessage.conversationId != null) {
            if (lastMessage.conversationId != null) {
              if (lastMessage.chatType == ChatType.Chat) {
                if (lastMessage.body.type == MessageType.CUSTOM) {
                  // NotificationController.handleCallNotification(lastMessage);
                }
                // print('on Chat Message=> ${lastMessage.body.toJson()} ');
                ref
                    .read(chatConversationProvider.notifier)
                    .updateConversationMessage(lastMessage,
                        update: Routes.getCurrentScreen() == RouteList.home);
              } else if (lastMessage.chatType == ChatType.GroupChat) {
                // print('on GroupChat Message=> ${lastMessage.body.toJson()} ');
                ref
                    .read(groupConversationProvider.notifier)
                    .updateConversationMessage(
                        lastMessage, lastMessage.conversationId!,
                        update: Routes.getCurrentScreen() == RouteList.groups);
              }
              // NotificationController.handleForegroundMessage(lastMessage);
            }
          }
        }
      },
    );

    // bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    // if (!isAllowed) {
    //   await Future.delayed(const Duration(seconds: 3));
    //   await NotificationController.displayNotification(context);
    // }
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
  }

  @override
  void dispose() {
    debugPrint('Hello I m here dispose');
    try {
      unregisterForNewMessage('bVidyaApp');
      BChatSDKController.instance.destroyed();
      // ChatClient.getInstance.logout(false);
      Routes.resetScreen();
    } catch (e) {
      print('object $e');
    }
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
