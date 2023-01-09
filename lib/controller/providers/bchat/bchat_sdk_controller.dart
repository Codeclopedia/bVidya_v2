// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/utils.dart';

import '/data/services/bchat_api_service.dart';

import '/firebase_options.dart';
import '/data/models/models.dart';

class BChatSDKController {
  // WidgetRef? _ref;
  // BChatSDKController() {
  //   print('BChatSDKController initialized');
  // }
  static BChatSDKController instance = BChatSDKController._();
  BChatSDKController._();

  bool _initialized = false;

  init() async {
    if (!_initialized) {
      User? currentUser = await getMeAsUser();
      if (currentUser == null) {
        return;
      }
      await initChatSDK(currentUser);
    }
  }

  Future loadAllContactsGroup() async {
    try {
      final list = await ChatClient.getInstance.contactManager
          .getAllContactsFromServer();
      print('Loaded contacts  = ${list.length}');
    } catch (e) {
      print('error contacts  = $e');
    }
    try {
      final list =
          await ChatClient.getInstance.groupManager.fetchJoinedGroupsFromServer(
        needMemberCount: true,
        needRole: true,
      );
      print('Loaded groups  = ${list.length}');
    } catch (e) {
      print('error groups  = $e');
    }
  }

  Future initChatSDK(User currentUser) async {
    // _ref = ref;
    print('initChatSDK $_initialized');
    if (_initialized) {
      return;
    }
    _initialized = true;
    print('_initialized');

    // User? currentUser = await getMeAsUser();
    // if (currentUser == null) {
    //   return;
    // }

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
          await pref.setString('chat_body', jsonEncode(token.body!));
        } else {
          keyBody = token.body!;
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
    // ${oldChatBody.toString()}
    ChatOptions options = ChatOptions(
      appKey: keyBody.appKey,
      autoLogin: false,
      acceptInvitationAlways: false,
      deleteMessagesAsExitGroup: false,
      requireAck: true,
      requireDeliveryAck: true,
    );

    // if (Platform.isIOS) {
    //   String? aPNStoken = await FirebaseMessaging.instance.getAPNSToken();
    //   if (aPNStoken != null) {
    //     options.enableAPNs(aPNStoken);
    //   }
    //   // options.enableAPNs(certName)
    // }

    options.enableFCM(DefaultFirebaseOptions.currentPlatform.appId);
    await ChatClient.getInstance.init(options);
    // showLoading(ref);
    bool alreadyLoggedIn = await ChatClient.getInstance.isConnected();

    if (alreadyLoggedIn) {
      if (!shouldLogin) {
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

  // void registerForPresence() {
  //   ChatClient.getInstance.presenceManager.addEventHandler(
  //     "user_presence_home_screen",
  //     ChatPresenceEventHandler(
  //       onPresenceStatusChanged: (list) {
  //         _ref?.read(chatConversationListProvider.notifier).updateStatus(list);
  //       },
  //     ),
  //   );
  // }

  // Future updateOnlineStatus(){

  // }
  // void reloadOnlyConversation(WidgetRef ref, ConversationModel m) async {
  //   ConversationModel model = ConversationModel(
  //       id: m.id,
  //       badgeCount: await m.conversation?.unreadCount() ?? 0,
  //       contact: m.contact,
  //       conversation: m.conversation,
  //       lastMessage: await m.conversation?.latestMessage(),
  //       isOnline: null //await fetchOnlineStatus(m.contact.userId.toString()
  //       );
  //   // conversations.add(model);
  //   try {
  //     ref.read(chatConversationListProvider.notifier).update(model);
  //   } catch (e) {
  //     print('error while adding to conversations : $e');
  //   }
  // }

  // void reloadConversation(WidgetRef ref, {bool reloadContacts = false}) async {
  //   final data = ref.read(chatConversationListProvider);
  //   if (data.isNotEmpty == true && !reloadContacts) {
  //     List<ConversationModel> conversations = [];
  //     for (var m in data) {
  //       final lastMessage = await m.conversation?.latestMessage();
  //       ConversationModel model = ConversationModel(
  //           id: m.id,
  //           badgeCount: await m.conversation?.unreadCount() ?? 0,
  //           contact: m.contact,
  //           conversation: m.conversation,
  //           lastMessage: lastMessage,
  //           isOnline:
  //               null //await BChatContactManager.fetchOnlineStatus(m.contact.userId.toString())
  //           );
  //       conversations.add(model);
  //     }

  //     if (conversations.isNotEmpty) {
  //       conversations.sort((a, b) => (b.lastMessage?.serverTime ?? 0)
  //           .compareTo(a.lastMessage?.serverTime ?? 1));
  //       try {
  //         ref
  //             .read(chatConversationListProvider.notifier)
  //             .addConversations(conversations);
  //       } catch (e) {
  //         print('error while adding to conversations : $e');
  //       }
  //     }
  //   } else {
  //     await loadConversations(ref);
  //   }
  // }

  // Future loadConversations(WidgetRef ref) async {
  //   List<ConversationModel> conversations = [];

  //   print('Start Loading conversations');
  //   try {
  //     conversations =
  //         await ref.read(bChatSDKProvider).loadContactsConversationsList();
  //     // shouldLoadRemote = false;
  //     print('conversations : ${conversations.length}');
  //     // conversations = ref
  //     //     .watch(bChatConvListProvider)
  //     //     .maybeWhen(data: (data) => data, orElse: () => []);
  //     // final response =
  //     //     await BChatApiService.instance.getContacts(_currentUser.authToken);
  //     // List<Contacts>? contacts = response.body?.contacts;
  //     // List<ChatConversation> list =
  //     //     await ChatClient.getInstance.chatManager.loadAllConversations();

  //     // if (contacts?.isNotEmpty == true) {
  //     //   print('contacts size =${contacts!.length}');
  //     //   if (list.isEmpty) {
  //     //     try {
  //     //       list = await ChatClient.getInstance.chatManager
  //     //           .getConversationsFromServer();
  //     //     } on ChatError catch (e) {
  //     //       print('Error while fetching conversations from Server: $e');
  //     //     }
  //     //   }

  //     //   final chatManager = ChatClient.getInstance.chatManager;
  //     //   final ids = contacts.map((e) => e.userId.toString()).toList();
  //     //   // final List<ChatPresence> onlineUsers =
  //     //   //     await BChatContactManager.fetchOnlineStatuses(ids);

  //     //   await ChatClient.getInstance.presenceManager.fetchPresenceStatus(
  //     //       members: contacts.map((e) => e.userId.toString()).toList());
  //     //   for (var cont in contacts) {
  //     //     print('${cont.name} - ${cont.userId}');
  //     //     final conv = await chatManager.getConversation(cont.userId.toString(),
  //     //         type: ChatConversationType.Chat);
  //     //     // final online = onlineUsers.firstWhereOrNull(
  //     //     //     (element) => element.publisher == cont.userId.toString());
  //     //     // final state = onlineUsers.retainWhere((e) => e.publisher== cont.peerId);
  //     //     print('Conversation is ${(conv == null) ? '' : 'Not'} Null');

  //     //     if (conv == null) continue;
  //     //     final lastMessage = await conv.latestMessage();
  //     //     if (lastMessage == null) continue;

  //     //     ConversationModel model = ConversationModel(
  //     //         id: cont.userId.toString(),
  //     //         badgeCount: await conv.unreadCount(),
  //     //         contact: cont,
  //     //         conversation: conv,
  //     //         lastMessage: lastMessage,
  //     //         isOnline: null); // online);
  //     //     conversations.add(model);
  //     //   }
  //     // } else {
  //     //   print('contacts list is empty');
  //     //   if (list.isNotEmpty) {
  //     //     // Found some conversations
  //     //   }
  //     // }
  //   } catch (e) {
  //     print('errorconversations : $e');
  //     // recall failed, code: e.code, reason: e.description
  //   }
  //   if (conversations.isNotEmpty) {
  //     conversations.sort((a, b) => (b.lastMessage?.serverTime ?? 1)
  //         .compareTo(a.lastMessage?.serverTime ?? 0));
  //     try {
  //       ref
  //           .read(chatConversationListProvider.notifier)
  //           .addConversations(conversations);
  //     } catch (e) {
  //       print('error while adding to conversations : $e');
  //     }
  //   }
  //   ref.read(loadingChatProvider.notifier).state = false;
  //   // hideLoading(_ref!);
  // }

  void signOut() async {
    try {
      await ChatClient.getInstance.logout(false);
    } on ChatError catch (_) {}
  }

  Future signOutAsync() async {
    try {
      await ChatClient.getInstance.logout(true);
    } on ChatError catch (_) {}
  }
}
