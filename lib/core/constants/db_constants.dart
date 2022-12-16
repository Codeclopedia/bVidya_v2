class DBTables {
  //:Table Names
  static const chats = 'Chats';
  static const channels = 'Channels';
  static const users = 'Users';
}

//: Users- Columns
class UsersColumn {
  static const id = 'id';
  static const name = 'name';
  static const email = 'email';
  static const mobile = 'mobile';
  static const dpUrl = 'dp_url';
  static const status = 'status'; //BANNED, VALID
  static const lastOnline = 'last_online';
  static const blockedIds = 'blocked_ids';
  static const fcmToken = 'fcm_token';
  static const agoraToken = 'agora_token';
}

//: Chats- Columns
class ChatsColumn {
  static const id = 'id';
  static const chatId = 'chat_id';
  static const content = 'content';
  static const type = 'type'; //TEXT,IMAGE,VIDEO,DOC,PDF,ACALL,VCALL
  static const fromId = 'from_id';
  static const toChannelId = 'to_channel_id';
  static const time = 'time';
  static const referenceId = 'reference_id'; //Reference with other chatId
  static const referenceType = 'reference_type'; //NONE,REPLY
  static const status = 'status'; //SENT,DELIVERED
  static const mediaUrl = 'media_url';
  static const mediaPath = 'media_path';
  static const mediaStatus = 'media_status'; //NONE,DOWNLOADED
  static const duration = 'duration';
  static const deleted = 'deleted'; //0,1

}

//: Channels- Columns
class ChannelsColumn {
  static const id = 'id';
  static const type = 'type'; //PEER,GROUP
  static const lastChatId = 'last_chat_id';
  static const lastContent = 'last_content';
  static const lastChatTime = 'last_chat_time';
  static const unreadCount = 'unread_count';
  static const usersIds = 'users_ids';
  static const name = 'name';
  static const adminId = 'admin_id';
  static const adminName = 'admin_name';
  static const deleted = 'deleted'; //0,1
}
