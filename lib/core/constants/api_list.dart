//User Module
// const String baseUrlApi = "https://app.bvidya.com/sdfdf/";
const String baseUrlApi = 'https://app.bvidya.com/api/';
const String baseImageApi = 'https://app.bvidya.com/';

class ApiList {
  ApiList._();
  //Auth
  static const String login = 'auth'; //done
  static const String loginOtp = 'sms/login-otp'; //done
  static const String verifyloginOtp = 'otp-auth';
  static const String generateRegistrationOtp = 'sms/registration-otp'; //done
  static const String signUp = 'user/create'; //done
  static const String forgotPassword = 'forget-password';
  static const String changePassword = 'User/ChangePassword';
  static const String updateProfile = 'User/update';

  //bMeet
  static const String meetingList = 'meeting/meetings'; //GET

  static const String createMeet = 'meeting/create'; //POST
  static const String startMeet = 'meeting/start/'; //GET
  static const String joinMeet = 'meeting/join/'; //GET
  static const String leaveMeet = 'meeting/leave/'; //GET
  static const String deleteMeet = 'meeting/delete/'; //GET

  static const String fetchRtmMeet = 'meeting-rtm-token'; //POST

  //bLive
  static const String createLiveClass = 'live-class/create'; //POST
  static const String deleteLiveClass = 'live-class/delete/'; //GET
  static const String liveClass = 'live-class/'; //GET
  static const String fetchLiveRtm = 'live-chatroom/token/'; //GET

  //LMS
  static const String lmsHome = 'v2/home'; //GET
  static const String lmsCategories = 'categories'; //GET
  static const String lmsSubCategories = 'subcategories/'; //GET
  static const String lmsCourses = 'courses'; //GET
  static const String lmsLiveClasses = 'live-classes'; //GET
  static const String lmsLessons = 'lessons/'; //GET
  static const String lmsInstructors = 'instructors'; //GET
  static const String lmsSearch = 'search'; //POST
  static const String lmsCourseByInstructor = 'courses-by-instructor/'; //GET
  static const String lmsInstructorProfile = 'instructor/'; //GET
  static const String lmsFollowInstructor = 'follow-unfollow/'; //GET
  static const String lmsRecordVideoPlayback = 'watch-time/record'; //POST

  //Settings
  static const String reportProblem = 'report'; //POST
  static const String userProfile = 'profile'; //POST
  static const String instructorFollowed = 'followed'; //GET

  //bChat
  static const String getChatToken = 'chat-user/token'; //GET
  static const String addContact = 'chat-user/add-contact'; //POST
  static const String searchContact = 'chat-user/search-contact'; //POST
  static const String allContacts = 'chat-user/contacts'; //GET
  static const String contactsByIds = 'chat-user/contact/details'; //POST
  static const String groupContactsByIds = 'chat-user/group/details'; //POST
  static const String deleteContact = 'chat-user/delete-contact'; //POST

  static const String uploadImage =
      'messenger/attachment'; //POST Todo change later

  //CALLING
  static const String makeCall = 'messenger/start-call'; //POST
  static const String receiveCall = 'messenger/receive-call?call_id='; //GET
}
