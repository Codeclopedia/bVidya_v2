// ignore_for_file: use_build_context_synchronously

// import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '/core/helpers/foreground_message_helper.dart';
import '/core/sdk_helpers/bchat_sdk_controller.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/sdk_helpers/bchat_handler.dart';
import '/core/state.dart';
import '/core/utils.dart';

import 'controller/providers/bchat/groups_conversation_provider.dart';
import 'controller/providers/user_auth_provider.dart';
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
    appLoaded = false;
    WidgetsBinding.instance.addObserver(this);
    setupCallKit();

    initLoading();
    _firebase();

    NotificationController.startListeningNotificationEvents();
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
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('token : $token');
    FirebaseMessaging.onMessage.listen((message) async {
      print('onMessage => ${message.data} : ${message.notification}');
      if ((await getMeAsUser()) == null) return;

      //For P2P Call
      if (message.data['type'] == NotiConstants.typeCall) {
        final String? action = message.data['action'];
        if (action == NotiConstants.actionCallStart) {
        } else if (action == NotiConstants.actionCallEnd) {
          closeIncomingCall(message);
        }
      } else if (message.data['type'] == NotiConstants.typeGroupCall) {
        final String? action = message.data['action'];
        if (action == NotiConstants.actionCallEnd) {
          closeIncomingGroupCall(message);
        }
      } else {
        ForegroundMessageHelper.handleCallingNotificationForeground(message);
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      try {
        // if (Platform.isIOS) {
        //   // String? aPNStoken = await FirebaseMessaging.instance.getAPNSToken();
        //   // if (aPNStoken != null) {
        //   //   await ChatClient.getInstance.pushManager
        //   //       .updateAPNsDeviceToken(aPNStoken);
        //   // }
        // } else if (Platform.isAndroid) {
          
        // }
        await ChatClient.getInstance.pushManager.updateFCMPushToken(token);
      } catch (e) {}
      debugPrint('onTokenRefresh: $token');
    }, onDone: () {
      debugPrint('onTokenRefresh DONE');
    }, onError: (e) {
      debugPrint('onTokenRefresh Error $e');
    });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   if (message.data['alert'] != null && message.data['e'] != null) {
    //     handleRemoteMessage(message, context, fallbackScreen: '');
    //   }
    // });
    // if ((await getMeAsUser()) == null) return;
    registerForNewMessage(
      'bVidyaApp',
      (msgs) async {
        if (!appLoaded) return;
        // if ((await getMeAsUser()) == null) return;
        for (var lastMessage in msgs) {
          if (lastMessage.conversationId == null) {
            continue;
          }
          if (lastMessage.chatType == ChatType.Chat) {
            final value = await onNewChatMessage(lastMessage, ref);
            // final value = await ref
            //     .read(chatConversationProvider.notifier)
            //     .updateConversationMessage(lastMessage,
            //         update: Routes.getCurrentScreen() == RouteList.home);
            if (lastMessage.body.type == MessageType.CUSTOM) {
              // if (activeCallId != null) return;
              ForegroundMessageHelper.handleCallNotification(lastMessage, ref);
            } else if (value != null) {
              ForegroundMessageHelper.handleChatNotification(
                  value, lastMessage);
            }
          } else if (lastMessage.chatType == ChatType.GroupChat) {
            // print('on GroupChat Message=> ${lastMessage.body.toJson()} ');
            ref
                .read(groupConversationProvider.notifier)
                .updateConversationMessage(
                    lastMessage, lastMessage.conversationId!,
                    update: Routes.getCurrentScreen() == RouteList.groups);
            // final values = ref.read(groupConversationProvider);
            final value = ref.read(groupConversationProvider).firstWhereOrNull(
                (element) => element.id == lastMessage.conversationId);
            if (value != null) {
              ForegroundMessageHelper.handleGroupChatNotification(
                  value, lastMessage);
            }
            // if(values.l.contains(lastMessage.conversationId)){
            // }
            // NotificationController.handleForegroundMessage(lastMessage);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userLoginStateProvider, (previous, next) {
      if (previous != null && next == null) {
        BuildContext? cntx = navigatorKey.currentContext;
        if (cntx != null) {
          Navigator.pushNamedAndRemoveUntil(
              cntx, RouteList.login, (route) => false);
        }
      }
    });

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






// pushRegistry TOKEN
// 303f075379c3c5631fb64e0ab75b17b84e8fc7bfd9da6812b02a51f683324e41


// Registered for Apple Remote Notifications:
// f3bd1993772e27fc1c124481e6771303325df1ea0d0cd5e55c7c0df51e0e3de9


// FCM registration token: 
// dGzegKDL3U2mrvAb-e3Fmg:APA91bEx11ahZYg-m9qitWfjLQF4C6cFG9RplZBXwjSBoKFtgkT5j2KwQGtBGKFfOQm-_mKVe8eM0Gny6fBxaI5E552VgDS9mAUp2S5p6BqeonN21iFiqbtXN5BiTfRy6dvqTFYmPeEn



// token : 
// dGzegKDL3U2mrvAb-e3Fmg:APA91bEx11ahZYg-m9qitWfjLQF4C6cFG9RplZBXwjSBoKFtgkT5j2KwQGtBGKFfOQm-_mKVe8eM0Gny6fBxaI5E552VgDS9mAUp2S5p6BqeonN21iFiqbtXN5BiTfRy6dvqTFYmPeEn

// apnsToke=
// F3BD1993772E27FC1C124481E6771303325DF1EA0D0CD5E55C7C0DF51E0E3DE9

// flutter: token : 
// da5_VUeOpU1zupkrrqB91a:APA91bG2TOj8liizfoBJPPhKMyM1S5qhm1JWtt6fnQ5nbiUCLg49W7VN2USAl1L1ZtgI4KkkZ4GPqo3HXu8fSW47dUbAPvSB7JGd7UtsOOxZLm1UEZkVyzVxz1jG8Q0Pld2EervJQeU6


//2023-02-01 16:00:42.967288+0530 Runner[2590:129856] flutter: apnsToke=
//4A91D63BFF0DFA9125279537462BEE0D27345E211D1A3DB223733AF951E4D346


// Registered for Apple Remote Notifications:
// A724F58B3DF0136F70668DFFE186F4B00DCEB32EAEF789A65EB6F86859C92BE8

// pushRegistry TOKEN
// 303f075379c3c5631fb64e0ab75b17b84e8fc7bfd9da6812b02a51f683324e41
// eecLyWlUS09QmImoE-FuzE:APA91bEzA-oZ-fNkchuHmoiJ9xhRJWwn_9heHXXM-wL52VW7KIk4IwUEiGAlLY9YYmmzM0NMKz220HxbgxPhczaCcMv-02_H6grhjduP5adOZtYwAXBLPzBATGdabWR_bN3aZujG2ukH
// 2023-02-01 17:19:54.6