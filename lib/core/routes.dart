import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:bvidya/ui/screen/bchat/group/group_call_screen.dart';
// import '/app.dart';

import '../controller/bchat_providers.dart';
import '/ui/screen/bchat/group/group_calls_screen.dart';
import '/data/models/models.dart';
import 'constants/route_list.dart';
import 'helpers/call_helper.dart';
import 'ui_core.dart';
import '/ui/screens.dart';

class Routes {
  static bool isChatScreen(String fromId) {
    String cName = getCurrentScreen();

    return cName == RouteList.home ||
        (cName == RouteList.chatScreen && fromId == _currentId) ||
        (cName == RouteList.chatScreenDirect && fromId == _currentId);
  }

  static bool isGroupChatScreen(String fromId) {
    String cName = getCurrentScreen();

    return cName == RouteList.groups ||
        (cName == RouteList.groupChatScreen && fromId == _currentId) ||
        (cName == RouteList.groupChatScreenDirect && fromId == _currentId);
  }

  static void setToScreen(String name) {
    _currentScreen = name;
  }

  static resetScreen() {
    _currentScreen = '';
    _currentId = '';
  }

  static String getCurrentScreen() {
    String cName = _currentScreen;
    // if (navigatorKey.currentContext != null) {
    //   cName = ModalRoute.of(navigatorKey.currentContext!)?.settings.name ??
    //       _currentScreen;
    //   print('current screen $cName  # $_currentScreen');
    // } else {
    //   print('null context screen $cName  # $_currentScreen');
    // }
    return cName;
  }

