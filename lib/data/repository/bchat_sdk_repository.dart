import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '../../core/helpers/bchat_contact_manager.dart';
import '../models/models.dart';
import '../services/bchat_api_service.dart';

class BChatSDKRepository {
  static const successfull = 'success';

  final BChatApiService api;
  final String token;
  final ChatClient _client; // = ChatClient.getInstance;

  BChatSDKRepository(this.api, this.token) : _client = ChatClient.getInstance;

  Future<List<ConversationModel>> getConversations(
      {bool firstTime = false}) async {
    List<String> userIds =
        await BChatContactManager.getContactList(fromServer: firstTime);
    final usersMaps = await _client.userInfoManager.fetchUserInfoById(userIds);

    List<ConversationModel> conversations = [];
    List<Contacts> contacts = [];

    for (var user in usersMaps.values) {
      if (user.avatarUrl?.isNotEmpty == true && !firstTime) {
        final contact = Contacts(
          userId: user.userId as int,
          name: user.nickName ?? '',
          profileImage: user.avatarUrl ?? '',
          email: user.mail,
          fcmToken: user.ext,
          phone: user.phone,
        );
        contacts.add(contact);
      } else {
        final response = await api.getContactsByIds(token, userIds.join(','));
        if (response.status == successfull &&
            response.body?.contacts?.isNotEmpty == true) {
          contacts = response.body!.contacts!;

          //  _client.userInfoManager.updateUserInfo()
        }
        break;
      }
    }

    for (var contact in contacts) {
      final ConversationModel model;
      try {
        final conv = await _client.chatManager.getConversation(
            contact.userId.toString(),
            type: ChatConversationType.Chat);
        if (conv == null) continue;
        final lastMessage = await conv.latestMessage();
        if (lastMessage == null) continue;

        model = ConversationModel(
            id: contact.userId.toString(),
            badgeCount: await conv.unreadCount(),
            contact: contact,
            conversation: conv,
            lastMessage: lastMessage,
            isOnline: null);
      } catch (e) {
        continue;
      }
      conversations.add(model);
    }
    return conversations;
  }
}
