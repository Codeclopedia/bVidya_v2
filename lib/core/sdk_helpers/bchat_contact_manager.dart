// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/data/services/push_api_service.dart';
import '../../data/models/models.dart';
import '../utils.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/core/constants/agora_config.dart';
import '/ui/base_back_screen.dart';
import '/core/utils/request_utils.dart';
// import '/data/services/fcm_api_service.dart';

import '/controller/bchat_providers.dart';
import '../state.dart';
import '../ui_core.dart';
// import '../utils/chat_utils.dart';

class BChatContactManager {
  BChatContactManager._();

  static Future<List<String>> getChatConversationsIds() async {
    try {
      // final values =
      //     await ChatClient.getInstance.userInfoManager.fetchUserInfoById(['3']);
      // values.forEach((key, value) {
      //   value.
      // });
      var list =
          await ChatClient.getInstance.chatManager.loadAllConversations();
      return list
          .where((element) => element.type == ChatConversationType.Chat)
          .map((e) => e.id)
          .toList();
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
    } catch (e) {
      print('error: $e');
    }
    return [];
  }

  static Future<List<ChatConversation>> getGroupChatConversations() async {
    try {
      var list =
          await ChatClient.getInstance.chatManager.loadAllConversations();
      return list
          .where((element) => element.type == ChatConversationType.GroupChat)
          .toList();
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
    } catch (e) {
      print('error: $e');
    }
    return [];
  }

  static Future<List<String>> getContactList({bool fromServer = false}) async {
    try {
      var list =
          await ChatClient.getInstance.contactManager.getAllContactsFromDB();
      if (list.isEmpty || fromServer) {
        try {
          list = await ChatClient.getInstance.contactManager
              .getAllContactsFromServer();
        } catch (e) {
          //Avoid limitation error
        }
      }
      if (!list.contains(AgoraConfig.bViydaAdmitUserId.toString())) {
        list.add(AgoraConfig.bViydaAdmitUserId.toString().toString());
      }
      // print('List-> $list');
      return list;
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
    } catch (e) {
      print('error: $e');
    }
    return [];
  }

  static Future updatePin(
      WidgetRef ref, String userId, bool isUserPinned) async {
    showLoading(ref);
    final error = await ref.read(bChatProvider).pinUnpinContact(userId);
    // final updatedPinnedvalue = await getUpdatedPinned(userId);

    if (error == null) {
      hideLoading(ref);
      ref
          .read(chatConversationProvider.notifier)
          .updateConversationPin(userId, isUserPinned);
      EasyLoading.showToast(
          isUserPinned == true
              ? S.current.bchat_conv_pinned
              : S.current.bchat_conv_unpinned,
          toastPosition: EasyLoadingToastPosition.bottom);
    } else {
      hideLoading(ref);
      EasyLoading.showError('Error $error');
    }
  }

  // static Future<bool> getUpdatedPinned(String userId) async {
  //   final contactData = await getConversationModel(userId);

  //   if (contactData?.contact.ispinned ?? false) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // static Future<bool> isUserPinned(String userId) async {
  //   final contactData = await getConversationModel(userId);
  //   print("is contact pinned ${contactData?.contact.ispinned}");
  //   if (contactData?.contact.ispinned ?? false) {
  //     return true;
  //   } else {
  //     // if ((await getBlockList(fromServer: true)).contains(userId)) {
  //     //   return true;
  //     // }
  //     return false;
  //   }
  // }

  static Future<String> getContacts({bool fromServer = false}) async {
    try {
      final list = await getContactList(fromServer: fromServer);
      if (list.isEmpty) {
        return '';
      }
      String ids = list.join(',');
      // print('id: $ids');
      return ids;
    } catch (e) {
      print('error: $e');
    }
    return '';
  }

  static Future<List<String>> getBlockList({bool fromServer = false}) async {
    try {
      var list =
          await ChatClient.getInstance.contactManager.getBlockListFromDB();
      if (list.isEmpty || fromServer) {
        list = await ChatClient.getInstance.contactManager
            .getBlockListFromServer();
      }
      return list;
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
    } catch (e) {
      print('error: $e');
    }
    return [];
  }