  static String _currentScreen = '';
  static String _currentId = '';
  static Route generateRoute(RouteSettings settings) {
    final Widget screen;
    bool hasDrawer = false;
    _currentScreen = settings.name ?? '';

    print('opening screen $_currentScreen ');
    switch (settings.name) {
      // case RouteList.splash:
      //   screen = const SplashScreen();
      //   break;
      case RouteList.signup:
        screen = SignUpScreen();
        break;

      case RouteList.loginOtp:
        screen = LoginOtpScreen();
        break;
      //loginOtp
      case RouteList.login:
        screen = LoginScreen();
        break;
      case RouteList.forgotPassword:
        screen = ForgetPasswordScreen();
        break;

      // case RouteList.bForum:
      //   screen = _commingSoon(RouteList.bForum);
      //   hasDrawer = true;
      //   break;
      // case RouteList.bDiscuss:
      //   screen = _commingSoon(RouteList.bDiscuss);
      //   hasDrawer = true;
      //   break;
      case RouteList.home:
        screen = const HomeScreen();
        hasDrawer = true;
        break;
      case RouteList.homeDirect:
        screen = const HomeScreen(direct: true);
        hasDrawer = true;
        break;
      case RouteList.homeDirectFromCall:
        screen = const HomeScreen(direct: true);
        hasDrawer = true;
        break;
      case RouteList.groups:
        screen = const GroupsScreen();
        break;
      case RouteList.searchGroups:
        screen = GroupSearchScreen();
        break;
      case RouteList.createNewGroup:
        screen = CreateNewGroupScreen();
        break;
      case RouteList.editGroup:
        if (settings.arguments is ChatGroup) {
          screen = CreateNewGroupScreen(group: settings.arguments as ChatGroup);
        } else {
          screen = _parameterMissing();
        }
        // screen = CreateNewGroupScreen();
        break;
      case RouteList.newGroupContacts:
        screen = const NewGroupContactsScreen();
        break;

      case RouteList.editGroupContacts:
        screen = const NewGroupContactsScreen(edit: true);
        break;

      case RouteList.groupChatScreen:
        if (settings.arguments is GroupConversationModel) {
          _currentId = (settings.arguments as GroupConversationModel).id;

          screen = GroupChatScreen(
            model: settings.arguments as GroupConversationModel,
          );
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.groupChatScreenDirect:
        if (settings.arguments is GroupConversationModel) {
          _currentId = (settings.arguments as GroupConversationModel).id;
          screen = GroupChatScreen(
            model: settings.arguments as GroupConversationModel,
            direct: true,
          );
        } else {
          screen = _parameterMissing();
        }
        break;
      case RouteList.groupInfo:
        if (settings.arguments is GroupConversationModel) {
          _currentId = (settings.arguments as GroupConversationModel).id;
          screen = GroupInfoScreen(
            group: settings.arguments as GroupConversationModel,
          );
        } else {
          screen = _parameterMissing();
        }
        break;
      case RouteList.groupCalls:
        screen = const GroupRecentCallScreen();
        break;

      case RouteList.groupCallScreen:
        if (settings.arguments is Map) {
          Map args = settings.arguments as Map<String, dynamic>;
          String groupId = args['group_id'];
          String groupName = args['group_name'];
          List<Contacts> members = args['members'] ?? [];
          int requestId = args['request_call_id'] as int;
          String callId = args['call_id'];
          Meeting meeting = args['meeting'];
          CallType callType = args['call_type'];
          // RTMUserTokenResponse rtmToken = args['rtm_token'];
          User me = args['user'];

          screen = GroupCallScreen(
            groupId: groupId,
            groupName: groupName,
            members: members,
            callDirectionType: CallDirectionType.outgoing,
            callId: callId,
            callRequiestId: requestId,
            callType: callType,
            me: me,
            meeting: meeting,
            membersIds: '',
            // rtmTokem: rtmToken,
          );
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.groupCallScreenReceive:
        if (settings.arguments is Map) {
          Map args = settings.arguments as Map<String, dynamic>;
          // ChatGroup group = args['group'];
          String membersIds = args['members_ids'];
          String groupId = args['group_id'];
          String groupName = args['group_name'];
          int requestId = args['request_call_id'] as int;
          String callId = args['call_id'];
          CallType callType = args['call_type'];
          User me = args['user'];
          bool direct = args['direct'];

          screen = GroupCallScreen(
            groupId: groupId,
            groupName: groupName,
            callDirectionType: CallDirectionType.incoming,
            callId: callId,
            callRequiestId: requestId,
            callType: callType,
            me: me,
            membersIds: membersIds,
            direct:direct
          );
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.chatScreen:
        if (settings.arguments is ConversationModel) {
          _currentId = (settings.arguments as ConversationModel).id;
          screen = ChatScreen(
            model: settings.arguments as ConversationModel,
          );
        } else {
          screen = Scaffold(
            body: Center(
              child: Text('Not a valid Chat Screen of name: ${settings.name}'),
            ),
          );
        }
        break;
      case RouteList.chatScreenDirect:
        if (settings.arguments is ConversationModel) {
          _currentId = (settings.arguments as ConversationModel).id;
          screen = ChatScreen(
            model: settings.arguments as ConversationModel,
            direct: true,
          );
        } else {
          screen = Scaffold(
            body: Center(
              child: Text('Not a valid Chat Screen of name: ${settings.name}'),
            ),
          );
        }
        break;
      case RouteList.bViewImage:
        if (settings.arguments is ChatImageMessageBody) {
          screen = FullScreenImageScreen(
            body: settings.arguments as ChatImageMessageBody,
          );
        } else {
          screen = _parameterMissing();
        }

        break;
      case RouteList.bViewVideo:
        if (settings.arguments is ChatVideoMessageBody) {
          screen = ChatVideoPlayerScreen(
            body: settings.arguments as ChatVideoMessageBody,
          );
        } else {
          screen = _parameterMissing();
        }

        break;

      case RouteList.bChatVideoCall:
        // screen = const ChatVideoCall();
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          String fcmToken = args['fcm_token'];
          String name = args['name'];
          String image = args['image'];
          CallBody callInfo = args['call_info'];
          CallDirectionType direction = args['call_direction_type'];
          bool direct = args['direct'] ?? false;
          String userId = args['user_id'];

          screen = ChatCallScreen(
              fcmToken: fcmToken,
              name: name,
              image: image,
              callInfo: callInfo,
              callDirection: direction,
              callType: CallType.video,
              otherUserId: userId,
              direct: direct);
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.bChatAudioCall:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          String fcmToken = args['fcm_token'];
          String name = args['name'];
          String image = args['image'];
          CallBody callInfo = args['call_info'];
          CallDirectionType direction = args['call_direction_type'];
          bool direct = args['direct'] ?? false;
          String userId = args['user_id'];
          screen = ChatCallScreen(
              fcmToken: fcmToken,
              name: name,
              image: image,
              callInfo: callInfo,
              callDirection: direction,
              callType: CallType.audio,
              otherUserId: userId,
              direct: direct);
        } else {
          screen = _parameterMissing();
        }
        // screen = const ChatAudioCall();
        break;
      case RouteList.recentCalls:
        screen = const RecentCallScreen();
        break;
      case RouteList.contactList:
        screen = const ContactListScreen();
        break;
      case RouteList.contactProfile:
        if (settings.arguments is Contacts) {
          screen = ContactProfileScreen(
            contact: settings.arguments as Contacts,
          );
        } else {
          screen = _parameterMissing();
        }

        break;
      case RouteList.contactInfo:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          Contacts contact = args['contact'];
          bool isInContact = args['is_contact'];
          screen = ContactProfileScreen(
            contact: contact,
            fromChat: false,
            isInContact: isInContact,
          );
          // }
          // if (settings.arguments is Contacts) {
          //   screen = ContactProfileScreen(
          //     contact: settings.arguments as Contacts,
          //     fromChat: false,
          //   );
        } else {
          screen = _parameterMissing();
        }

        break;
      case RouteList.searchContact:
        screen = SearchScreen();
        break;
      case RouteList.bMeet:
        screen = const BMeetHomeScreen();
        hasDrawer = true;
        break;
      case RouteList.bMeetStart:
        if (settings.arguments is ScheduledMeeting) {
          ScheduledMeeting meeting = settings.arguments as ScheduledMeeting;
          screen = StartMeetScreen(
            scheduledMeeting: meeting,
          );
        } else {
          screen = _parameterMissing();
        }
        break;
      case RouteList.bMeetJoin:
        screen = const JoinMeetScreen();

        break;

      case RouteList.bMeetCall:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;

          Meeting meeting = args['meeting'] as Meeting;
          String rtmToken = args['rtm_token'] as String;
          String rtmUser = args['rtm_user'] as String;
          String meetingId = args['meeting_id'] as String;
          String appId = args['app_id'] as String;
          int userId = args['user_id'] as int;

          int id = args['id'] as int;
          bool video = args['video'] as bool;
          bool mute = args['mute'] as bool;
          String userName = args['user_name'] as String;

          // print('Meeting: ${meeting.toJson()}');
          screen = BMeetCallScreen(
              meeting: meeting,
              enableVideo: video,
              meetingId: meetingId,
              rtmToken: rtmToken,
              rtmUser: rtmUser,
              disableMic: mute,
              appId: appId,
              userId: userId,
              userName: userName,
              id: id);
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.bMeetSchedule:
        screen = ScheduleMeetScreen();
        break;

      //Live
      case RouteList.bLive:
        screen = const BLiveHomeScreen();
        hasDrawer = true;
        break;
      case RouteList.bLiveSchedule:
        screen = ScheduleBLiveScreen();
        break;
      case RouteList.bLiveClass:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          LiveRtmToken token = args['rtm_token'] as LiveRtmToken;
          LiveClass liveClass = args['live_class'] as LiveClass;
          int userId = args['user_id'] as int;
          screen = BLiveClassScreen(
              liveClass: liveClass, rtmToken: token, userId: userId);
        } else {
          screen = _parameterMissing();
        }

        break;

      //bLearn
      case RouteList.bLearnHome:
        screen = const BLearnHomeScreen();
        hasDrawer = true;
        break;
      case RouteList.bLearnWishList:
        screen = const WishlistCourses();
        break;
      case RouteList.bLearnAllCourses:
        screen = const AllCoursesPage();
        break;
      case RouteList.bLearnCategories:
        screen = const CategoriesScreen();
        break;
      case RouteList.bLearnSubCategories:
        if (settings.arguments is Category) {
          Category category = settings.arguments as Category;
          screen = SubCategoriesScreen(
            category: category,
          );
        } else {
          screen = _parameterMissing();
        }
        // screen = const SubCategoriesScreen();
        break;
      // case RouteList.bLearnSubjects:
      //   screen = const SubjectsScreen();
      //   break;
      case RouteList.bLearnCoursesList:
        if (settings.arguments is SubCategory) {
          screen = CourseListScreen(
            subCategory: settings.arguments as SubCategory,
          );
        } else {
          screen = _parameterMissing();
        }
        // screen = const CourseListScreen();
        break;
      case RouteList.bLearnCourseDetail:
        if (settings.arguments is Course) {
          Course course = settings.arguments as Course;
          screen = CourseDetailScreen(
            course: course,
          );
        } else {
          screen = _parameterMissing();
        }

        break;
      case RouteList.bLearnLessionVideo:
        if (settings.arguments is Map<String, dynamic>) {
          final arg = settings.arguments as Map<String, dynamic>;
          Lesson lesson = arg["lesson"];
          Course course = arg["course"];
          int instructorId = arg['instructor_id'];
          bool isSubscribed = arg['isSubscribed'];
          screen = BlearnVideoPlayer(
            lesson: lesson,
            course: course,
            instructorId: instructorId,
            isSubscribed: isSubscribed,
          );
        } else {
          screen = _parameterMissing();
        }
        // screen = V
        break;
      case RouteList.bLearnteacherProfileDetail:
        if (settings.arguments is Instructor) {
          Instructor instructor = settings.arguments as Instructor;
          screen = TeacherProfileDetailScreen(instructor: instructor);
        } else {
          screen = _parameterMissing();
        }
        break;
      case RouteList.settings:
        screen = const SettingsScreen();
        hasDrawer = true;
        break;
      case RouteList.accountSetting:
        screen = const AccountSettingScreen();
        break;
      case RouteList.chatSetting:
        screen = const ChatSettingScreen();
        break;

      case RouteList.notificationSetting:
        screen = const NotificationSettingScreen();
        break;
      case RouteList.help:
        screen = const HelpCenterScreen();
        break;

      case RouteList.resetPassword:
        screen = const ResetPasswordScreen();
        break;

      case RouteList.contactUs:
        screen = const ContactUsScreen();
        break;

      case RouteList.reportProblem:
        screen = const ReportProblemScreen();
        break;

      case RouteList.studentProfile:
        screen = const StudentProfileScreen();
        hasDrawer = true;
        break;
      case RouteList.studentProfileSchdule:
        screen = const StudentSchdule();
        break;

      case RouteList.studentProfileDetail:
        //   screen = const StudentProfileScreen();
        //   break;
        if (settings.arguments is Profile) {
          Profile profileData = settings.arguments as Profile;
          screen = StudentProfileDetail(
            profile: profileData,
          );
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.studentLearnings:
        screen = const MyLearningScreen();
        break;

      case RouteList.teacherSchedule:
        screen = const TeacherScheduleScreen();
        break;

      case RouteList.teacherClassRequest:
        screen = const TeacherClassRequest();
        break;

      case RouteList.teacherProfile:
        screen = const TeacherProfile();
        hasDrawer = true;
        break;
      case RouteList.teacherEditProfile:
        if (settings.arguments is Profile) {
          Profile profile = settings.arguments as Profile;
          screen = TeacherProfileEdit(
            profile: profile,
          );
        } else {
          screen = _parameterMissing();
        }
        break;

      case RouteList.teacherDashboard:
        screen = const TeacherDashboard();
        break;

      case RouteList.webview:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          String url = args['url'];
          String title = 'bVidya';
          if (args.containsKey('title')) {
            title = args['title'] ?? 'bVidya';
          }
          screen = WebViewScreen(url: url, title: title);
        } else {
          screen = _parameterMissing();
        }
        break;

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No routes defined for ${settings.name} yet.'),
            ),
          ),
        );
    }
    if (hasDrawer) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // const begin = Offset(0.0, 0.0);
          // const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      );
    }
    return MaterialPageRoute(
      builder: (context) => screen,
    );
  }

  static Widget _parameterMissing() {
    return const Scaffold(
      body: Center(
        child: Text('Not a valid parameter passed'),
      ),
    );
  }

  // static Widget _commingSoon(String name) {
  //   return BaseDrawerPage(
  //     screenName: name,
  //     body: Center(
  //       child: Text('Feature Comming soon', style: textStyleHeading),
  //     ),
  //   );
  // }
}
