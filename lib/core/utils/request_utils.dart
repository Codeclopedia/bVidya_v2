import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../state.dart';
import '../ui_core.dart';
import '/controller/providers/bchat/contact_list_provider.dart';
import '/data/models/contact_model.dart';
import '/controller/providers/bchat/chat_conversation_list_provider.dart';
import 'notification_controller.dart';

class ContactRequestHelper {
  ContactRequestHelper._();
  static Future handleNotification(RemoteNotification? notification,
      ContactAction action, String fromId, bool foreground,
      {WidgetRef? ref}) async {
    // print('Action  $action');
    switch (action) {
      case ContactAction.sendRequestContact:
        await ContactRequestHelper.addNewRequest(fromId);
        if (foreground) {
          final contact = await ref
              ?.read(contactListProvider.notifier)
              .addContact(int.parse(fromId), ContactStatus.invited);
          if (contact != null) {
            ref
                ?.read(chatConversationProvider.notifier)
                .addConversationByContact(contact);
            if (ref != null) {
              NotificationController.showNewInvitation(fromId, contact,
                  notification?.title ?? '', notification?.body ?? '', ref);
            }
          }
        }
        break;
      case ContactAction.acceptRequest:
        await ContactRequestHelper.removeFromSendList(fromId);
        if (foreground) {
          final contact = await ref
              ?.read(contactListProvider.notifier)
              .addContact(int.parse(fromId), ContactStatus.friend);
          if (contact != null) {
            ref
                ?.read(chatConversationProvider.notifier)
                .addConversationByContact(contact);
            if (notification != null) {
              NotificationController.showContactActionNotification(
                  fromId,
                  notification.title ?? '',
                  notification.body ?? '',
                  Colors.green);
            }
          }
        }
        break;
      case ContactAction.declineRequest:
        await ContactRequestHelper.removeFromSendList(fromId);
        if (foreground) {
          ref
              ?.read(contactListProvider.notifier)
              .removeContact(int.parse(fromId));
          ref
              ?.read(chatConversationProvider.notifier)
              .removeConversation(fromId);
          NotificationController.showContactActionNotification(fromId,
              notification?.title ?? '', notification?.body ?? '', Colors.red);
        }
        break;
      case ContactAction.deleteContact:
        if (foreground) {
          ref
              ?.read(contactListProvider.notifier)
              .removeContact(int.parse(fromId));
          ref
              ?.read(chatConversationProvider.notifier)
              .removeConversation(fromId);
          if (notification != null) {
            NotificationController.showContactActionNotification(fromId,
                notification.title ?? '', notification.body ?? '', Colors.blue);
          }
        }

        break;
      default:
    }
  }

  static Future addNewRequest(String fId) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('request_ids') ?? [];
    if (!list.contains(fId)) {
      list.add(fId);
      await pref.setStringList('request_ids', list);
    }
  }

  static Future<List<String>> getRequestList() async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('request_ids');
    return list ?? [];
  }

  static Future removeFromList(String fId) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('request_ids');
    if (list?.isNotEmpty == true && list!.contains(fId)) {
      list.remove(fId);
      await pref.setStringList('request_ids', list);
    }
  }

  static Future addSentRequest(String fId) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('sent_request_ids') ?? [];
    if (!list.contains(fId)) {
      list.add(fId);
      await pref.setStringList('sent_request_ids', list);
    }
  }

  static Future<List<String>> getSendRequestList() async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('sent_request_ids');
    return list ?? [];
  }

  static Future removeFromSendList(String fId) async {
    final pref = await SharedPreferences.getInstance();
    final list = pref.getStringList('sent_request_ids');
    if (list?.isNotEmpty == true && list!.contains(fId)) {
      list.remove(fId);
      await pref.setStringList('sent_request_ids', list);
    }
  }
}

enum ContactAction {
  sendRequestContact,
  acceptRequest,
  declineRequest,
  deleteContact;
}

ContactAction? contactActionFrom(String? name) {
  if (name == null) return null;
  if (name == ContactAction.acceptRequest.name) {
    return ContactAction.acceptRequest;
  }
  if (name == ContactAction.declineRequest.name) {
    return ContactAction.declineRequest;
  }
  if (name == ContactAction.deleteContact.name) {
    return ContactAction.deleteContact;
  }
  if (name == ContactAction.sendRequestContact.name) {
    return ContactAction.sendRequestContact;
  }
  return null;
}
