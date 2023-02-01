// ignore_for_file: avoid_print

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import '/controller/providers/bchat/chat_messeges_provider.dart';
import '/core/sdk_helpers/typing_helper.dart';
import '/data/models/models.dart';
import '/core/constants/agora_config.dart';

import '../state.dart';
import '/core/utils/notification_controller.dart';

String? lastUserId;
String? lastAction;

registerForContact(String key, WidgetRef? ref) {
  try {
    print('Registering $key');

    // ChatClient.getInstance.groupManager
    //     .addEventHandler('identifier', ChatGroupEventHandler(
    //     ));

    // ignore: deprecated_member_use
    // ChatClient.getInstance.contactManager.addContactManagerListener(Listern());
    ChatClient.getInstance.contactManager.addEventHandler(
      key,
      ContactEventHandler(
        onContactInvited: (userId, reason) async {
          //
          if (AgoraConfig.autoAcceptContact) {
            if (lastUserId == userId && lastAction == 'Add') {
              return;
            }
            lastUserId = userId;
            lastAction = 'Add';
            print('Added: $userId ');
            if (ref != null) {
              await addNewContactById(int.parse(userId), ref);
            }

            // await ref
            //     ?.read(chatConversationProvider)
            //     .addContact(userId, ContactStatus.invited);

            return;
          }

          if (lastUserId == userId && lastAction == 'Invite') {
            return;
          }
          print('Invited: $userId - $reason');
          lastUserId = userId;
          lastAction = 'Invite';

          // EasyLoading.showInfo('Invited: $userId - $reason');
          NotificationController.showContactInviteNotification(
              userId, reason ?? 'New Invitation');
        },
        onContactAdded: (userId) async {
          //
          if (lastUserId == userId && lastAction == 'Add') {
            return;
          }
          lastUserId = userId;
          lastAction = 'Add';
          print('Added: $userId ');
          Contacts? result;
          if (ref != null) {
            result = await addNewContactById(int.parse(userId), ref);
          }
          // final result = await ref
          //     ?.read(chatConversationProvider)
          //     .addContact(userId, ContactStatus.friend);
          if (AgoraConfig.autoAcceptContact) {
            return;
          }
          if (result != null) {
            NotificationController.showContactActionNotification(
                userId, 'bVidya', 'New Contact ${result.name} added');
          } else {
            // NotificationController.showContactActionNotification(
            //     userId, 'bVidya', 'New Contact added');
          }
          // EasyLoading.showInfo('Added: $userId ');
        },
        onContactDeleted: (userId) async {
          //
          if (lastUserId == userId && lastAction == 'Deleted') {
            return;
          }
          lastUserId = userId;
          lastAction = 'Deleted';
          print('Deleted: $userId ');
          Contacts? result;
          if (ref != null) {
            deleteContact(int.parse(userId), ref);
          }

          // final result = await ref
          //     ?.read(chatConversationProvider)
          //     .removedContact(int.tryParse(userId) ?? -1);
          if (result != null) {
            NotificationController.showContactActionNotification(
                userId, 'bVidya', 'Contact ${result.name} deleted');
          } else {
            // NotificationController.showContactActionNotification(
            //     userId, 'bVidya', 'Contact deleted');
          }
          // EasyLoading.showInfo('Deleted: $userId ');
        },
        onFriendRequestAccepted: (userId) {
          //
          if (AgoraConfig.autoAcceptContact) {
            return;
          }
          if (lastUserId == userId && lastAction == 'Acceped') {
            return;
          }
          lastUserId = userId;
          lastAction = 'Acceped';
          print('Acceped: $userId ');
          // EasyLoading.showInfo('Acceped: $userId ');
          NotificationController.showContactActionNotification(
              userId, 'bVidya', 'Connection request accepted');
        },
        onFriendRequestDeclined: (userId) {
          //
          if (AgoraConfig.autoAcceptContact) {
            return;
          }
          if (lastUserId == userId && lastAction == 'Declined') {
            return;
          }
          lastUserId = userId;
          lastAction = 'Declined';
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

registerGroupForNewMessage(
    String key,
    Function(List<ChatMessage>) onNewMessages,
    Function() onUpdate,
    Function(List<ChatCmdMessageBody>) onCmdMessage) {
  print('group registering $key');
  try {
    ChatClient.getInstance.chatManager.addEventHandler(
        key,
        ChatEventHandler(
          onMessagesReceived: (msgs) => onNewMessages(msgs),
          onCmdMessagesReceived: (messages) {
            List<ChatCmdMessageBody> bodies = [];
            for (var msg in messages) {
              if (msg.chatType == ChatType.GroupChat &&
                  msg.body.type == MessageType.CMD) {
                ChatCmdMessageBody body = msg.body as ChatCmdMessageBody;
                bodies.add(body);
              }
            }
            onCmdMessage(bodies);
          },
          onGroupMessageRead: (groupMessageAcks) {
            onUpdate();
          },
          onReadAckForGroupMessageUpdated: () {
            onUpdate();
          },
        ));
  } on ChatError catch (e) {
    print('Error ${e.code} - ${e.description}');
  } catch (_) {}
}

unregisterForNewMessage(String key) {
  try {
    ChatClient.getInstance.chatManager.removeEventHandler(key);
  } catch (_) {}
}

registerForGroup(String key) {
  try {
    ChatClient.getInstance.groupManager.addEventHandler(
        key,
        ChatGroupEventHandler(
          onUserRemovedFromGroup: (groupId, groupName) {},
          onGroupDestroyed: (groupId, groupName) {},
          onAdminAddedFromGroup: (groupId, admin) {},
          onMemberExitedFromGroup: (groupId, member) {},
        ));
  } catch (_) {}
}

unregisterForGroup(String key) {
  try {
    ChatClient.getInstance.groupManager.removeEventHandler(key);
  } catch (_) {}
}

unregisterChatCallback(String key) {
  try {
    ChatClient.getInstance.groupManager.removeEventHandler(key);
  } catch (_) {}
}

registerChatCallback(
    String key,
    ChatMessagesChangeProvider provider,
    Function(List<ChatMessage>) onNewMessages,
    Function(Map<String, TypingCommand>) onCmdMessage) {
  try {
    ChatClient.getInstance.chatManager.addEventHandler(
        key,
        ChatEventHandler(
          onCmdMessagesReceived: (messages) {
            Map<String, TypingCommand> bodies = {};
            for (var msg in messages) {
              if (msg.chatType == ChatType.Chat &&
                  msg.body.type == MessageType.CMD) {
                ChatCmdMessageBody body = msg.body as ChatCmdMessageBody;
                String content = body.action;
                if (content == TypingCommand.typingStart.name) {
                  bodies
                      .addAll({msg.from.toString(): TypingCommand.typingStart});
                }
              }
            }
            onCmdMessage(bodies);
          },
          onMessagesReceived: (messages) {
            provider.addChats(messages);
            onNewMessages(messages);
          },
          onMessagesDelivered: (messages) {
            provider.updateMessageDelivered(messages);
          },
          onMessagesRead: (messages) {
            provider.updateMessageRead(messages);
          },
        ));
  } catch (_) {}
}
