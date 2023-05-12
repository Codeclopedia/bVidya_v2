// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/firebase_options.dart';
import 'package:collection/collection.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';

import 'controller/bchat_providers.dart';
import 'core/constants/agora_config.dart';
import 'core/helpers/group_member_helper.dart';
import 'core/utils/request_utils.dart';
// import 'secret/keys.dart';
import 'ui/base_back_screen.dart';
import 'core/helpers/foreground_message_helper.dart';
import 'core/sdk_helpers/bchat_sdk_controller.dart';
import 'controller/providers/bchat/chat_conversation_list_provider.dart';
import 'core/sdk_helpers/bchat_handler.dart';
import 'core/state.dart';
import 'core/utils.dart';

import 'controller/providers/bchat/groups_conversation_provider.dart';
import 'controller/providers/user_auth_provider.dart';
import 'core/constants.dart';
import 'core/helpers/background_helper.dart';
import 'core/helpers/apns_handler.dart';
import 'core/routes.dart';
import 'core/theme/apptheme.dart';
import 'core/ui_core.dart';
import 'core/utils/callkit_utils.dart';
// import 'core/utils/notification_controller.dart';
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

Future<void> disposeSmartlook({required Smartlook smartlook}) async {
  await smartlook.stop();
}

Future<void> initSmartlook({required Smartlook smartlook}) async {
  // await smartlook.log.enableLogging();
  await smartlook.preferences.setProjectKey(smartlookKey);
  await smartlook.start();
  // smartlook.registerIntegrationListener(CustomIntegrationListener());
  await smartlook.preferences.setWebViewEnabled(true);
  smartlook.state.getRecordingStatus().then(
    (value) {
      debugPrint('the status of the recording is $value');
    },
  );

  // smartlook.changeNativeClassSensitivity([
  //   SensitivityTuple(
  //       classType: SmartlookNativeClassSensitivity.WebView, isSensitive: true),
  //   SensitivityTuple(
  //       classType: SmartlookNativeClassSensitivity.WKWebView,
  //       isSensitive: true),
  // ]);
}

class BVidyaApp extends ConsumerStatefulWidget {
  const BVidyaApp({Key? key}) : super(key: key);

  @override
  ConsumerState<BVidyaApp> createState() => _BVidyaAppState();
}

