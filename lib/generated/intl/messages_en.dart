// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(date) => "${date} Broadcast";

  static String m1(date) => "${date} Meeting";

  static String m2(time) => "Resend OTP in ${time} seconds";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Account": MessageLookupByLibrary.simpleMessage("Account"),
        "accnt_security": MessageLookupByLibrary.simpleMessage("Security"),
        "atc_audio": MessageLookupByLibrary.simpleMessage("Audio"),
        "atc_audio_desc": MessageLookupByLibrary.simpleMessage("Share audios"),
        "atc_camera": MessageLookupByLibrary.simpleMessage("Camera"),
        "atc_content": MessageLookupByLibrary.simpleMessage("Share Content"),
        "atc_document": MessageLookupByLibrary.simpleMessage("Documents"),
        "atc_document_desc":
            MessageLookupByLibrary.simpleMessage("Share your files"),
        "atc_media": MessageLookupByLibrary.simpleMessage("Media"),
        "atc_media_desc":
            MessageLookupByLibrary.simpleMessage("Share photos and videos"),
        "bchat": MessageLookupByLibrary.simpleMessage("bChat"),
        "blearn": MessageLookupByLibrary.simpleMessage("bLearn"),
        "blearn_added": MessageLookupByLibrary.simpleMessage("Added"),
        "blearn_btx_mostviewed":
            MessageLookupByLibrary.simpleMessage("Most Viewed"),
        "blearn_btx_topcourses":
            MessageLookupByLibrary.simpleMessage("Top Courses"),
        "blearn_btx_trending": MessageLookupByLibrary.simpleMessage("Trending"),
        "blearn_btx_viewall": MessageLookupByLibrary.simpleMessage("View All"),
        "blearn_byus": MessageLookupByLibrary.simpleMessage("By Us"),
        "blearn_complementry":
            MessageLookupByLibrary.simpleMessage("Complementary"),
        "blearn_courses": MessageLookupByLibrary.simpleMessage("Courses"),
        "blearn_explore": MessageLookupByLibrary.simpleMessage("Explore"),
        "blearn_learnfrom": MessageLookupByLibrary.simpleMessage("Learn From"),
        "blearn_recently": MessageLookupByLibrary.simpleMessage("Recently"),
        "blearn_recommended":
            MessageLookupByLibrary.simpleMessage("Recommended"),
        "blearn_testimonial":
            MessageLookupByLibrary.simpleMessage("Testimonials"),
        "blearn_thebest": MessageLookupByLibrary.simpleMessage("the Best"),
        "blive": MessageLookupByLibrary.simpleMessage("bLive"),
        "blive_btx_join":
            MessageLookupByLibrary.simpleMessage("Join Broadcast"),
        "blive_caption_date":
            MessageLookupByLibrary.simpleMessage("Broadcast Date"),
        "blive_caption_desc":
            MessageLookupByLibrary.simpleMessage("Broadcast desc"),
        "blive_caption_starttime":
            MessageLookupByLibrary.simpleMessage("Broadcast Time"),
        "blive_caption_title":
            MessageLookupByLibrary.simpleMessage("Broadcast Title"),
        "blive_date_meeting": m0,
        "blive_empty_date":
            MessageLookupByLibrary.simpleMessage("Enter meeting date"),
        "blive_empty_desc": MessageLookupByLibrary.simpleMessage(
            "Broadcast description can\'t be emplty"),
        "blive_empty_time":
            MessageLookupByLibrary.simpleMessage("Enter Broadcast time"),
        "blive_empty_title": MessageLookupByLibrary.simpleMessage(
            "Broadcast title can\'t be emplty"),
        "blive_hint_date":
            MessageLookupByLibrary.simpleMessage("Select Broadcast Date"),
        "blive_hint_desc": MessageLookupByLibrary.simpleMessage(
            "Enter Your Broadcast Description"),
        "blive_hint_link":
            MessageLookupByLibrary.simpleMessage("Enter Broadcast ID or Link."),
        "blive_hint_time":
            MessageLookupByLibrary.simpleMessage("Broadcast Time"),
        "blive_hint_title":
            MessageLookupByLibrary.simpleMessage("Enter Your Broadcast Title"),
        "blive_invalid_date": MessageLookupByLibrary.simpleMessage(
            "Broadcast date can\'t be in past"),
        "blive_invalid_desc": MessageLookupByLibrary.simpleMessage(
            "Broadcast description must contains at least 5 characters"),
        "blive_invalid_time": MessageLookupByLibrary.simpleMessage(
            "Broadcast time can\'t be in past"),
        "blive_invalid_title": MessageLookupByLibrary.simpleMessage(
            "Broadcast title must contains at least 5 characters"),
        "blive_no_meetings": MessageLookupByLibrary.simpleMessage(
            "You currently have no live broadcast\n scheduled on the selected date. \n Select a different date."),
        "blive_today_meeting":
            MessageLookupByLibrary.simpleMessage("Today\'s Broadcast"),
        "blive_txt_broadcast":
            MessageLookupByLibrary.simpleMessage("Broadcast"),
        "blive_txt_schedule":
            MessageLookupByLibrary.simpleMessage("Scheduled Broadcast"),
        "blive_txt_start_desc": MessageLookupByLibrary.simpleMessage(
            "Enter Broadcast ID or Link Here."),
        "blive_txt_start_title":
            MessageLookupByLibrary.simpleMessage("BroadCast ID or Link"),
        "bmeet": MessageLookupByLibrary.simpleMessage("bMeet"),
        "bmeet_btn_join": MessageLookupByLibrary.simpleMessage("Join"),
        "bmeet_btn_schedule": MessageLookupByLibrary.simpleMessage("Schedule"),
        "bmeet_btn_start": MessageLookupByLibrary.simpleMessage("Start"),
        "bmeet_btx_join": MessageLookupByLibrary.simpleMessage("Join Meeting"),
        "bmeet_call_bxt_cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "bmeet_call_bxt_disconnect_all":
            MessageLookupByLibrary.simpleMessage("Disconnect Joiner"),
        "bmeet_call_bxt_end": MessageLookupByLibrary.simpleMessage("End"),
        "bmeet_call_bxt_muteall":
            MessageLookupByLibrary.simpleMessage("Mute All"),
        "bmeet_call_bxt_record":
            MessageLookupByLibrary.simpleMessage("Record video"),
        "bmeet_call_bxt_sharelink":
            MessageLookupByLibrary.simpleMessage("Share Link"),
        "bmeet_call_bxt_unmuteall":
            MessageLookupByLibrary.simpleMessage("Unmute All"),
        "bmeet_call_msg_diable_audio_host":
            MessageLookupByLibrary.simpleMessage("Your are muted by host"),
        "bmeet_call_msg_diable_camera_host":
            MessageLookupByLibrary.simpleMessage(
                "Your camera disabled by host."),
        "bmeet_call_msg_na_yet":
            MessageLookupByLibrary.simpleMessage("This is not available yet."),
        "bmeet_call_txt_enable":
            MessageLookupByLibrary.simpleMessage("Enabled"),
        "bmeet_call_txt_encryption":
            MessageLookupByLibrary.simpleMessage("Encryption"),
        "bmeet_call_txt_host_id":
            MessageLookupByLibrary.simpleMessage("Host ID"),
        "bmeet_call_txt_invite_link":
            MessageLookupByLibrary.simpleMessage("Invite Link"),
        "bmeet_call_txt_meeting_id":
            MessageLookupByLibrary.simpleMessage("Meeting ID"),
        "bmeet_call_txt_na":
            MessageLookupByLibrary.simpleMessage("Not Available"),
        "bmeet_caption_date":
            MessageLookupByLibrary.simpleMessage("Set Meeting Date"),
        "bmeet_caption_endtime":
            MessageLookupByLibrary.simpleMessage("End Time"),
        "bmeet_caption_starttime":
            MessageLookupByLibrary.simpleMessage("Start Time"),
        "bmeet_caption_subject":
            MessageLookupByLibrary.simpleMessage("Meeting Subject"),
        "bmeet_caption_title":
            MessageLookupByLibrary.simpleMessage("Meeting Title"),
        "bmeet_date_meeting": m1,
        "bmeet_empty_date":
            MessageLookupByLibrary.simpleMessage("Enter meeting date"),
        "bmeet_empty_end":
            MessageLookupByLibrary.simpleMessage("Enter end time"),
        "bmeet_empty_start":
            MessageLookupByLibrary.simpleMessage("Enter start time"),
        "bmeet_empty_subject": MessageLookupByLibrary.simpleMessage(
            "Meeting subject can\'t be emplty"),
        "bmeet_empty_title": MessageLookupByLibrary.simpleMessage(
            "Meeting title can\'t be emplty"),
        "bmeet_hint_date":
            MessageLookupByLibrary.simpleMessage("Select Meeting Date"),
        "bmeet_hint_end": MessageLookupByLibrary.simpleMessage("End Time"),
        "bmeet_hint_join_id_link":
            MessageLookupByLibrary.simpleMessage("Enter Meeting ID or Link"),
        "bmeet_hint_start": MessageLookupByLibrary.simpleMessage("Start Time"),
        "bmeet_hint_subject":
            MessageLookupByLibrary.simpleMessage("Enter Your Meeting Subject"),
        "bmeet_hint_title":
            MessageLookupByLibrary.simpleMessage("Enter Your Meeting Title"),
        "bmeet_invalid_date": MessageLookupByLibrary.simpleMessage(
            "Meeting date can\'t be in past"),
        "bmeet_invalid_end": MessageLookupByLibrary.simpleMessage(
            "Meeting end time can\'t be before start time"),
        "bmeet_invalid_start": MessageLookupByLibrary.simpleMessage(
            "Meeting start time can\'t be in past"),
        "bmeet_invalid_subject": MessageLookupByLibrary.simpleMessage(
            "Meeting subject must contains at least 5 characters"),
        "bmeet_invalid_title": MessageLookupByLibrary.simpleMessage(
            "Meeting title must contains at least 5 characters"),
        "bmeet_join_caption":
            MessageLookupByLibrary.simpleMessage("Meeting ID or Link"),
        "bmeet_join_desc": MessageLookupByLibrary.simpleMessage(
            "You can also clink on the link received to join directly"),
        "bmeet_join_heading":
            MessageLookupByLibrary.simpleMessage("Join a Meeting"),
        "bmeet_mute_desc": MessageLookupByLibrary.simpleMessage(
            "Grand or restrict audio access"),
        "bmeet_mute_title": MessageLookupByLibrary.simpleMessage(
            "Always mute my microphone on start"),
        "bmeet_no_meetings": MessageLookupByLibrary.simpleMessage(
            "You currently have no meetings\n scheduled on the selected date. \n Select a different date."),
        "bmeet_schedule_heading":
            MessageLookupByLibrary.simpleMessage("Schedule a Meeting"),
        "bmeet_sharable_caption":
            MessageLookupByLibrary.simpleMessage("Sharable Link"),
        "bmeet_sharable_title": MessageLookupByLibrary.simpleMessage(
            "Your Unique Meeting link or ID"),
        "bmeet_share": MessageLookupByLibrary.simpleMessage("Share"),
        "bmeet_start_heading":
            MessageLookupByLibrary.simpleMessage("Start a Meeting"),
        "bmeet_start_option":
            MessageLookupByLibrary.simpleMessage("Meeting Joining Options"),
        "bmeet_today_meeting":
            MessageLookupByLibrary.simpleMessage("Today\'s Meeting"),
        "bmeet_txt_meeting": MessageLookupByLibrary.simpleMessage("Meeting"),
        "bmeet_txt_schedule":
            MessageLookupByLibrary.simpleMessage("Scheduled Meetings"),
        "bmeet_txt_start_desc": MessageLookupByLibrary.simpleMessage(
            "Generate your meeting link to begin."),
        "bmeet_videooff_desc": MessageLookupByLibrary.simpleMessage(
            "Grand or restrict video access"),
        "bmeet_videooff_title": MessageLookupByLibrary.simpleMessage(
            "Always turn off my camera on start"),
        "bmmet_txt_start_title":
            MessageLookupByLibrary.simpleMessage("Start Instant Meeting"),
        "btn_ok": MessageLookupByLibrary.simpleMessage("OK"),
        "callDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block call notifications"),
        "chatHistory": MessageLookupByLibrary.simpleMessage(
            "Chat history,themes,wallpapers"),
        "chat_input_hint":
            MessageLookupByLibrary.simpleMessage("Write your message"),
        "confDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block conference reminder notifications"),
        "confRem": MessageLookupByLibrary.simpleMessage("Conference Reminder"),
        "contactDesc":
            MessageLookupByLibrary.simpleMessage("Questions? need help?"),
        "contactHint": MessageLookupByLibrary.simpleMessage(
            "Tell us how can we help you."),
        "contactQuery": MessageLookupByLibrary.simpleMessage(
            "Write us your query and we\'ll get back to you soon!"),
        "contact_title": MessageLookupByLibrary.simpleMessage("Contact Us"),
        "course_calender": MessageLookupByLibrary.simpleMessage(
            "bVidya Educator since\n6th July, 2018"),
        "course_conti":
            MessageLookupByLibrary.simpleMessage("Continue Learning"),
        "course_header": MessageLookupByLibrary.simpleMessage("Courses"),
        "course_instructor_detail":
            MessageLookupByLibrary.simpleMessage("Instructor Details"),
        "course_lang": MessageLookupByLibrary.simpleMessage(
            "Knows Hinglish, Hindi and\nEnglish"),
        "course_loca": MessageLookupByLibrary.simpleMessage(
            "Lives in Karnal,Haryana,India"),
        "course_percent": MessageLookupByLibrary.simpleMessage("80%"),
        "course_timer": MessageLookupByLibrary.simpleMessage("6 hours left"),
        "course_title": MessageLookupByLibrary.simpleMessage(
            "Stock Market Trading: \nThe Complete Technical \nCourses"),
        "course_work": MessageLookupByLibrary.simpleMessage(
            "Worked at BHARAT CHEMISTRY\nCLASSES"),
        "deleteAcc": MessageLookupByLibrary.simpleMessage("Delete Account"),
        "deleteDesc":
            MessageLookupByLibrary.simpleMessage("Delete your account"),
        "dltCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "dltConfirmation": MessageLookupByLibrary.simpleMessage(
            "Are you sure want to delete\nyour account?"),
        "dndDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block bvidya\nnotifications"),
        "dndTitle": MessageLookupByLibrary.simpleMessage("Do Not Disturb"),
        "drawer_bchat": MessageLookupByLibrary.simpleMessage("bChat"),
        "drawer_blearn": MessageLookupByLibrary.simpleMessage("bLearn"),
        "drawer_blive": MessageLookupByLibrary.simpleMessage("bLive"),
        "drawer_bmeet": MessageLookupByLibrary.simpleMessage("bMeet"),
        "drawer_disucss": MessageLookupByLibrary.simpleMessage("Discuss"),
        "drawer_forum": MessageLookupByLibrary.simpleMessage("Forum"),
        "drawer_profile": MessageLookupByLibrary.simpleMessage("Profile"),
        "drawer_setting": MessageLookupByLibrary.simpleMessage("Setting"),
        "emailHint":
            MessageLookupByLibrary.simpleMessage("Enter Your Email Address"),
        "faqDesc":
            MessageLookupByLibrary.simpleMessage("Find your answers here"),
        "faq_title": MessageLookupByLibrary.simpleMessage("FAQ"),
        "fp_btn_submit": MessageLookupByLibrary.simpleMessage("Submit"),
        "fp_btx_login_back":
            MessageLookupByLibrary.simpleMessage("Back to Login"),
        "fp_desc_message": MessageLookupByLibrary.simpleMessage(
            "Enter the email associated with your account and we\'ll send an email with instructions to reset your password."),
        "fp_email_caption":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "fp_email_empty": MessageLookupByLibrary.simpleMessage(
            "Email address can\'t be emply"),
        "fp_email_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Email Address"),
        "fp_email_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid Email Address"),
        "fp_header_title":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "groupDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block group notifications"),
        "helpCenter": MessageLookupByLibrary.simpleMessage(
            "Help center,contact us ,privacy policy"),
        "home_btx_groups": MessageLookupByLibrary.simpleMessage("Groups"),
        "home_btx_new_group": MessageLookupByLibrary.simpleMessage("New Group"),
        "home_btx_new_message":
            MessageLookupByLibrary.simpleMessage("New Message"),
        "home_btx_recent_calls":
            MessageLookupByLibrary.simpleMessage("Recent Calls"),
        "home_welcome": MessageLookupByLibrary.simpleMessage("Hello,"),
        "issues": MessageLookupByLibrary.simpleMessage("Issues Description"),
        "issuesDesc": MessageLookupByLibrary.simpleMessage(
            "Describe your issues in detail."),
        "login_btn_signin": MessageLookupByLibrary.simpleMessage("Sign In"),
        "login_btx_forgot_password_":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "login_btx_login_otp":
            MessageLookupByLibrary.simpleMessage("Login with OTP"),
        "login_btx_login_password":
            MessageLookupByLibrary.simpleMessage("Login with Password"),
        "login_btx_signup": MessageLookupByLibrary.simpleMessage(" Sign Up "),
        "login_email_caption":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "login_email_empty": MessageLookupByLibrary.simpleMessage(
            "Email address can\'t be emply"),
        "login_email_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Email Address"),
        "login_email_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid Email Address"),
        "login_footer_no_account":
            MessageLookupByLibrary.simpleMessage("Don\'t have any account?"),
        "login_header_title": MessageLookupByLibrary.simpleMessage("Login"),
        "login_password_caption":
            MessageLookupByLibrary.simpleMessage("Password"),
        "login_password_empty":
            MessageLookupByLibrary.simpleMessage("Password can\'t be emply"),
        "login_password_hint":
            MessageLookupByLibrary.simpleMessage("Enter Password"),
        "login_password_invalid": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters."),
        "meetingDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block meeting reminder notifications"),
        "meetingRem": MessageLookupByLibrary.simpleMessage("Meeting Reminder"),
        "messDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block message notifications"),
        "notiHistory": MessageLookupByLibrary.simpleMessage(
            "Sound ,notifications & others"),
        "noti_call": MessageLookupByLibrary.simpleMessage("Call"),
        "noti_group": MessageLookupByLibrary.simpleMessage("Group"),
        "noti_message": MessageLookupByLibrary.simpleMessage("Message"),
        "notyDesc":
            MessageLookupByLibrary.simpleMessage("Message,groups & call tones"),
        "otp_login_btn_resend":
            MessageLookupByLibrary.simpleMessage("Resend OTP"),
        "otp_login_btn_send": MessageLookupByLibrary.simpleMessage("Send OTP"),
        "otp_login_btn_verify":
            MessageLookupByLibrary.simpleMessage("Verify OTP"),
        "otp_login_error_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid OTP entered"),
        "otp_login_header_title":
            MessageLookupByLibrary.simpleMessage("Login with OTP"),
        "otp_login_mobile_caption":
            MessageLookupByLibrary.simpleMessage("Mobile Number"),
        "otp_login_mobile_empty": MessageLookupByLibrary.simpleMessage(
            "Mobile Number can\'t be emply"),
        "otp_login_mobile_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Mobile Number"),
        "otp_login_mobile_invalid":
            MessageLookupByLibrary.simpleMessage("Enter Valid Mobile Number"),
        "otp_login_otp_caption":
            MessageLookupByLibrary.simpleMessage("Enter OTP"),
        "otp_login_txt_in_second":
            MessageLookupByLibrary.simpleMessage("Resend OTP in 59 seconds"),
        "otp_login_txt_in_seconds": m2,
        "passReset": MessageLookupByLibrary.simpleMessage(
            "Reset password, delete account"),
        "pr_btx_all": MessageLookupByLibrary.simpleMessage("View All"),
        "pr_btx_block": MessageLookupByLibrary.simpleMessage("Block"),
        "pr_btx_report": MessageLookupByLibrary.simpleMessage("Report Contact"),
        "pr_common_groups":
            MessageLookupByLibrary.simpleMessage("Common Groups"),
        "pr_email": MessageLookupByLibrary.simpleMessage("Email Address"),
        "pr_media_shared": MessageLookupByLibrary.simpleMessage("Media Shared"),
        "pr_mute_notification":
            MessageLookupByLibrary.simpleMessage("Mute Notification"),
        "pr_name": MessageLookupByLibrary.simpleMessage("Display Name"),
        "pr_phone": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "privacyDesc": MessageLookupByLibrary.simpleMessage("Our policies"),
        "privacy_title": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "privateClassTitle":
            MessageLookupByLibrary.simpleMessage("Private Class Requests"),
        "privateDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block private class\nrequest notifications"),
        "profile_details":
            MessageLookupByLibrary.simpleMessage("Profile Details"),
        "profile_gmail":
            MessageLookupByLibrary.simpleMessage("userid@gmail.com"),
        "profile_instr":
            MessageLookupByLibrary.simpleMessage("Become An Instructor"),
        "profile_invite":
            MessageLookupByLibrary.simpleMessage("Invite a friend"),
        "profile_learning": MessageLookupByLibrary.simpleMessage("My Learning"),
        "profile_logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "profile_title": MessageLookupByLibrary.simpleMessage("Profile"),
        "reportDesc": MessageLookupByLibrary.simpleMessage(
            "Select a freature you\'re experiencing a\nproblem with:"),
        "reportTitle": MessageLookupByLibrary.simpleMessage("Report a Problem"),
        "report_title": MessageLookupByLibrary.simpleMessage("Report an issue"),
        "reposrtDesc": MessageLookupByLibrary.simpleMessage(
            "Report an issue you are facing in app"),
        "resetDesc": MessageLookupByLibrary.simpleMessage(
            "Reset all notification setting"),
        "resetNoty":
            MessageLookupByLibrary.simpleMessage("Reset Notification Setting"),
        "resetPassDesc":
            MessageLookupByLibrary.simpleMessage("Reset your password"),
        "resetTitle": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "secrityDesc":
            MessageLookupByLibrary.simpleMessage("End to End encrypted"),
        "settingChat": MessageLookupByLibrary.simpleMessage("Chats"),
        "settingHelp": MessageLookupByLibrary.simpleMessage("Help"),
        "settingRate": MessageLookupByLibrary.simpleMessage("Rate app"),
        "settingShare":
            MessageLookupByLibrary.simpleMessage("Share bVidya app"),
        "setting_title": MessageLookupByLibrary.simpleMessage("Settings"),
        "settingsNoti": MessageLookupByLibrary.simpleMessage("Notifications"),
        "showNoty": MessageLookupByLibrary.simpleMessage("Show Notifications"),
        "signup_btn_send_otp": MessageLookupByLibrary.simpleMessage("Send OTP"),
        "signup_btn_submit": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signup_confirm_password_caption":
            MessageLookupByLibrary.simpleMessage("Enter Confirm Password"),
        "signup_confirm_password_empty": MessageLookupByLibrary.simpleMessage(
            "Confirm Password can\'t be emply"),
        "signup_confirm_password_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Confirm Password"),
        "signup_confirm_password_invalid":
            MessageLookupByLibrary.simpleMessage("Confirm Password Mismatch"),
        "signup_email_caption":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "signup_email_empty": MessageLookupByLibrary.simpleMessage(
            "Email address can\'t be emply"),
        "signup_email_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Email Address"),
        "signup_email_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid Email Address"),
        "signup_error_otp_empty":
            MessageLookupByLibrary.simpleMessage("Enter the OTP"),
        "signup_error_otp_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid OTP entered"),
        "signup_footer_btx_login":
            MessageLookupByLibrary.simpleMessage(" Login "),
        "signup_footer_have_account_":
            MessageLookupByLibrary.simpleMessage("Have an Account?"),
        "signup_fullname_caption":
            MessageLookupByLibrary.simpleMessage("Full Name"),
        "signup_fullname_empty":
            MessageLookupByLibrary.simpleMessage("Full Name"),
        "signup_fullname_hint":
            MessageLookupByLibrary.simpleMessage("Full Name"),
        "signup_header_title":
            MessageLookupByLibrary.simpleMessage("Create an Account"),
        "signup_mobile_caption":
            MessageLookupByLibrary.simpleMessage("Mobile Number"),
        "signup_mobile_empty": MessageLookupByLibrary.simpleMessage(
            "Mobile Number can\'t be emply"),
        "signup_mobile_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Mobile Number"),
        "signup_mobile_invalid":
            MessageLookupByLibrary.simpleMessage("Enter Valid Mobile Number"),
        "signup_otp_caption": MessageLookupByLibrary.simpleMessage("Enter OTP"),
        "signup_password_caption":
            MessageLookupByLibrary.simpleMessage("Enter Password"),
        "signup_password_empty":
            MessageLookupByLibrary.simpleMessage("Password can\'t be emply"),
        "signup_password_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Password"),
        "signup_password_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid Password"),
        "soundDesc": MessageLookupByLibrary.simpleMessage(
            "Report an issue you are facing in app"),
        "soundTitle": MessageLookupByLibrary.simpleMessage("Sound"),
        "submitBtn": MessageLookupByLibrary.simpleMessage("Submit"),
        "sureDlt": MessageLookupByLibrary.simpleMessage("Sure, want to delete"),
        "teacher_about": MessageLookupByLibrary.simpleMessage("About"),
        "teacher_all_courses":
            MessageLookupByLibrary.simpleMessage("All Courses"),
        "teacher_exp":
            MessageLookupByLibrary.simpleMessage("7 Years of Experience"),
        "teacher_follow": MessageLookupByLibrary.simpleMessage("Follow"),
        "teacher_followers": MessageLookupByLibrary.simpleMessage("Followers"),
        "teacher_folowers_no": MessageLookupByLibrary.simpleMessage("2K"),
        "teacher_most_viewed":
            MessageLookupByLibrary.simpleMessage("Most Viewed"),
        "teacher_prep": MessageLookupByLibrary.simpleMessage("K12 & NEET"),
        "teacher_sub":
            MessageLookupByLibrary.simpleMessage("Chemistry Educator"),
        "teacher_view_all": MessageLookupByLibrary.simpleMessage("view all"),
        "teacher_watch": MessageLookupByLibrary.simpleMessage("Watch Time"),
        "teacher_watch_time": MessageLookupByLibrary.simpleMessage("57 Hours"),
        "teachers_followers":
            MessageLookupByLibrary.simpleMessage("2k Followers"),
        "teachers_header":
            MessageLookupByLibrary.simpleMessage("Teachers Followed"),
        "teachers_username":
            MessageLookupByLibrary.simpleMessage("Bhavya Malik"),
        "termsDesc":
            MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
        "terms_title": MessageLookupByLibrary.simpleMessage("Terms of Use")
      };
}
