// import 'package:agora_chat_sdk/agora_chat_sdk.dart';

import '/data/models/models.dart';

final User user = User(
  name: 'Saurabh Sharma',
  id: 1,
  authToken: '',
  email: 'abc@example.com',
  fcmToken: '',
  phone: '(+91) 123-456-7890',
  role: 'admin',
  image:
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=400',
);

final contacts = [
  ContactModel('Aditi Singh', ''),
  ContactModel('Anil Mishra', ''),
  ContactModel('Bhavya Malik', ''),
  ContactModel('Bunty Kumar', 'assets/images/dummy_profile.png'),
  ContactModel('Kartikey', ''),
  ContactModel('Rajesh', ''),
  ContactModel('Mukesh', ''),
  ContactModel('Chandan', ''),
  ContactModel('Dheeraj', 'assets/images/dummy_profile.png'),
  ContactModel('Deepak', ''),
];

class ContactModel {
  final String name;
  final String image;

  ContactModel(this.name, this.image);
}

// class ConversationModel {
//   final int id;
//   final String name;
//   final String image;
//   // final String lastMessage;
//   final int badgeCount;
//   final DateTime lastMessageTime;
//   ChatConversation? conversation;

//   ConversationModel({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.badgeCount,
//     required this.lastMessageTime,
//   });
// }

// final conversationList = [
//   ConversationModel(
//     id: 1,
//     name: 'Saurabh Sharma',
//     image:
//         'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=200',
//     badgeCount: 1,
//     lastMessageTime: DateTime.now(),
//   ),
//   ConversationModel(
//     id: 2,
//     name: 'Piyush Kanwal',
//     image:
//         'https://images.pexels.com/photos/7233024/pexels-photo-7233024.jpeg?auto=compress&cs=tinysrgb&w=200',
//     badgeCount: 0,
//     lastMessageTime: DateTime.now(),
//   ),
//   ConversationModel(
//     id: 3,
//     name: 'Prashant',
//     image:
//         'https://images.pexels.com/photos/1278566/pexels-photo-1278566.jpeg?auto=compress&cs=tinysrgb&w=1200',
//     badgeCount: 1,
//     lastMessageTime: DateTime.now(),
//   ),
// ];

class CallModel {
  final String name;
  final DateTime time;
  final String callType;

  CallModel(this.name, this.time, this.callType);
}

final callList = [
  CallModel('Saurabh Sharma', DateTime.now(), 'video'),
  CallModel('Prashant', DateTime.now(), 'audio'),
  CallModel('Kunal', DateTime.now(), 'audio'),
  CallModel('Vaibhav Shah', DateTime.now(), 'video'),
];

// class Messege {
//   final String message;
//   final DateTime time;
//   final int userId;
//   String? type = 'text';
//   String? image = '';
//   Messege? replyOf;

//   Messege(
//       {required this.message,
//       required this.time,
//       required this.userId,
//       this.type,
//       this.replyOf,
//       this.image});
// }

// final listMessages = [
//   ChatMessage.createTxtSendMessage(
//     targetId: '1',
//     content: 'Hey there, What\'s Going on?',
//   )..from = '2',
//   ChatMessage.createTxtSendMessage(
//     targetId: '2',
//     content: 'I\'m good, What about you?',
//   )..from = '1',
//   ChatMessage.createTxtSendMessage(
//     targetId: '1',
//     content: 'I am fine too',
//   )..from = '2',
//   ChatMessage.createTxtSendMessage(
//     targetId: '1',
//     content: 'Send me a picture',
//   )..from = '2',
//   // ChatMessage.createImageSendMessage(targetId: '1', filePath: 'filePath')
// ];

// final oldMessages = [
//   ChatMessage.createTxtSendMessage(
//     targetId: '1',
//     content: 'Hello',
//   )..from = '2',
//   ChatMessage.createTxtSendMessage(
//     targetId: '2',
//     content: 'We are on old message',
//   )..from = '1',
//   ChatMessage.createTxtSendMessage(
//     targetId: '1',
//     content: 'Something new',
//   )..from = '2',
//   ChatMessage.createTxtSendMessage(
//     targetId: '1',
//     content: 'Done',
//   )..from = '2',
//   // ChatMessage.createImageSendMessage(targetId: '1', filePath: 'filePath')
// ];

