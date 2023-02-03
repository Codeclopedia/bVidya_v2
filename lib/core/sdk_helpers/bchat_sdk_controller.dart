// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../constants/agora_config.dart';
import '/firebase_options.dart';
import '/core/utils.dart';
import '/data/services/bchat_api_service.dart';
import '/data/models/models.dart';

class BChatSDKController {
  static BChatSDKController instance = BChatSDKController._();
  BChatSDKController._();

  bool _initialized = false;

//from main
  Future setup() async {
    try {
      ChatOptions options = ChatOptions(
        appKey: AgoraConfig.appKey,
        autoLogin: false,
        acceptInvitationAlways: AgoraConfig.autoAcceptContact,
        deleteMessagesAsExitGroup: false,
        requireAck: true,
        requireDeliveryAck: true,
      );
      if (Platform.isIOS) {
        options.enableAPNs('bVidyaDemoKey');
        //bVidyaAPNKey
      }
      options
          .enableFCM(DefaultFirebaseOptions.currentPlatform.messagingSenderId);
      await ChatClient.getInstance.init(options);
      print('Chat Client initialized');
    } catch (e) {
      print('Error in Chat Client initialization');
      print('Error : $e');
    }
  }

  // Future init() async {
  //   if (!_initialized) {
  //     _initialized = true;
  //     User? currentUser = await getMeAsUser();
  //     if (currentUser == null) {
  //       print('user not logged in, Abort initializing sdk');
  //       try {
  //         bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
  //         if (alreadyLoggedIn) {
  //           await ChatClient.getInstance.logout(true);
  //         }
  //       } catch (e) {
  //         print('$e');
  //       }
  //       return;
  //     }
  //     await initChatSDK(currentUser);
  //   }
  // }

  Future loadAllContactsGroup() async {
    final client = ChatClient.getInstance;

    try {
      final conversations =
          await client.chatManager.getConversationsFromServer();
      for (var c in conversations) {
        await client.chatManager.fetchHistoryMessages(conversationId: c.id);
      }
      print('Loaded conversation  => - ${conversations.join(',')}');
    } catch (e) {
      print('error loading conversation  = $e');
    }

    try {
      final list = await client.contactManager.getAllContactsFromServer();

      print('Loaded contacts  = ${list.join(',')}');
    } catch (e) {
      print('error loading contacts  = $e');
    }
    try {
      final list = await client.groupManager.fetchJoinedGroupsFromServer(
        needMemberCount: true,
        needRole: true,
      );
      print('Loaded groups  = ${list.length}');
    } catch (e) {
      print('error loading groups  = $e');
    }
  }

  bool _logging = false;
  // bool _loggingOut = false;
  // Future logoutOnlyInBackground() async {
  //   if (_loggingOut) return;
  //   _loggingOut = true;
  //   try {
  //     bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
  //     if (alreadyLoggedIn) {
  //       await ChatClient.getInstance.logout(false);
  //     }
  //   } catch (e) {
  //     print('$e');
  //   }
  //   _loggingOut = false;
  // }

  int count = 0;
  Future loginOnlyInBackground() async {
    count = 0;
    _loginOnlyInForeground();
  }

  Future _loginOnlyInForeground({bool loadApi = false}) async {
    if (_logging) return;
    _logging = true;
    count++;
    try {
      User? currentUser = await getMeAsUser();
      if (currentUser == null) {
        _logging = false;
        return;
      }
      ChatTokenBody? keyBody;
      if (!loadApi) {
        final pref = await SharedPreferences.getInstance();
        String? oldChatBodyStr = pref.getString('chat_body');
        if (oldChatBodyStr != null) {
          keyBody = ChatTokenBody.fromJson(jsonDecode(oldChatBodyStr));
        }
      }
      if (loadApi || keyBody == null) {
        final token = await BChatApiService.instance
            .fetchChatToken(currentUser.authToken);
        if (token.body != null) {
          keyBody = token.body!;
        }
      }

      if (keyBody != null) {
        if ('61420261#491569' != keyBody.appKey) {
          await ChatClient.getInstance.changeAppKey(newAppKey: keyBody.appKey);
        }

        await ChatClient.getInstance.loginWithAgoraToken(
          keyBody.userId.toString(),
          keyBody.userToken,
        );
      }
    } catch (e) {
      if (count < 2) {
        _loginOnlyInForeground(loadApi: true);
      }
    }

    _logging = false;
  }

//from splash

// Future initIfNotInitialised()async{
//     bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
//     if (alreadyLoggedIn) {
//       try {
//         await ChatClient.getInstance.logout(false);
//       } catch (e) {
//         print('$e');
//       }
//     }
// }
  bool get isInitialized => _initialized;

  Future initChatSDK(User currentUser) async {
    if (_initialized) {
      print('initChatSDK already $_initialized');

      return;
    }
    print('initChatSDK $_initialized');
    // print('_initializing');
    _initialized = true;

    final pref = await SharedPreferences.getInstance();
    bool shouldLogin = false;
    ChatTokenBody? keyBody;
    final tokenResponse =
        await BChatApiService.instance.fetchChatToken(currentUser.authToken);
    if (tokenResponse.body != null) {
      shouldLogin = true;
      keyBody = tokenResponse.body!;
      await pref.setString('chat_body', jsonEncode(keyBody));
    }
    if (keyBody == null) {
      return;
    }
    if ('61420261#491569' != keyBody.appKey) {
      await ChatClient.getInstance.changeAppKey(newAppKey: keyBody.appKey);
    }

    bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();
    if (alreadyLoggedIn) {
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

      // final token = await FirebaseMessaging.instance.getToken();
      await ChatClient.getInstance.pushManager
          .updateFCMPushToken(currentUser.fcmToken);

      if (Platform.isIOS) {
        String? aPNStoken = await FirebaseMessaging.instance.getAPNSToken();
        if (aPNStoken != null) {
          print('apnsToke=$aPNStoken');
          await ChatClient.getInstance.pushManager
              .updateAPNsDeviceToken(aPNStoken);
          // options.enableAPNs(aPNStoken);
        } else {
          print('apnsToke is null');
        }
        //   // options.enableAPNs(certName)
      }
      // final info = ChatClient.getInstance.userInfoManager.fetchOwnInfo();
      await ChatClient.getInstance.userInfoManager.updateUserInfo(
        avatarUrl: currentUser.image,
        ext: currentUser.fcmToken,
        nickname: currentUser.name,
        mail: currentUser.email,
        phone: currentUser.phone,
      );

      // final pushtemplate =
      //     await ChatClient.getInstance.pushManager.getPushTemplate();
      // print('pushtemplate: $pushtemplate');
      // ChatClient.getInstance.pushManager
      //     .updatePushDisplayStyle(DisplayStyle.Simple);
      // registerForPresence();
      // await loadConversations(ref);

    } on ChatError catch (e) {
      print('Login Error: ${e.code}- ${e.description}');
      if (e.code == 200 || e.code == 202) {
        // await loadConversations(ref);
      }
    }
  }

  destroyed() {
    _initialized = false;
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
