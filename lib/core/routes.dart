import 'package:bvidya/ui/screen/profile/settings/report_problem_screen.dart';

import '../data/models/models.dart';
import 'constants.dart';
import 'ui_core.dart';
import '../ui/screens.dart';

class Routes {
  static MaterialPageRoute generateRoute(RouteSettings settings) {
    final Widget screen;
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
      case RouteList.home:
        screen = const HomeScreen();
        break;
      case RouteList.groups:
        screen = const GroupsScreen();
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
        if (settings.arguments is User) {
          screen = ContactProfileScreen(
            users: settings.arguments as User,
          );
        } else if (settings.arguments is int) {
          screen = ContactProfileScreen(
            userId: settings.arguments as int,
          );
        } else {
          screen = ContactProfileScreen();
        }

        break;
      case RouteList.search:
        screen = const SearchScreen();
        break;
      case RouteList.bMeet:
        screen = const BMeetHomeScreen();
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
        screen = JoinMeetScreen();
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

          print('Meeting: ${meeting.toJson()}');
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
        screen = BLiveHomeScreen();
        break;

      //bLearn
      case RouteList.bLearnHome:
        screen = const BLearnHomeScreen();
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
}
