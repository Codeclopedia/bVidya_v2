// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import '/controller/providers/bchat/call_list_provider.dart';
import '/data/models/conversation_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../sdk_helpers/bchat_call_manager.dart';
import '../state.dart';
import '/app.dart';
import '/data/models/call_message_body.dart';
import '/data/models/response/bchat/p2p_call_response.dart';
import '../constants/route_list.dart';
import '../routes.dart';
import '../ui_core.dart';
import '../utils/callkit_utils.dart';
import '../utils/chat_utils.dart';
import 'call_helper.dart';

class ForegroundMessageHelper {
  static void handleChatNotification(
      ConversationModel model, ChatMessage msg) async {
    String name = model.contact.name;
    // String image = model.contact.profileImage;
    String from = model.id;
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      String contentText = '';
      switch (msg.body.type) {
        case MessageType.TXT:
          contentText = (msg.body as ChatTextMessageBody).content;
          break;
        case MessageType.CUSTOM:
          return;
        default:
          contentText = msg.body.type.name;
          break;
      }
      bool showForegroudNotification = false;

      showForegroudNotification = !Routes.isChatScreen(from.toString());
      String content = '$name sent you \n$contentText';

      if (showForegroudNotification) {
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.info(
            message: content,
          ),
          onTap: () {
            handleChatNotificationAction({
              'type': 'chat',
              'from': from.toString(),
            }, context, false);
          },
        );
        return;
      }
    }
  }

  static void handleGroupChatNotification(
      GroupConversationModel model, ChatMessage msg) async {
    String name = model.groupInfo.name ?? 'Group';
    // String image = model.contact.profileImage;
    String from = model.id;
    BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      String contentText = '';
      switch (msg.body.type) {
        case MessageType.TXT:
          contentText = (msg.body as ChatTextMessageBody).content;
          break;
        case MessageType.CUSTOM:
          return;
        default:
          contentText = msg.body.type.name;
          break;
      }
      bool showForegroudNotification = false;

      showForegroudNotification = !Routes.isGroupChatScreen(from.toString());
      String content = '$name sent you \n$contentText';

      if (showForegroudNotification) {
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.info(
            message: content,
          ),
          onTap: () {
            handleChatNotificationAction({
              'type': 'group_chat',
              'from': from.toString(),
            }, context, false);
          },
        );
        return;
      }
    }
  }

  static void handleCallNotification(ChatMessage msg, WidgetRef ref) async {
    try {
      final diff = DateTime.now().millisecondsSinceEpoch - msg.serverTime;

      print(
          'messege time foreground $diff ms    ${msg.serverTime}  ${DateTime.now().millisecondsSinceEpoch}');
      if (diff > 30000) return;
      final body = CallMessegeBody.fromJson(
          jsonDecode((msg.body as ChatCustomMessageBody).event));
      CallBody callBody = CallBody.fromJson(jsonDecode(body.ext['call_body']));
      if (callBody.callId == lastCallId) {
        return;
      }

      String fromId = msg.from!;
      String fromName = body.fromName;
      String fromFCM = body.ext['fcm'];
      String image = body.image ?? '';
      bool hasVideo = body.callType == CallType.video;
      // print('${body.toJson()}');
      await showIncomingCallScreen(
          callBody, fromName, fromId, fromFCM, image, hasVideo);
      CallListModel model = CallListModel(
          fromName, image, true, DateTime.now().millisecondsSinceEpoch, body);
      ref.read(callListProvider.notifier).addCall(model);
    } catch (e) {}
  }

  static Future<bool> handleChatNotificationAction(
      Map<String, String?> message, BuildContext context, bool replace) async {
    String? type = message['type'];
    try {
      if (type == 'chat') {
        String? from = message['from'];
        final model = await getConversationModel(from.toString());
        if (model != null) {
          if (replace) {
            await Navigator.pushReplacementNamed(
                context, RouteList.chatScreenDirect,
                arguments: model);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
              context,
              RouteList.chatScreenDirect,
              arguments: model,
              (route) => route.isFirst,
            );
          }
          return true;
        }
      } else if (type == 'group_chat') {
        String? from = message['from'];
        final model = await getGroupConversationModel(from.toString());
        if (model != null) {
          if (replace) {
            await Navigator.pushReplacementNamed(
                context, RouteList.groupChatScreenDirect,
                arguments: model);
          } else {
            await Navigator.pushNamedAndRemoveUntil(
              context,
              RouteList.groupChatScreenDirect,
              arguments: model,
              (route) => route.isFirst,
            );
          }
          return true;
        }
      }
    } catch (e) {}
    return false;
  }
}
