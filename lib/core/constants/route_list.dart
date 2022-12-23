class RouteList {
  RouteList._();
  // static const String splash = '/splash';
  static const String welcome = '/welcome';

  //Auth
  static const String login = '/login';
  static const String loginOtp = '/login-otp';
  static const String signup = '/sign-up';
  static const String verifyOtp = '/verify-otp';
  static const String register = '/register';
  static const String changePassword = '/change-profile';
  static const String forgotPassword = '/forgot-password';

  //Chat
  static const String home = '/home';
  static const String profile = '/profile';
  static const String chatScreen = '/chat-screen';
  static const String recentCalls = '/recent-calls';
  static const String contactList = '/contact-list';
  static const String contactProfile = '/contact-profile';
  static const String search = '/search';
  static const String groups = '/groups';
  static const String newGroupContacts = '/new-group-contacts';
  static const String createNewGroup = '/create-new-group-contacts';
  static const String groupInfo = '/group-info';
  static const String groupChatScreen = '/group-chat-screen';

  //BMeet
  static const String bMeet = '/b-meet';
  static const String bMeetStart = '/b-meet-start';
  static const String bMeetJoin = '/b-meet-join';
  static const String bMeetSchedule = '/b-meet-schedule';
  static const String bMeetCall = '/b-meet-call';

  //BLive
  static const String bLive = '/b-live';
  static const String bLiveSchedule = '/b-live-schedule';
  static const String bLiveClass = '/b-live-class';

  //BLearn
  static const String bLearnHome = '/b-learn';
  static const String bLearnCategories = '/b-learn-categories';
  static const String bLearnSubCategories = '/b-learn-subcategories';
  // static const String bLearnSubjects = '/b-learn-subjects';
  static const String bLearnCoursesList = '/b-learn-courses-lists';
  static const String bLearnCourseDetail = '/b-learn-course-detail';

  //Settings
  static const String settings = '/settings';
  static const String accountSetting = '/account-setting';
  // static const String chatSetting = '/chat-setting';
  static const String notificationSetting = '/notification-setting';
  static const String resetPassword = '/reset-password';
  static const String help = '/help';
  static const String contactUs = '/contact-us';
  static const String reportProblem = '/report-problem';

//Profiles
  //*student
  static const String studentProfile = '/student-profile';
  static const String editStudentProfile = '/edit-student-profile';
  static const String studentLearnings = '/student-learnings';
  static const String studentProfileDetail = '/student_profile_detail';

  //*teacher
  static const String teacherProfile = '/teacher-profile';
  static const String teacherEditProfile = '/teacher-edit-profile';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String teacherProfilePublic = '/teacher-profile-public';
  static const String teacherSchedule = '/teacher_schedule';
  static const String teacherClassRequest = '/teacher_classrequest';

  //
  static const String bForum = '/forum';
  static const String bDiscuss = '/discuss';
}