  static Future<String> getBlockUsers({bool fromServer = false}) async {
    try {
      final list = await getBlockList(fromServer: fromServer);
      if (list.isEmpty) {
        return '';
      }
      String ids = list.join(',');
      // print('id: $ids');
      return ids;
    } catch (e) {
      print('error: $e');
    }
    return '';
  }

  static Future sendRequestResponse(WidgetRef ref, String contactId, bool isIos,
      String? fcmToken, ContactAction action) async {
    User? me = await getMeAsUser();
    if (me != null) {
      String title;
      String message;
      if (action == ContactAction.acceptRequest) {
        title = '${me.name} has accepted your request';
        message = 'Start talking with ${me.name}';
        await acceptRequest(contactId);
      } else if (action == ContactAction.declineRequest) {
        title = 'bvidya';
        message = '${me.name} declined your request';
        await declineRequest(contactId);
      } else if (action == ContactAction.deleteContact) {
        await BChatContactManager.deleteContact(contactId);
        if (fcmToken != null) {
          // await FCMApiService.instance
          await PushApiService.instance.pushContactDeleteAlert(
              me.authToken, isIos, fcmToken, me.id.toString(), contactId);
        }
        return;
      } else {
        // title = 'Contact removed';
        return;
      }
      if (fcmToken != null) {
        // await FCMApiService.instance
        await PushApiService.instance.pushContactAlert(
          me.authToken,
          isIos,
          fcmToken,
          me.id.toString(),
          contactId,
          title,
          message,
          action,
        );
      }
    }
  }

  static Future<String?> sendRequestToAddContact(
    String contactId,
    String message,
  ) async {
    try {
      if (!AgoraConfig.autoAcceptContact) {
        // List<String> sentRequestList =
        //     await ContactRequestHelper.getSendRequestList();
        // if (sentRequestList.contains(contactId)) {
        //   return 'Already sent request';
        // }
      }

      List<String> list = await getContactList(fromServer: false);
      // print('before list : ${list.join(',')}');
      if (list.contains(contactId)) {
        return 'Already exists';
      } else {
        list = await getContactList(fromServer: true);
        // print('before x list : ${list.join(',')}');
        if (list.contains(contactId)) {
          return 'Already exists';
        }

        if (AgoraConfig.autoAcceptContact) {
          await ChatClient.getInstance.contactManager.addContact(contactId);
        } else {
          await ChatClient.getInstance.contactManager
              .addContact(contactId, reason: message);
          await ContactRequestHelper.addSentRequest(contactId);
        }
        // final updatedList = await getContactList(fromServer: true);
        // print('after list : ${updatedList.join(',')}');
        return null;
      }
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
      return 'chatError: ${e.code}- ${e.description}';
    } catch (e) {
      print('error: $e');
      return 'Error : $e';
    }
  }

