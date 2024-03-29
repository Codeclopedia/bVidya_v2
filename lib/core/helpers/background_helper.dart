import 'dart:convert';

// import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// import '../utils/connectycubekit.dart';
import '/data/models/call_message_body.dart';
// import '../constants.dart';
// import '../ui_core.dart';
import '../utils/callkit_utils.dart';

// class BackgroundHelper {
//   BackgroundHelper._();
// static handleRemoteMessageBackground(RemoteMessage message) async {
//   if (message.data.isNotEmpty &&
//       message.data['alert'] != null &&
//       message.data['e'] != null) {
//     final extra = jsonDecode(message.data['e']);
//     String? type = extra['type'];
//     if (type == NotiConstants.typeCall) {
//       debugPrint('InComin call=>  ');
//       showCallingNotification(message.data, true);
//       return;
//     }
//     if (type == NotiConstants.typeGroupCall) {
//       debugPrint('InComin call=>  ');
//       showGroupCallingNotification(message.data, true);
//       return;
//     }
//   }
// }
// NotificationController.showErrorMessage('New Background : $extra');
// String? name = extra['name'];
// String? image = extra['image'];
// String? contentType = extra['content_type'];
// MessageType msgType = getType(contentType);
// dynamic from = message.data['f'];

// String? groupName;
// String? groupId;
// String contentText = '';
// String url;
// switch (msgType) {
//   case MessageType.CMD:
//   case MessageType.CUSTOM:
//     return;
//   case MessageType.TXT:
//     dynamic msgContent = extra['content'];
//     if (msgContent != null) {
//       contentText = msgContent.toString();
//     } else {
//       dynamic m = message.data['m'];
//       ChatMessage? msg = await ChatClient.getInstance.chatManager
//           .loadMessage(m.toString());
//       if (msg == null) {
//         contentText = 'Text message';
//       } else {
//         contentText = (msg.body as ChatTextMessageBody).content;
//       }
//     }

//     break;
//   case MessageType.IMAGE:
//     dynamic m = message.data['m'];
//     ChatMessage? msg = await ChatClient.getInstance.chatManager
//         .loadMessage(m.toString());
//     if (msg == null) {
//       contentText = 'New image file';
//       break;
//     }
//     final body = msg.body as ChatImageMessageBody;
//     url = body.remotePath ?? body.thumbnailRemotePath ?? '';
//     if (url.isNotEmpty) {
//       if (type == 'group_chat') {
//         groupName = extra['group_name'];
//         groupId = message.data['g'];
//         _showGroupMediaMessageNotification(
//             groupId!, name ?? '', groupName ?? 'Group', url, image!);
//       } else if (type == 'chat') {
//         _showMediaMessageNotification(from, name!, url, image!);
//       }
//       return;
//     }
//     contentText = 'New image file';
//     break;
//   default:
//     contentText = 'New ${msgType.name} file';
//     break;
// }
// //Show notification
// if (type == 'group_chat') {
//   groupName = extra['group_name'] ?? '';
//   groupId = message.data['g'] ?? '';
//   _showGroupTextMessageNotification(
//       groupId!, name!, groupName!, image!, contentText);
// } else if (type == 'chat') {
//   _showTextMessageNotification(from, name!, image!, contentText);
// }
//   }
// }

Future showCallingNotification(
    Map<String, dynamic> payload, bool background) async {
  try {
    // final diff = DateTime.now().millisecondsSinceEpoch -
    //     (message.sentTime?.millisecondsSinceEpoch ?? 0);
    // print(
    //     'messege time $diff ms    ${message.sentTime?.millisecondsSinceEpoch}  ${DateTime.now().millisecondsSinceEpoch}');
    print('payload ${payload}');
    final data = jsonDecode(payload['e']);

    // String? type = data['type'];
    // if (type != NotiConstants.typeCall) {
    //   return;
    // }

    final body = CallMessegeBody.fromJson(data);
    // final body = CallMessegeBody.fromJson(jsonDecode(data['content']));
    if (body.callId == lastCallId || body.callId == activeCallId) {
      return;
    }
    String fromId = payload['f'].toString();

    if (onGoingCallId != null) {
      if (onGoingCallId != body.callId) {
        await onDeclineCallBusy(body, fromId);
      }
      return;
    }
    await showIncomingCallScreen(body, fromId, background);
  } catch (e) {
    print('Error in call notification $e');
  }
}

