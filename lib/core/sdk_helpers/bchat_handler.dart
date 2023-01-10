// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../state.dart';
import '/controller/providers/bchat/chat_conversation_provider.dart';
import '/core/utils/notification_controller.dart';

registerForContact(String key, WidgetRef? ref) {
  try {
    print('Registering $key');
    // ignore: deprecated_member_use
    // ChatClient.getInstance.contactManager.addContactManagerListener(Listern());
    ChatClient.getInstance.contactManager.addEventHandler(
      key,
      ContactEventHandler(
        onContactInvited: (userId, reason) {
          //
          print('Invited: $userId - $reason');
          // EasyLoading.showInfo('Invited: $userId - $reason');
          NotificationController.showContactInviteNotification(
              userId, reason ?? 'New Invitation');
        },
        onContactAdded: (userId) async {
          //
          print('Added: $userId ');
          final result =
              await ref?.read(chatConversationProvider).addContact(userId);
          if (result != null) {
            NotificationController.showContactActionNotification(
                userId, 'bVidya', 'New Contact ${result.name} added');
          } else {
            NotificationController.showContactActionNotification(
                userId, 'bVidya', 'New Contact added');
          }
          // EasyLoading.showInfo('Added: $userId ');
        },
        onContactDeleted: (userId) async {
          //
          print('Deleted: $userId ');
          final result =
              await ref?.read(chatConversationProvider).removedContact(int.tryParse(userId)??-1);
          if (result != null) {
            NotificationController.showContactActionNotification(
                userId, 'bVidya', 'Contact ${result.name} deleted');
          } else {
            NotificationController.showContactActionNotification(
                userId, 'bVidya', 'Contact delete');
          }
          // EasyLoading.showInfo('Deleted: $userId ');
        },
        onFriendRequestAccepted: (userId) {
          //
          print('Acceped: $userId ');

          // EasyLoading.showInfo('Acceped: $userId ');
          NotificationController.showContactActionNotification(
              userId, 'bVidya', 'Connection request accepted');
        },
        onFriendRequestDeclined: (userId) {
          //

          // EasyLoading.showInfo('Declined: $userId ');
          NotificationController.showContactActionNotification(
              userId, 'bVidya', 'Connection request declined');
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
    ChatClient.getInstance.chatManager.addEventHandler(key,
        ChatEventHandler(onMessagesReceived: (msgs) => onNewMessages(msgs)));
  } on ChatError catch (e) {
    print('Error ${e.code} - ${e.description}');
  } catch (_) {}
}

unregisterForNewMessage(String key) {
  try {
    ChatClient.getInstance.chatManager.removeEventHandler(key);
  } catch (_) {}
}
