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
  static const String updateProfile = 'profile/update';
  static const String updateProfileImage = 'profile/upload';
  static const String deleteUserAccount = 'account-dismiss';

  static const String pinUnpinContact = 'chat-user/contact/pin-unpin'; //POST

  //bMeet
  static const String meetingList = 'meeting/meetings'; //GET
  static const String createMeet = 'meeting/create'; //POST
  static const String startMeet = 'meeting/start/'; //GET
  static const String joinMeet = 'meeting/join/'; //GET
  static const String leaveMeet = 'meeting/leave/'; //GET
  static const String deleteMeet = 'meeting/delete/'; //GET

  static const String fetchRtmMeet = 'meeting-rtm-token'; //POST

  static const String personalClassRequests = 'personal-class-requests'; //GET
  static const String requestedClasses = 'requested-personal-classes'; //GET
  static const String requestClass = 'personal-class-request'; //POST

  static const String scheduledClassesStudent = 'scheduled-classes-user'; //GET
  static const String scheduledClassesInstructor =
      'scheduled-classes-instructor'; //GET

  //bLive
  static const String createLiveClass = 'live-class/create'; //POST
  static const String deleteLiveClass = 'live-class/delete/'; //GET
  static const String liveClass = 'live-class/'; //GET
  static const String fetchLiveRtm = 'live-chatroom/token/'; //GET

  //personal Class
  static const String joinPersonalClass = 'personal-class/join/'; //GET
  static const String startPersonalClass = 'personal-class/start/'; //GET
  
  //LMS
  static const String lmsHome = 'v2/home'; //GET
  static const String lmsCategories = 'categories'; //GET
  static const String lmsSubCategories = 'subcategories/'; //GET
  static const String lmsCourses = 'courses'; //GET
  static const String lmsCoursesDetail = 'course-detail/'; //GET
  static const String lmsLiveClasses = 'live-classes'; //GET
  static const String lmsLessons = 'lessons/playlist/'; //GET
  static const String lmsSubscribeCourse = 'subscribe-course/'; //GET
  static const String lmsSetCourseProgress = 'set-course-progress'; //POST
  static const String lmswishlist = 'wishlist-course/'; //GET
  static const String lmsgetwishlistCourses = 'wishlisted-courses'; //GET
  static const String lmsInstructors = 'instructors'; //GET
  static const String lmsSearch = 'search'; //POST
  static const String lmsCourseByInstructor = 'courses-by-instructor/'; //GET
  static const String lmsProfileDetail = 'profile-detail/'; //GET
  static const String lmsFollowInstructor = 'follow-unfollow/'; //GET
  static const String lmsRecordVideoPlayback = 'watch-time/record'; //POST

  //subscriptions
  static const String getAllSubscriptions = 'subscription-plans'; //GET
  static const String getpaymentId = 'payment-order'; //POST
  static const String getpaymentRecord = 'payment-record'; //POST
  static const String purchasedCreditDetails = 'purchased-plans-detail';

  //Settings
  static const String reportProblem = 'report'; //POST
  static const String userProfile = 'profile'; //POST
  static const String instructorFollowed = 'followed'; //GET
  static const String subscribedList = 'subscribed-courses'; //GET

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