// final messageList = [
//   Messege(
//       message: 'Hey there, What\'s Going on?',
//       time: DateTime.now(),
//       userId: 2,
//       type: 'text'),
//   Messege(
//     message: 'I\'m good, What about you?',
//     time: DateTime.now(),
//     userId: 1,
//     type: 'text',
//     replyOf: Messege(
//         message: 'Hey there, What\'s Going on?',
//         time: DateTime.now(),
//         userId: 2,
//         type: 'text'),
//   ),
//   Messege(
//       message: 'I\'m fine too', time: DateTime.now(), userId: 2, type: 'text'),
//   Messege(
//       message: 'Send me a nature picture.',
//       time: DateTime.now(),
//       userId: 1,
//       type: 'text'),
//   Messege(
//     message: '',
//     time: DateTime.now(),
//     userId: 2,
//     type: 'image',
//     image:
//         'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg',
//   ),
//   Messege(
//     message: 'Its looking nice',
//     time: DateTime.now(),
//     userId: 1,
//     type: 'text',
//     replyOf: Messege(
//         message: '',
//         time: DateTime.now(),
//         userId: 2,
//         type: 'image',
//         image:
//             'https://cdn.pixabay.com/photo/2015/12/01/20/28/road-1072823__340.jpg'),
//   ),
//   Messege(
//       message: '',
//       time: DateTime.now(),
//       userId: 1,
//       type: 'image',
//       image:
//           'https://c4.wallpaperflare.com/wallpaper/308/540/975/autumn-scenery-wallpaper-preview.jpg'),
// ];

final usersMap = {
  '1': User(
      id: 1,
      authToken: '',
      name: 'KUNAL PANDEY',
      email: 'kunal@shivalikjournal.com',
      phone: '9149252803',
      role: 'admin',
      fcmToken:
          'flzJPfqjTQWbAf3RAMmKvB:APA91bHdiMNW4obVmX9anHaadAdRXlJRZyr4T8YJAk8wSWzfdPo4QiRh4VutXHI_K0JuOVokzTbjMOAVYXl3BuLu3EdptVyCrsRtiI_nUcib2ujMDY2gDjjiyrWVa--WlOZjSX4TVzCq',
      image: 'users/sTRwHiQ4vv1seYqbwygKKUwnc3PY7yOMQnCkxC7M.jpeg'),
  '24': User(
      id: 24,
      authToken: 'authToken',
      name: 'Shubham Pandey',
      email: 'shubham@shivalikjournal.com',
      phone: '7060873196',
      role: 'instructor',
      fcmToken:
          'cmjgAwXuRvSKUG46ErJGy1:APA91bEU6tBuu5owshzgQgPprNxOrX_64vVIXqLSGOcKcb55imxDgFqsV2WGIZes9OS-Q0IIkLlXijRv90-f7HNb9qRK2sxsgxEMOov0egtWoXYFQYcf0l8_Fs7paqsRyqNH_rcXLmD0',
      image: 'users/58JBJIEb8JYAL4O7WpEXYKc8aRsA6bVAocJlX9Kf.jpeg'),
};

//{auth_token: $2y$10$6y7rX3ImTQUeZhk24lfjkObnOVqa4Y/crkJVybErTK8CX2UXLRVEq, name: Shubham Pandey, email: shubham@shivalikjournal.com, phone: 7060873196, role: instructor, id: 24, fcm_token: cmjgAwXuRvSKUG46ErJGy1:APA91bEU6tBuu5owshzgQgPprNxOrX_64vVIXqLSGOcKcb55imxDgFqsV2WGIZes9OS-Q0IIkLlXijRv90-f7HNb9qRK2sxsgxEMOov0egtWoXYFQYcf0l8_Fs7paqsRyqNH_rcXLmD0, image: users/58JBJIEb8JYAL4O7WpEXYKc8aRsA6bVAocJlX9Kf.jpeg}

final userTokenMap = {
  '1':
      '007eJxTYFhsfzpkj2nEH+2yikdbSm7+4Htg9KWuOHt9YVbtpsY50c0KDKZmpgZJiSYpiQYmhiZGFqYWJinJxuYmicnGloYGpkZpbTcnJTcEMjIsMuthYmRgZWAEQhBfhSHFxMLE1NDQQNcsLcVI19AwNUXX0jglWTcpDWhAioGFpYGlJQAXLyiX',
  '24':
      '007eJxTYKiK/3vrQ+7Gy2czWm7V1hgGqu0y5eTwurxgxYKACU8W7wtRYDA1MzVISjRJSTQwMTQxsjC1MElJNjY3SUw2tjQ0MDVK67s1KbkhkJFhToAwAyMDKxAzMoD4KgzJFpaJSckmBrrmBuZGuoaGqSm6iclGxrqmhsmJhslGFknJFikADRgokg=='
};