showGroupCallingNotification(
    Map<String, dynamic> payload, bool background) async {
  //
  // dynamic mId = message.data['m'];
  try {
    // final diff = DateTime.now().millisecondsSinceEpoch -
    //     (message.sentTime?.millisecondsSinceEpoch ?? 0);
    // print(
    //     'messege time $diff ms    ${message.sentTime?.millisecondsSinceEpoch}  ${DateTime.now().millisecondsSinceEpoch}');

    final data = jsonDecode(payload['e']);
    final body = GroupCallMessegeBody.fromJson(data);
    if (body.callId == lastCallId || body.callId == activeCallId) {
      return;
    }
    String grpId = payload['g'].toString();
    String fromId = payload['f'].toString();

    if (onGoingCallId != null) {
      if (onGoingCallId != body.callId) {
        await onDeclineGrpCallBusy(fromId, grpId, body);
      }
      return;
    }
    await showIncomingGroupCallScreen(body, fromId, grpId, background);
  } catch (e) {
    // print('Error in call notification $e');
  }
}

  // static final Map<int, int> _messagePool = {};
  // static final Map<int, String> _messageBodyPool = {};

  // static void clearPool(int id) async {
  //   if (_messagePool.containsKey(id)) {
  //     _messagePool.remove(id);
  //     _messageBodyPool.remove(id);
  //     await AwesomeNotifications().cancel(id);
  //   }
  // }

  // static void clean() {}

  // static _showTextMessageNotification(
  //     String fromId, String fromName, String fromImage, String message) async {
  //   int id = fromId.hashCode;
  //   if (_messagePool.containsKey(id)) {
  //     _messageBodyPool.update(id, (value) => "$message <br/>$value");
  //     _messagePool.update(id, (value) {
  //       return value + 1;
  //     });
  //   } else {
  //     _messageBodyPool.putIfAbsent(id, () => message);
  //     _messagePool.putIfAbsent(id, () => 1);
  //   }
  //   String title = '$fromName sent you a message';
  //   String body = _messageBodyPool[id] ?? message;

  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'chat_channel',
  //       title: title,
  //       icon: 'resource://mipmap/ic_launcher',
  //       body: body,
  //       wakeUpScreen: true,
  //       fullScreenIntent: false,
  //       largeIcon: '$baseImageApi$fromImage',
  //       notificationLayout: NotificationLayout.BigText,
  //       payload: {
  //         'type': 'chat',
  //         'from': fromId,
  //       },
  //     ),
  //   );
  // }

  // static _showMediaMessageNotification(
  //     String fromId, String fromName, String url, String fromImage) {
  //   int id = (fromId + url).hashCode;

  //   String title = '$fromName sent you a photo';
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'chat_channel',
  //       title: title,
  //       icon: 'resource://mipmap/ic_launcher',
  //       body: 'New Photo',
  //       wakeUpScreen: true,
  //       fullScreenIntent: false,
  //       bigPicture: url,
  //       largeIcon: '$baseImageApi$fromImage',
  //       notificationLayout: NotificationLayout.BigPicture,
  //       payload: {
  //         'type': 'chat',
  //         'from': fromId,
  //       },
  //     ),
  //   );
  // }

  // static _showGroupTextMessageNotification(String groupId, String fromName,
  //     String groupName, String fromImage, String message) {
  //   int id = groupId.hashCode;
  //   if (_messagePool.containsKey(id)) {
  //     _messageBodyPool.update(id, (value) => "$message <br/>$value");
  //     _messagePool.update(id, (value) {
  //       return value + 1;
  //     });
  //   } else {
  //     _messageBodyPool.putIfAbsent(id, () => message);
  //     _messagePool.putIfAbsent(id, () => 1);
  //   }
  //   String body = _messageBodyPool[id] ?? message;

  //   String title = '$fromName sent you a message in $groupName';
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'chat_channel',
  //       title: title,
  //       icon: 'resource://mipmap/ic_launcher',
  //       body: body,
  //       largeIcon: '$baseImageApi$fromImage',
  //       wakeUpScreen: true,
  //       fullScreenIntent: false,
  //       notificationLayout: NotificationLayout.BigText,
  //       payload: {
  //         'type': 'group_chat',
  //         'from': groupId,
  //       },
  //     ),
  //   );
  // }

  // static _showGroupMediaMessageNotification(String groupId, String fromName,
  //     String groupName, String url, String fromImage) {
  //   int id = (groupId + url).hashCode;
  //   // if (_messagePool.containsKey(id)) {
  //   //   _messageBodyPool.update(id, (value) => "$message <br/>$value");
  //   //   _messagePool.update(id, (value) {
  //   //     return value + 1;
  //   //   });
  //   // } else {
  //   //   _messageBodyPool.putIfAbsent(id, () => message);
  //   //   _messagePool.putIfAbsent(id, () => 1);
  //   // }

  //   String title = '$fromName sent you a photo in $groupName';
  //   AwesomeNotifications().createNotification(
  //     content: NotificationContent(
  //       id: id,
  //       channelKey: 'chat_channel',
  //       title: title,
  //       icon: 'resource://mipmap/ic_launcher',
  //       body: 'New Photo',
  //       wakeUpScreen: true,
  //       fullScreenIntent: false,
  //       showWhen: true,
  //       bigPicture: url,
  //       largeIcon: '$baseImageApi$fromImage',
  //       notificationLayout: NotificationLayout.BigPicture,
  //       payload: {
  //         'type': 'group_chat',
  //         'from': groupId,
  //       },
  //     ),
  //   );
  // }

  // static MessageType getType(String? contentType) {
  //   if (contentType == MessageType.TXT.name) {
  //     return MessageType.TXT;
  //   }
  //   if (contentType == MessageType.FILE.name) {
  //     return MessageType.FILE;
  //   }

  //   if (contentType == MessageType.IMAGE.name) {
  //     return MessageType.IMAGE;
  //   }
  //   if (contentType == MessageType.VIDEO.name) {
  //     return MessageType.VIDEO;
  //   }
  //   if (contentType == MessageType.VIDEO.name) {
  //     return MessageType.VIDEO;
  //   }
  //   return MessageType.CUSTOM;
  // }
// }
