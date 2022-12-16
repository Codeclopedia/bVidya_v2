import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../../core/constants.dart';

class ChatDatabaseHelper {
  ChatDatabaseHelper._();

  static final ChatDatabaseHelper instance = ChatDatabaseHelper._();

  Database? _database;

  static const _databaseName = "chat_v2.db";
  static const _databaseVersion = 2;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await createDatabase();
    return _database!;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    await _migrateOldDatabase(dbPath);

    return await openDatabase(
      p.join(dbPath, _databaseName),
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    //Creating User table
    await db.execute('''
          CREATE TABLE ${DBTables.users} (
            ${UsersColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ${UsersColumn.name} TEXT NOT NULL,
            ${UsersColumn.email} TEXT NOT NULL,
            ${UsersColumn.mobile} TEXT NOT NULL,
            ${UsersColumn.dpUrl} TEXT NOT NULL,
            ${UsersColumn.status} TEXT NOT NULL,
            ${UsersColumn.lastOnline} TEXT NOT NULL,
            ${UsersColumn.blockedIds} TEXT NOT NULL,
            ${UsersColumn.fcmToken} TEXT NOT NULL,
            ${UsersColumn.agoraToken} TEXT NOT NULL
          );
          ''');

    //Creating Chat table
    await db.execute('''
          CREATE TABLE ${DBTables.users} (
            ${ChatsColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ${ChatsColumn.chatId} TEXT NOT NULL,
            ${ChatsColumn.content} TEXT NOT NULL,
            ${ChatsColumn.type} TEXT NOT NULL,
            ${ChatsColumn.fromId} TEXT NOT NULL,
            ${ChatsColumn.toChannelId} TEXT NOT NULL,
            ${ChatsColumn.time} TEXT NOT NULL,
            ${ChatsColumn.referenceId} TEXT NOT NULL,
            ${ChatsColumn.referenceType} TEXT NOT NULL,
            ${ChatsColumn.status} TEXT NOT NULL,
            ${ChatsColumn.mediaUrl} TEXT NOT NULL,
            ${ChatsColumn.mediaPath} TEXT NOT NULL,
            ${ChatsColumn.mediaStatus} TEXT NOT NULL,
            ${ChatsColumn.duration} INT NOT NULL,
            ${ChatsColumn.deleted} INT NOT NULL,
          );
          ''');

    //Creating Channel table
    await db.execute('''
          CREATE TABLE ${DBTables.channels} (
            ${ChannelsColumn.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            ${ChannelsColumn.type} TEXT NOT NULL,
            ${ChannelsColumn.lastChatId} TEXT NOT NULL,
            ${ChannelsColumn.lastContent} TEXT NOT NULL,
            ${ChannelsColumn.lastChatTime} TEXT NOT NULL,
            ${ChannelsColumn.unreadCount} INT NOT NULL,
            ${ChannelsColumn.usersIds} TEXT NOT NULL,
            ${ChannelsColumn.name} TEXT NOT NULL,
            ${ChannelsColumn.adminId} TEXT NOT NULL,
            ${ChannelsColumn.adminName} TEXT NOT NULL,
            ${ChannelsColumn.deleted} INT NOT NULL,
          );
          ''');
    return;
  }

  Future _migrateOldDatabase(path) async {
    //??TODO Migrate db from previous version if already exists;
    // final dbPath = join(path, "chat.db");
    // final db = await openReadOnlyDatabase(dbPath);
    // if (db.isOpen) {
    // }

    return;
  }

  static Future<int> insertUser(Map<String, String> user) async {
    Database db = await instance.database;
    return db.insert(DBTables.users, user);
  }

  static Future<int> insertChat(Map<String, String> chat) async {
    Database db = await instance.database;
    return db.insert(DBTables.chats, chat);
  }

  static Future<int> insertChannel(Map<String, String> channel) async {
    Database db = await instance.database;
    return db.insert(DBTables.channels, channel);
  }
}
