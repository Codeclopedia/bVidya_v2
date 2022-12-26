import '../data/models/models.dart';
import '../ui/widget/base_drawer_page.dart';
import 'constants.dart';
import 'ui_core.dart';
import '../ui/screens.dart';

class Routes {
  static Route generateRoute(RouteSettings settings) {
    final Widget screen;
    bool hasDrawer = false;
    switch (settings.name) {
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

      case RouteList.bForum:
        screen = _commingSoon(RouteList.bForum);
        hasDrawer = true;
        break;
      case RouteList.bDiscuss:
        screen = _commingSoon(RouteList.bDiscuss);
        hasDrawer = true;
        break;
      case RouteList.home:
        screen = const HomeScreen();
        hasDrawer = true;
        break;
      case RouteList.groups:
        screen = const GroupsScreen();
        break;
      case RouteList.createNewGroup:
        screen = const CreateNewGroupScreen();
        break;
      case RouteList.newGroupContacts:
        screen = const NewGroupContactsScreen();
        break;
      case RouteList.groupChatScreen:
        if (settings.arguments is GroupModel) {
          screen = GroupChatScreen(
            model: settings.arguments as GroupModel,
          );
        } else {
          screen = _parameterMissing();
        }
        break;
      case RouteList.groupInfo:
        if (settings.arguments is GroupModel) {
          screen = GroupInfoScreen(
            group: settings.arguments as GroupModel,
          );
        } else {
          screen = _parameterMissing();
        }

        break;
      case RouteList.chatScreen:
        if (settings.arguments is ConversationModel) {
          screen = ChatScreen(
            model: settings.arguments as ConversationModel,
          );
        } else {
          screen = const Scaffold(
            body: Center(
              child: Text('Not a valid Chat Screen'),
            ),
          );
        }

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
            currentUser: settings.arguments as Contacts,
          );
        } else {
          screen = _parameterMissing();
        }

        break;
      case RouteList.search:
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
          bool video = args['video'] as bool;
          bool mute = args['mute'] as bool;
          int id = args['id'] as int;
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
            courses: course,
          );
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
        // if (settings.arguments is User) {
        //   User course = settings.arguments as User;
        //   screen = TeacherDashboard(
        //     user: course,
        //   );
        // } else {
        //   screen = _parameterMissing();
        // }
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

  static Widget _commingSoon(String name) {
    return BaseDrawerPage(
      screenName: name,
      body: Center(
        child: Text('Feature Comming soon', style: textStyleHeading),
      ),
    );
  }
}
