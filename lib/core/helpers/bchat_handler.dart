// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../state.dart';

registerForContact(String key, WidgetRef? ref) {
  try {
    print('Registering $key');

    ChatClient.getInstance.contactManager.addEventHandler(
      key,
      ContactEventHandler(
        onContactInvited: (userId, reason) {
          //
          print('Invited: $userId - $reason');
          EasyLoading.showInfo('Invited: $userId - $reason');
        },
        onContactAdded: (userId) {
          //
          print('Added: $userId ');
          EasyLoading.showInfo('Added: $userId ');
        },
        onContactDeleted: (userId) {
          //
          print('Deleted: $userId ');
          EasyLoading.showInfo('Deleted: $userId ');
        },
        onFriendRequestAccepted: (userId) {
          //
          print('Acceped: $userId ');
          EasyLoading.showInfo('Acceped: $userId ');
        },
        onFriendRequestDeclined: (userId) {
          //
          print('Declined: $userId ');
          EasyLoading.showInfo('Declined: $userId ');
        },
      ),
    );
  } on ChatError catch (e) {
    print('Error registerForContact ${e.code} - ${e.description}');
  } catch (e) {
    print('Error2 registerForContact $e');
  }
}

unregisterForContact(String key) {
  try {
    print('unregistering $key');
    ChatClient.getInstance.contactManager.removeEventHandler(key);
  } catch (_) {}
}

registerForNewMessage(String key, Function(List<ChatMessage>) onNewMessages) {
  try {
    ChatClient.getInstance.chatManager.addEventHandler(
      key,
      ChatEventHandler(
        onMessagesReceived: (msgs) {
          onNewMessages(msgs);
        },
      ),
    );
  } on ChatError catch (e) {
    print('Error ${e.code} - ${e.description}');
  } catch (_) {}
}

unregisterForNewMessage(String key) {
  try {
    ChatClient.getInstance.chatManager.removeEventHandler(key);
  } catch (_) {}
}