  static Future changeChatMuteStateFor(String userId, bool mute) async {
    try {
      final chatparam = ChatSilentModeParam.remindType(
          mute ? ChatPushRemindType.ALL : ChatPushRemindType.NONE);
      await ChatClient.getInstance.pushManager.setConversationSilentMode(
        conversationId: userId,
        param: chatparam,
        type: ChatConversationType.Chat,
      );
      // return result.remindType ?? ChatPushRemindType.ALL;
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
  }

  // static Future<ChatPushRemindType> fetchChatMuteStateFor(String userId) async {
  //   try {
  //     final result = await ChatClient.getInstance.pushManager
  //         .fetchConversationSilentMode(
  //             conversationId: userId, type: ChatConversationType.Chat);
  //     ChatPushRemindType? remindType = result.remindType;
  //     print('mute style  ${remindType?.name ?? 'UNKNOWN'}');
  //     return remindType ?? ChatPushRemindType.ALL;
  //   } on ChatError catch (e) {
  //     print('Error: ${e.code}- ${e.description} ');
  //   } catch (e) {
  //     print('Error2: ${e} ');
  //   }
  //   return ChatPushRemindType.ALL;
  // }

  static Future<bool> isMuteChatMuteStateFor(String userId) async {
    try {
      final result = await ChatClient.getInstance.pushManager
          .fetchConversationSilentMode(
              conversationId: userId, type: ChatConversationType.Chat);
      ChatPushRemindType? remindType = result.remindType;
      print('mute style of user:$userId is ${remindType?.name ?? 'UNKNOWN'}');
      return (remindType != ChatPushRemindType.NONE);
    } on ChatError catch (e) {
      print('Error: ${e.code}- ${e.description} ');
    } catch (e) {
      print('Error2: ${e} ');
    }
    return false;
  }

  static Future<String?> blockUser(String userId) async {
    try {
      if (await isUserBlocked(userId)) {
        return 'Already Blocked';
      } else {
        await ChatClient.getInstance.contactManager.addUserToBlockList(userId);
        return null;
      }
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
      return 'chatError: ${e.code}- ${e.description}';
    } catch (e) {
      print('error: $e');
      return 'Error : $e';
    }
  }

  static Future<String?> unBlockUser(String userId) async {
    try {
      if (await isUserBlocked(userId)) {
        await ChatClient.getInstance.contactManager
            .removeUserFromBlockList(userId);
      } else {
        return 'Not Blocked';
      }
    } on ChatError catch (e) {
      print('chatError: ${e.code}- ${e.description}');
      return 'chatError: ${e.code}- ${e.description}';
    } catch (e) {
      print('error: $e');
      return 'Error : $e';
    }
  }

  static Future<bool> isUserBlocked(String userId) async {
    final list = await getBlockList(fromServer: false);
    if (list.contains(userId)) {
      return true;
    } else {
      if ((await getBlockList(fromServer: true)).contains(userId)) {
        return true;
      }
      return false;
    }
  }

  static Future<List<ChatMediaFile>> loadMediaFiles(String convId) async {
    final List<ChatMediaFile> items = [];
    try {
      ChatConversation? conv =
          await ChatClient.getInstance.chatManager.getConversation(convId);

      final images =
          (await conv?.loadMessagesWithMsgType(type: MessageType.IMAGE)) ?? [];
      if (images.isNotEmpty) {
        for (var f in images) {
          final body = f.body;
          items.add(ChatMediaFile(f.msgId, body, MessageType.IMAGE));
        }
      }
      final videos =
          (await conv?.loadMessagesWithMsgType(type: MessageType.VIDEO)) ?? [];
      if (videos.isNotEmpty) {
        for (var f in videos) {
          final body = f.body;
          items.add(ChatMediaFile(f.msgId, body, MessageType.VIDEO));
        }
      }
      final voices =
          (await conv?.loadMessagesWithMsgType(type: MessageType.VOICE)) ?? [];
      if (voices.isNotEmpty) {
        for (var f in voices) {
          final body = f.body;
          items.add(ChatMediaFile(f.msgId, body, MessageType.VOICE));
        }
      }
      final file =
          (await conv?.loadMessagesWithMsgType(type: MessageType.FILE)) ?? [];
      if (file.isNotEmpty) {
        for (var f in file) {
          final body = f.body;
          items.add(ChatMediaFile(f.msgId, body, MessageType.FILE));
        }
      }
    } catch (_) {}
    return items;
  }

  static Future acceptRequest(String from) async {
    try {
      await ChatClient.getInstance.contactManager.acceptInvitation(from);
    } catch (_) {}
  }

  static Future declineRequest(String from) async {
    try {
      await ChatClient.getInstance.contactManager.declineInvitation(from);
    } catch (_) {}
  }

  static Future deleteContact(String userId) async {
    try {
      await ChatClient.getInstance.contactManager
          .deleteContact(userId, keepConversation: false);
    } catch (_) {}
  }
}

class ChatMediaFile {
  final String msgId;
  final ChatMessageBody body;
  final MessageType type;

  ChatMediaFile(this.msgId, this.body, this.type);
}