class _BVidyaAppState extends ConsumerState<BVidyaApp>
    with WidgetsBindingObserver {
  final Smartlook? smartlook = isReleaseBuild ? Smartlook.instance : null;

  @override
  void initState() {
    super.initState();
    appLoaded = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    WidgetsBinding.instance.addObserver(this);
    setupCallKit();
    if (smartlook != null) {
      initSmartlook(smartlook: smartlook!);
    }

    initLoading();
    _firebase();
    registerForContact();

    // NotificationController.startListeningNotificationEvents();
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
      if (smartlook != null) {
        disposeSmartlook(smartlook: smartlook!);
      }
    }
  }

  void _firebase() async {
    if (Platform.isAndroid) {
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        debugPrint('onMessageOpenedApp => ${message.from} : ${message.data}');
        BuildContext? contx = navigatorKey.currentContext;
        if (contx != null) {
          showLoading(ref);
          ForegroundMessageHelper.onMessageOpen(message, contx);
          hideLoading(ref);
        } else {
          debugPrint('Null Context =>');
        }
      });
    } else if (Platform.isIOS) {
      ApnsPushConnectorOnly.instance.configureApns(
        onMessageTap: (message) async {
          // debugPrint('foreground=>:${message.data}');
          BuildContext? contx = navigatorKey.currentContext;
          if (contx != null) {
            showLoading(ref);
            ApnsPushConnectorOnly.onMessageOpen(message, contx);
            hideLoading(ref);
          } else {
            debugPrint('Null Context =>');
          }
        },
        onMessage: (message) {
          try {
            print('onMessage:${message.data['data']}');
            // bool background = message.data['background']=="1";
            final data = Map<String, dynamic>.from(message.data['data']);
            // print('Type:${data['type']}  ${data['action']}');

            if (data['type'] == NotiConstants.typeCall) {
              final String? action = data['action'];
              if (action == NotiConstants.actionCallStart) {
                // print('Pre showCallingNotification');
                showCallingNotification(data, false);
                // print('Post showCallingNotification');
              } else if (action == NotiConstants.actionCallEnd) {
                // print('Pre closeIncomingCall $data');
                closeIncomingCall(data);
                // print('Post closeIncomingCall');
              }
            } else if (data['type'] == NotiConstants.typeGroupCall) {
              final String? action = data['action'];
              if (action == NotiConstants.actionCallStart) {
                showGroupCallingNotification(data, false);
              }
              if (action == NotiConstants.actionCallEnd) {
                closeIncomingGroupCall(data);
              }
            } else if (data['type'] == NotiConstants.typeContact) {
              final String? fromId = data['f'];
              ContactAction? action = contactActionFrom(data['action']);
              if (action != null && fromId != null) {
                ContactRequestHelper.handleNotification(message.data['title'],
                    message.data['body'], action, fromId, true,
                    ref: ref);
              }
            } else if (data['type'] == NotiConstants.typeGroupMemberUpdate) {
              final String? fromId = data['f'];
              final String? grpId = data['g'];
              GroupMemberAction? action = groupActionFrom(data['action']);
              if (action != null && fromId != null && grpId != null) {
                GroupMemberHelper.handleNotification(message.data['title'],
                    message.data['body'], action, fromId, grpId, true,
                    ref: ref);
              }
            }
          } catch (e) {
            // print('Error222 : $e');
          }
          // ForegroundMessageHelper.onForegroundMessage(ref, message.data['data'],
          //     message.data['title'], message.data['body']);
        },
      );
    }

    FirebaseMessaging.onMessage.listen((message) async {
      // print('onMessage => ${message.data} : ${message.notification}');
      if ((await getMeAsUser()) == null) return;
      //For P2P Call
      ForegroundMessageHelper.onForegroundMessage(ref, message.data,
          message.notification?.title, message.notification?.body);
    });
    final atoken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token => $atoken');
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      try {
        if (Platform.isIOS) {
          String? aPNStoken = await FirebaseMessaging.instance.getAPNSToken();
          if (aPNStoken != null) {
            await ChatClient.getInstance.pushManager
                .updateAPNsDeviceToken(aPNStoken);
          }
        }
        await ChatClient.getInstance.pushManager.updateFCMPushToken(token);
      } catch (_) {}
      debugPrint('onTokenRefresh: $token');
    }, onDone: () {
      debugPrint('onTokenRefresh DONE');
    }, onError: (e) {
      debugPrint('onTokenRefresh Error $e');
    });

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
              ForegroundMessageHelper.showForegroundChatNotification(
                  value, lastMessage);
            }
          } else if (lastMessage.chatType == ChatType.GroupChat) {
            // print('on GroupChat Message=> ${lastMessage.body.toJson()} ');
            await ref
                .read(groupConversationProvider.notifier)
                .updateConversationMessage(
                    lastMessage, lastMessage.conversationId!,
                    update: Routes.getCurrentScreen() == RouteList.groups);
            // final values = ref.read(groupConversationProvider);
            final value = ref.read(groupConversationProvider).firstWhereOrNull(
                (element) => element.id == lastMessage.conversationId);
            if (value != null) {
              ForegroundMessageHelper.showForegroundGroupChatNotification(
                  value, lastMessage);
            }
            ref.invalidate(groupUnreadCountProvider); //Reset Group Unread count

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
      navigatorObservers: [SmartlookObserver()],
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
      unregisterForContact();
      unregisterForNewMessage('bVidyaApp');
      BChatSDKController.instance.destroyed();
      // ChatClient.getInstance.logout(false);
      Routes.resetScreen();
    } catch (e) {
      debugPrint('error in dispose app $e');
    }

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}


//fPxs8N8570Rztkg73fBPve:APA91bE97WF_-tMluAyR0I77zVvha4Y1yYl5T4ceWF2xDAnP-WHJ33Tj0hHZeOLoc9owKoob3dJ2H2Hbv0_9QtGqsL6Op85cum-5vRgh_bUuLgpokoGS1twc1b0V-eB07ECMCCy2neYw


//ePJ24RCsRrSNSFfMmzr6f6:APA91bFC_SaLTKYfc0iCG2EVRau4HYzgFVz6ZO-xUzxDJ1JZ9rDdANI4t_PuJu_fJbQiK0SupXjj_vBo9erRpNaLbiH1O-BQTb4uQbkvkeFoHBP_xjGurO5tACFJdpr8UWldjGgRRzZ0