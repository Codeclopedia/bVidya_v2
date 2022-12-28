// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

Future<String> getContacts({bool fromServer = false}) async {
  try {
    final list = await getContactList(fromServer: fromServer);
    if (list.isEmpty) {
      return '';
    }
    String ids = list.join(',');
    print('id: $ids');
    return ids;
  } on ChatError catch (e) {
    print('chatError: ${e.code}- ${e.description}');
  } catch (e) {
    print('error: $e');
  }
  return '';
}

Future<List<String>> getContactList({bool fromServer = false}) async {
  try {
    var list =
        await ChatClient.getInstance.contactManager.getAllContactsFromDB();
    if (list.isEmpty || fromServer) {
      list = await ChatClient.getInstance.contactManager
          .getAllContactsFromServer();
    }
    return list;
  } on ChatError catch (e) {
    print('chatError: ${e.code}- ${e.description}');
  } catch (e) {
    print('error: $e');
  }
  return [];
}

Future<String?> sendRequestToAddContact(String contactId) async {
  try {
    final list = await getContactList();
    if (list.contains(contactId)) {
      return 'Already exists';
    } else {
      await ChatClient.getInstance.contactManager
          .addContact(contactId, reason: 'Hi,Please accept my invitation');
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

Future chageChatMuteStateFor(String userId, bool mute) async {
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

Future<ChatPushRemindType> fetchChatMuteStateFor(String userId) async {
  try {
    final result = await ChatClient.getInstance.pushManager
        .fetchConversationSilentMode(
            conversationId: userId, type: ChatConversationType.Chat);
    ChatPushRemindType? remindType = result.remindType;
    print('mute style  ${remindType?.name ?? 'UNKNOWN'}');
    return remindType ?? ChatPushRemindType.ALL;
  } on ChatError catch (e) {
    print('Error: ${e.code}- ${e.description} ');
  } catch (e) {
    print('Error2: ${e} ');
  }
  return ChatPushRemindType.ALL;
}
