// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/firebase_options.dart';
import '/core/utils.dart';
import '/data/services/bchat_api_service.dart';
import '/data/models/models.dart';

class BChatSDKController {
  static BChatSDKController instance = BChatSDKController._();
  BChatSDKController._();

  bool _initialized = false;

  Future setup() async {
    try {
      ChatOptions options = ChatOptions(
        appKey: '61420261#491569',
        autoLogin: false,
        acceptInvitationAlways: false,
        deleteMessagesAsExitGroup: false,
        requireAck: true,
        requireDeliveryAck: true,
      );
      if (Platform.isIOS) {
        options.enableAPNs(
            DefaultFirebaseOptions.currentPlatform.messagingSenderId);
      }
      options
          .enableFCM(DefaultFirebaseOptions.currentPlatform.messagingSenderId);
      await ChatClient.getInstance.init(options);
    } catch (e) {
      print('Error : $e');
    }
  }

  Future init() async {
    if (!_initialized) {
      User? currentUser = await getMeAsUser();
      if (currentUser == null) {
        print('user not logged in, Abort initializing sdk');
        try {
          bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
          if (alreadyLoggedIn) {
            await ChatClient.getInstance.logout(false);
          }
        } catch (e) {
          print('$e');
        }
        return;
      }
      await initChatSDK(currentUser);
    }
  }

  Future loadAllContactsGroup() async {
    final client = ChatClient.getInstance;
    try {
      final list = await client.contactManager.getAllContactsFromServer();
      final conversations =
          await client.chatManager.getConversationsFromServer();

      print('Loaded contacts  = ${list.length} - ${conversations.length}');
    } catch (e) {
      print('error contacts  = $e');
    }
    try {
      final list = await client.groupManager.fetchJoinedGroupsFromServer(
        needMemberCount: true,
        needRole: true,
      );
      print('Loaded groups  = ${list.length}');
    } catch (e) {
      print('error groups  = $e');
    }
  }

  Future initChatSDK(User currentUser) async {
    print('initChatSDK $_initialized');
    // if (_initialized) {
    //   return;
    // }
    // _initialized = true;
    print('_initialized');

    final pref = await SharedPreferences.getInstance();
    int? login = pref.getInt('last_login');

    String? oldChatBodyStr = pref.getString('chat_body');
    bool shouldFetchNewToken =
        (DateTime.now().millisecondsSinceEpoch - (login ?? 0)) > 60 * 60 * 1000;
    bool shouldLogin = false;

    // String appKey;
    ChatTokenBody? keyBody;
    if (oldChatBodyStr != null) {
      keyBody = ChatTokenBody.fromJson(jsonDecode(oldChatBodyStr));
    }
    if (shouldFetchNewToken || keyBody == null) {
      final token =
          await BChatApiService.instance.fetchChatToken(currentUser.authToken);
      if (token.body != null) {
        shouldLogin = true;
        if (keyBody != null) {
          shouldLogin = keyBody.appKey != token.body!.appKey ||
              keyBody.userId != token.body!.userId;
          if (shouldLogin) {
            await pref.setString('chat_body', jsonEncode(token.body!));
          }
        } else {
          keyBody = token.body!;
          await pref.setString('chat_body', jsonEncode(token.body!));
        }

        print('should Login -  $shouldLogin');
        print('old Chat Body -  $oldChatBodyStr');
        print('new Chat Body -  ${token.body?.toJson()}');
        // appKey = token.body!.appKey;
      }
    }
    if (keyBody == null) {
      return;
    }
    if ('61420261#491569' != keyBody.appKey) {
      await ChatClient.getInstance.changeAppKey(newAppKey: keyBody.appKey);
    }

    bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
    if (alreadyLoggedIn) {
      if (!shouldLogin) {
        await ChatClient.getInstance.startCallback();
        return;
      }
      try {
        await ChatClient.getInstance.logout(false);
      } catch (e) {
        print('$e');
      }
    }

    if (shouldLogin || !alreadyLoggedIn) {
      await _signIn(keyBody.userId.toString(), keyBody.userToken, currentUser);
      await pref.setInt('last_login', DateTime.now().millisecondsSinceEpoch);
    }
    await ChatClient.getInstance.startCallback();
    // print('token - ${token.body!.userId}');
  }

  Future _signIn(String userId, String agoraToken, User currentUser) async {
    try {
      await ChatClient.getInstance.loginWithAgoraToken(
        userId,
        agoraToken,
      );

      await ChatClient.getInstance.pushManager
          .updateFCMPushToken(currentUser.fcmToken);

      if (Platform.isIOS) {
        String? aPNStoken = await FirebaseMessaging.instance.getAPNSToken();
        if (aPNStoken != null) {
          await ChatClient.getInstance.pushManager
              .updateAPNsDeviceToken(agoraToken);
          // options.enableAPNs(aPNStoken);
        }
        // options.enableAPNs(certName)
      }
      // final info = ChatClient.getInstance.userInfoManager.fetchOwnInfo();
      await ChatClient.getInstance.userInfoManager.updateUserInfo(
        avatarUrl: currentUser.image,
        ext: currentUser.fcmToken,
        nickname: currentUser.name,
        mail: currentUser.email,
        phone: currentUser.phone,
      );

      final pushtemplate =
          await ChatClient.getInstance.pushManager.getPushTemplate();
      print('pushtemplate: $pushtemplate');

      ChatClient.getInstance.pushManager
          .updatePushDisplayStyle(DisplayStyle.Simple);
      // registerForPresence();
      // await loadConversations(ref);

    } on ChatError catch (e) {
      print('Login Error: ${e.code}- ${e.description}');
      if (e.code == 200 || e.code == 202) {
        // await loadConversations(ref);
      }
    }
  }

  // void signOut() async {
  //   try {
  //     await ChatClient.getInstance.logout(false);
  //   } on ChatError catch (_) {}
  // }

  // Future signOutAsync() async {
  //   try {
  //     await ChatClient.getInstance.logout(true);
  //   } on ChatError catch (_) {}
  // }
}
