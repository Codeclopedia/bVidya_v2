import 'package:agora_chat_sdk/agora_chat_sdk.dart';
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import '/core/helpers/bchat_contact_manager.dart';
import '../models/models.dart';
import '../services/bchat_api_service.dart';

class BChatSDKRepository {
  static const successfull = 'success';

  final BChatApiService api;
  final String token;
  final ChatClient _client; // = ChatClient.getInstance;

  BChatSDKRepository(this.api, this.token) : _client = ChatClient.getInstance;

  Future<List<ConversationModel>> loadContactsConversationsList(
      {bool firstTime = false}) async {
    List<ConversationModel> conversations = [];
    try {
      List<String> userIds =
          await BChatContactManager.getContactList(fromServer: firstTime);

      final usersMaps =
          await _client.userInfoManager.fetchUserInfoById(userIds);

      List<Contacts> contacts = [];

      for (ChatUserInfo user in usersMaps.values) {
        print('userID: ${user.toJson()} $firstTime');
        if (user.avatarUrl?.isNotEmpty == true && !firstTime) {
          final contact = Contacts(
            userId: int.parse(user.userId),
            name: user.nickName ?? '',
            profileImage: user.avatarUrl ?? '',
            email: user.mail,
            fcmToken: user.ext,
            phone: user.phone,
          );
          contacts.add(contact);
        } else {
          print('NULL so: ${userIds.join(',')}');
          final response = await api.getContactsByIds(token, userIds.join(','));
          if (response.status == successfull &&
              response.body?.contacts?.isNotEmpty == true) {
            contacts = response.body?.contacts ?? [];
          }
          break;
        }
      }
      print('contacts size: ${contacts.length}');

      for (Contacts contact in contacts) {
        final ConversationModel model;
        try {
          final conv = await _client.chatManager.getConversation(
              contact.userId.toString(),
              type: ChatConversationType.Chat);
          if (conv == null) continue;
          final lastMessage = await conv.latestMessage();
          // if (lastMessage == null) continue;

          model = ConversationModel(
              id: contact.userId.toString(),
              badgeCount: await conv.unreadCount(),
              contact: contact,
              conversation: conv,
              lastMessage: lastMessage,
              // isOnline: null,
              );
        } catch (e) {
          continue;
        }
        conversations.add(model);
      }
    } catch (e) {}
    return conversations;
  }
}
