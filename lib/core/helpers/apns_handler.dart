// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'dart:io';

import 'package:flutter/services.dart';
import '../constants/route_list.dart';
import '../ui_core.dart';
import '../utils/chat_utils.dart';

class ApnsRemoteMessage {
  final Map<String, dynamic> data;
  ApnsRemoteMessage.fromMap(this.data);
}

typedef ApnsMessageHandler = Function(ApnsRemoteMessage);
typedef ApnsBackgroundMessageHandler = Future<void> Function(
    ApnsRemoteMessage message);

class ApnsPushConnectorOnly {
  static ApnsPushConnectorOnly instance = ApnsPushConnectorOnly._();

  final MethodChannel _channel = const MethodChannel('notification_plugin');
  final MethodChannel _channelBack =
      const MethodChannel('notification_plugin_bg');

  static ApnsBackgroundMessageHandler? _onBackgroundMessage;
  ApnsMessageHandler? _onMessage;
  ApnsMessageHandler? _onMessageTap;

  ApnsPushConnectorOnly._();

  static void configure(
    ApnsBackgroundMessageHandler? onBackgroundMessage,
  ) {
    if (!Platform.isIOS) {
      return;
    }
    _onBackgroundMessage = onBackgroundMessage;
    instance._channelBack
        .setMethodCallHandler(instance._handleBackgroundMethod);
  }

  void configureApns({
    ApnsMessageHandler? onMessage,
    ApnsMessageHandler? onMessageTap,
  }) {
    if (!Platform.isIOS) {
      return;
    }
    _onMessage = onMessage;
    _onMessageTap = onMessageTap;
    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onMessage':
        return await _onMessage?.call(_extractMessage(call));
      case 'onMessageTap':
        return await _onMessageTap?.call(_extractMessage(call));

      default:
    }
  }

  @pragma('vm:entry-point')
  Future<dynamic> _handleBackgroundMethod(MethodCall call) async {
    switch (call.method) {
      case 'onBackgroundMessage':
        return _onBackgroundMessage?.call(_extractMessage(call));
      default:
    }
  }

  ApnsRemoteMessage _extractMessage(MethodCall call) {
    final map = call.arguments as Map;

    return ApnsRemoteMessage.fromMap(map.cast());
  }

  Future<ApnsRemoteMessage?> loadLaunchMessage() async {
    if (!Platform.isIOS) {
      return null;
    }
    try {
      final map = await _channel.invokeMethod('getLaunchMessage');
      if (map != null && map is Map) {
        // print('Initial message=> $map');
        return ApnsRemoteMessage.fromMap(map.cast());
      }
    } on PlatformException catch (e) {
      print('Error loading message: $e');
    }
    return null;
  }

  static Future<bool> onMessageOpen(
      ApnsRemoteMessage message, BuildContext context) async {
    // print('onMessageOpen=> ${message.data} ');
    if (message.data.isNotEmpty && message.data['e'] != null) {
      final extra = message.data['e'];
      String? type = extra['type'];
      if (type == 'chat') {
        String? fromId = message.data['f']?.toString();
        if (fromId != null) {
          final model = await getConversationModel(fromId);
          if (model != null) {
            await Navigator.pushReplacementNamed(
                context, RouteList.chatScreenDirect,
                arguments: model);
            return true;
          }
        }
      } else if (type == 'group_chat') {
        String? groupId = message.data['g']?.toString();
        if (groupId != null) {
          final model = await getGroupConversationModel(groupId);
          if (model != null) {
            await Navigator.pushReplacementNamed(
                context, RouteList.groupChatScreenDirect,
                arguments: model);
            return true;
          }
        }
      }
    }
    return false;
  }
}
