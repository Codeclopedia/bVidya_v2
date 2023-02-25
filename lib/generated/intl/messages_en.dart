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

  static String m2(name, time) => "Missed call from ${name} at ${time}";

  static String m3(name, time) => "Missed video call from ${name} at ${time}";

  static String m4(name) => "Replying to ${name}";

  static String m5(count) => "${count} Memebers";

  static String m6(time) => "Resend OTP in ${time} seconds";

  static String m7(year) => "${year} Years of Experience";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Account": MessageLookupByLibrary.simpleMessage("Account"),
        "ChatBackup": MessageLookupByLibrary.simpleMessage("Chat Backup"),
        "ChatBackupConfirm":
            MessageLookupByLibrary.simpleMessage("Yes, Backup the chat"),
        "ChatBackupMessage": MessageLookupByLibrary.simpleMessage(
            "Do you want Backup the chat?"),
        "ClearChatConfirm":
            MessageLookupByLibrary.simpleMessage("Yes, Clear chats"),
        "ClearChatMessage": MessageLookupByLibrary.simpleMessage(
            "Do you really want to clear the chats?"),
        "ExportChat": MessageLookupByLibrary.simpleMessage("Export Chat"),
        "NoCourses":
            MessageLookupByLibrary.simpleMessage("No Courses Uploaded yet"),
        "ProblemTypeError":
            MessageLookupByLibrary.simpleMessage("Select a problem type"),
        "Requested_time_Note": MessageLookupByLibrary.simpleMessage(
            "Note: The entered Date and time will be considered as preferred Date and time. Scheduled Class Date and Time will be set according to the Instructor preferrence."),
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
        "atc_record": MessageLookupByLibrary.simpleMessage("Record Video"),
        "bchat": MessageLookupByLibrary.simpleMessage("bChat"),
        "bchat_conv_delete":
            MessageLookupByLibrary.simpleMessage("Delete Conversation"),
        "bchat_conv_mute":
            MessageLookupByLibrary.simpleMessage("Mute Conversation"),
        "bchat_conv_read": MessageLookupByLibrary.simpleMessage("Mark as Read"),
        "bchat_conv_unmute":
            MessageLookupByLibrary.simpleMessage("Unmute Conversation"),
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
        "blearn_instructors":
            MessageLookupByLibrary.simpleMessage("Instructors"),
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
            MessageLookupByLibrary.simpleMessage("Broadcast description"),
        "blive_caption_image":
            MessageLookupByLibrary.simpleMessage("Select an Image"),
        "blive_caption_starttime":
            MessageLookupByLibrary.simpleMessage("Broadcast Time"),
        "blive_caption_title":
            MessageLookupByLibrary.simpleMessage("Broadcast title"),
        "blive_date_meeting": m0,
        "blive_empty_date":
            MessageLookupByLibrary.simpleMessage("Enter meeting date"),
        "blive_empty_desc": MessageLookupByLibrary.simpleMessage(
            "Broadcast description can\'t be emplty"),
        "blive_empty_time":
            MessageLookupByLibrary.simpleMessage("Enter Broadcast time"),
        "blive_empty_title": MessageLookupByLibrary.simpleMessage(
            "Broadcast title can\'t be emplty"),
        "blive_hint_date": MessageLookupByLibrary.simpleMessage("Select Date"),
        "blive_hint_desc": MessageLookupByLibrary.simpleMessage(
            "Enter Your Broadcast Description"),
        "blive_hint_link":
            MessageLookupByLibrary.simpleMessage("Enter Broadcast ID or Link."),
        "blive_hint_time": MessageLookupByLibrary.simpleMessage("Time"),
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
        "blive_no_meetings":
            MessageLookupByLibrary.simpleMessage("No scheduled Broadcast."),
        "blive_schedule_heading":
            MessageLookupByLibrary.simpleMessage("Schedule a Broadcast"),
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
        "blockedUser": MessageLookupByLibrary.simpleMessage("Blocked Users"),
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
        "bmeet_no_meetings":
            MessageLookupByLibrary.simpleMessage("No scheduled Meetings."),
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
        "bmeet_tool_more": MessageLookupByLibrary.simpleMessage("More"),
        "bmeet_tool_mute": MessageLookupByLibrary.simpleMessage("Mute"),
        "bmeet_tool_participants":
            MessageLookupByLibrary.simpleMessage("Participants"),
        "bmeet_tool_raisehand":
            MessageLookupByLibrary.simpleMessage("Raise Hand"),
        "bmeet_tool_share_screen":
            MessageLookupByLibrary.simpleMessage("Share Screen"),
        "bmeet_tool_stop_sshare":
            MessageLookupByLibrary.simpleMessage("Stop Share"),
        "bmeet_tool_stop_video":
            MessageLookupByLibrary.simpleMessage("Stop Video"),
        "bmeet_tool_unmute": MessageLookupByLibrary.simpleMessage("Unmute"),
        "bmeet_tool_video": MessageLookupByLibrary.simpleMessage("Video"),
        "bmeet_txt_meeting": MessageLookupByLibrary.simpleMessage("Meeting"),
        "bmeet_txt_schedule":
            MessageLookupByLibrary.simpleMessage("Scheduled Meetings"),
        "bmeet_txt_start_desc": MessageLookupByLibrary.simpleMessage(
            "Generate your meeting link to begin."),
        "bmeet_user_you": MessageLookupByLibrary.simpleMessage("You"),
        "bmeet_videooff_desc": MessageLookupByLibrary.simpleMessage(
            "Grand or restrict video access"),
        "bmeet_videooff_title": MessageLookupByLibrary.simpleMessage(
            "Always turn off my camera on start"),
        "bmmet_txt_start_title":
            MessageLookupByLibrary.simpleMessage("Start Instant Meeting"),
        "btn_continue": MessageLookupByLibrary.simpleMessage("Continue"),
        "btn_create": MessageLookupByLibrary.simpleMessage("Create"),
        "btn_end": MessageLookupByLibrary.simpleMessage("End"),
        "btn_ok": MessageLookupByLibrary.simpleMessage("OK"),
        "btn_remove": MessageLookupByLibrary.simpleMessage("Remove"),
        "btn_update": MessageLookupByLibrary.simpleMessage("Update"),
        "btn_yes_logout":
            MessageLookupByLibrary.simpleMessage("Sure, want to logout"),
        "callDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block call notifications"),
        "chatHistory": MessageLookupByLibrary.simpleMessage(
            "Chat history,themes,wallpapers"),
        "chat_input_hint":
            MessageLookupByLibrary.simpleMessage("Write your message"),
        "chat_menu_copy": MessageLookupByLibrary.simpleMessage("Copy"),
        "chat_menu_delete": MessageLookupByLibrary.simpleMessage("Delete"),
        "chat_menu_forward": MessageLookupByLibrary.simpleMessage("Forward"),
        "chat_menu_reply": MessageLookupByLibrary.simpleMessage("Reply"),
        "chat_menu_title": MessageLookupByLibrary.simpleMessage("Options"),
        "chat_missed_call": m2,
        "chat_missed_call_video": m3,
        "chat_replying": m4,
        "chat_yourself": MessageLookupByLibrary.simpleMessage("Yourself"),
        "class_request_title":
            MessageLookupByLibrary.simpleMessage("Class Requested to"),
        "class_requested_title":
            MessageLookupByLibrary.simpleMessage("Class Requested by"),
        "clearChat": MessageLookupByLibrary.simpleMessage("Clear Chat"),
        "coming_soon": MessageLookupByLibrary.simpleMessage("Coming Soon..."),
        "confDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block conference reminder notifications"),
        "confRem": MessageLookupByLibrary.simpleMessage("Conference Reminder"),
        "contactDesc":
            MessageLookupByLibrary.simpleMessage("Questions? need help?"),
        "contactHint": MessageLookupByLibrary.simpleMessage(
            "Tell us how can we help you."),
        "contactQuery": MessageLookupByLibrary.simpleMessage(
            "Write us your query and we\'ll get back to you soon!"),
        "contact_menu_block":
            MessageLookupByLibrary.simpleMessage("Block Contact"),
        "contact_menu_delete":
            MessageLookupByLibrary.simpleMessage("Delete Contact"),
        "contact_menu_request":
            MessageLookupByLibrary.simpleMessage("Send Request"),
        "contact_menu_unblock":
            MessageLookupByLibrary.simpleMessage("Unblock Contact"),
        "contact_menu_view":
            MessageLookupByLibrary.simpleMessage("View Profile"),
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
            MessageLookupByLibrary.simpleMessage("Delete your Account"),
        "dg_confirm_deleteAccount":
            MessageLookupByLibrary.simpleMessage("Yes, Delete my account."),
        "dg_message_DeleteAccount": MessageLookupByLibrary.simpleMessage(
            "If you click on Yes, your account will be permanently deleted. You have 30 days to prevent your account from being permanently deleted if you change your mind."),
        "dg_message_live_scheduled": MessageLookupByLibrary.simpleMessage(
            "Live session has been scheduled. You can see the details in the scheduled list."),
        "dg_message_logout": MessageLookupByLibrary.simpleMessage(
            "Are you sure want to logout your account?"),
        "dg_message_meeting_scheduled": MessageLookupByLibrary.simpleMessage(
            "Meeting has been scheduled. You can see the details in the scheduled meeting list."),
        "dg_title_DeleteAccount":
            MessageLookupByLibrary.simpleMessage("Delete Account"),
        "dg_title_live_scheduled":
            MessageLookupByLibrary.simpleMessage("Live Session Scheduled"),
        "dg_title_logout":
            MessageLookupByLibrary.simpleMessage("Logout Account"),
        "dg_title_meeting_scheduled":
            MessageLookupByLibrary.simpleMessage("Meeting Scheduled"),
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
        "empty_class_request":
            MessageLookupByLibrary.simpleMessage("No Class Requests."),
        "error": MessageLookupByLibrary.simpleMessage(
            "Something went wrong! Try again."),
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
            "Email address can\'t be empty"),
        "fp_email_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Email Address"),
        "fp_email_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid Email Address"),
        "fp_header_title":
            MessageLookupByLibrary.simpleMessage("Forgot Password"),
        "groupDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block group notifications"),
        "group_empty_no_contacts":
            MessageLookupByLibrary.simpleMessage("No Contacts"),
        "group_error_creating":
            MessageLookupByLibrary.simpleMessage("Error in creating group"),
        "group_error_empty":
            MessageLookupByLibrary.simpleMessage("Group Name can\'t be empty"),
        "group_error_invalid":
            MessageLookupByLibrary.simpleMessage("Group Name very short"),
        "groups_create_caption":
            MessageLookupByLibrary.simpleMessage("Group Title"),
        "groups_create_edit_title":
            MessageLookupByLibrary.simpleMessage("Edit Group"),
        "groups_create_hint_name":
            MessageLookupByLibrary.simpleMessage("Enter group name"),
        "groups_create_subject":
            MessageLookupByLibrary.simpleMessage("Add Subject"),
        "groups_create_title":
            MessageLookupByLibrary.simpleMessage("New Group"),
        "grp_btx_clear": MessageLookupByLibrary.simpleMessage("Clear Chat"),
        "grp_btx_exit": MessageLookupByLibrary.simpleMessage("Exit Group"),
        "grp_btx_report": MessageLookupByLibrary.simpleMessage("Report Group"),
        "grp_caption_participation":
            MessageLookupByLibrary.simpleMessage("Participants"),
        "grp_chat_members": m5,
        "grp_txt_add_participant":
            MessageLookupByLibrary.simpleMessage("Add Participants"),
        "helpCenter": MessageLookupByLibrary.simpleMessage(
            "Help Center, Report Problem, Privacy Policy"),
        "home_btx_groups": MessageLookupByLibrary.simpleMessage("Groups"),
        "home_btx_new_group": MessageLookupByLibrary.simpleMessage("New Group"),
        "home_btx_new_message":
            MessageLookupByLibrary.simpleMessage("New Message"),
        "home_btx_recent_calls":
            MessageLookupByLibrary.simpleMessage("Recent Calls"),
        "home_welcome": MessageLookupByLibrary.simpleMessage("Hello,"),
        "im_picker_camera_desc":
            MessageLookupByLibrary.simpleMessage("Take a picture from Camera"),
        "im_picker_gallery_desc":
            MessageLookupByLibrary.simpleMessage("Pick an image from Gallery"),
        "instructor_notApproved_note": MessageLookupByLibrary.simpleMessage(
            "NOTE: Teacher-specific features will remain unavailable till the bvidya team approves your profile. In case of any questions, you may contact our support team at info@bvidya.com"),
        "issueDescriptionError": MessageLookupByLibrary.simpleMessage(
            "Issue description can\'t be empty"),
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
            "Email address can\'t be empty"),
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
            MessageLookupByLibrary.simpleMessage("Password can\'t be empty"),
        "login_password_hint":
            MessageLookupByLibrary.simpleMessage("Enter Password"),
        "login_password_invalid": MessageLookupByLibrary.simpleMessage(
            "Password must be at least 8 characters."),
        "meetingDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block meeting reminder notifications"),
        "meetingRem": MessageLookupByLibrary.simpleMessage("Meeting Reminder"),
        "menu_call": MessageLookupByLibrary.simpleMessage("Call"),
        "menu_delete": MessageLookupByLibrary.simpleMessage("Delete"),
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
            "Mobile Number can\'t be empty"),
        "otp_login_mobile_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Mobile Number"),
        "otp_login_mobile_invalid":
            MessageLookupByLibrary.simpleMessage("Enter Valid Mobile Number"),
        "otp_login_otp_caption":
            MessageLookupByLibrary.simpleMessage("Enter OTP"),
        "otp_login_txt_in_second":
            MessageLookupByLibrary.simpleMessage("Resend OTP in 59 seconds"),
        "otp_login_txt_in_seconds": m6,
        "passReset": MessageLookupByLibrary.simpleMessage(
            "Reset Password, Delete Account"),
        "pr_btx_all": MessageLookupByLibrary.simpleMessage("View All"),
        "pr_btx_block": MessageLookupByLibrary.simpleMessage("Block"),
        "pr_btx_report": MessageLookupByLibrary.simpleMessage("Report Contact"),
        "pr_btx_unblock": MessageLookupByLibrary.simpleMessage("Unblock"),
        "pr_common_groups":
            MessageLookupByLibrary.simpleMessage("Common Groups"),
        "pr_email": MessageLookupByLibrary.simpleMessage("Email Address"),
        "pr_media_shared": MessageLookupByLibrary.simpleMessage("Media Shared"),
        "pr_mute_notification":
            MessageLookupByLibrary.simpleMessage("Mute Notification"),
        "pr_name": MessageLookupByLibrary.simpleMessage("Display Name"),
        "pr_phone": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "preferredDate": MessageLookupByLibrary.simpleMessage("Preferred Date"),
        "preferredTime": MessageLookupByLibrary.simpleMessage("Preferred Time"),
        "privacyDesc": MessageLookupByLibrary.simpleMessage("Our policies"),
        "privacy_title": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
        "privateClassTitle":
            MessageLookupByLibrary.simpleMessage("Private Class Requests"),
        "privateDesc": MessageLookupByLibrary.simpleMessage(
            "Toggle to receive or block private class\nrequest notifications"),
        "prof_edit_address": MessageLookupByLibrary.simpleMessage("Address"),
        "prof_edit_age": MessageLookupByLibrary.simpleMessage("Age"),
        "prof_edit_email":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "prof_edit_name": MessageLookupByLibrary.simpleMessage("Name"),
        "prof_edit_no": MessageLookupByLibrary.simpleMessage("Phone Number"),
        "prof_edit_title":
            MessageLookupByLibrary.simpleMessage("Profile Detail"),
        "prof_hint_add":
            MessageLookupByLibrary.simpleMessage("Enter Your Address"),
        "prof_hint_age": MessageLookupByLibrary.simpleMessage("Enter Your Age"),
        "prof_hint_email":
            MessageLookupByLibrary.simpleMessage("Enter Your EmailId"),
        "prof_hint_name":
            MessageLookupByLibrary.simpleMessage("Enter Your Name"),
        "prof_hint_no":
            MessageLookupByLibrary.simpleMessage("Enter Your Phone Number"),
        "prof_save_btn": MessageLookupByLibrary.simpleMessage("Save"),
        "profile_details":
            MessageLookupByLibrary.simpleMessage("Profile Details"),
        "profile_gmail":
            MessageLookupByLibrary.simpleMessage("userid@gmail.com"),
        "profile_instr":
            MessageLookupByLibrary.simpleMessage("Become An Instructor"),
        "profile_invite":
            MessageLookupByLibrary.simpleMessage("Invite a Friend"),
        "profile_learning": MessageLookupByLibrary.simpleMessage("My Learning"),
        "profile_logout": MessageLookupByLibrary.simpleMessage("Logout"),
        "profile_title": MessageLookupByLibrary.simpleMessage("Profile"),
        "recent_call_no_calls":
            MessageLookupByLibrary.simpleMessage("No Calls"),
        "recent_call_title": MessageLookupByLibrary.simpleMessage("Recent"),
        "reportDesc": MessageLookupByLibrary.simpleMessage(
            "Select a feature you\'re experiencing a\nproblem with:"),
        "reportTitle": MessageLookupByLibrary.simpleMessage("Report a Problem"),
        "report_title": MessageLookupByLibrary.simpleMessage("Report an Issue"),
        "reposrtDesc": MessageLookupByLibrary.simpleMessage(
            "Report an Issue you are facing in app"),
        "request_class":
            MessageLookupByLibrary.simpleMessage("Request a class"),
        "request_class_description":
            MessageLookupByLibrary.simpleMessage("Description"),
        "request_class_description_hint":
            MessageLookupByLibrary.simpleMessage("Add Description"),
        "request_class_group": MessageLookupByLibrary.simpleMessage("group"),
        "request_class_private":
            MessageLookupByLibrary.simpleMessage("private"),
        "request_class_request":
            MessageLookupByLibrary.simpleMessage("Request"),
        "request_class_title":
            MessageLookupByLibrary.simpleMessage("Request Class"),
        "request_class_topic": MessageLookupByLibrary.simpleMessage("Topic"),
        "request_class_topic_hint": MessageLookupByLibrary.simpleMessage(
            "Enter class topic or subject"),
        "request_class_type":
            MessageLookupByLibrary.simpleMessage("Class Type"),
        "request_class_type_hint":
            MessageLookupByLibrary.simpleMessage("Select"),
        "requestclass": MessageLookupByLibrary.simpleMessage("Request a class"),
        "resetDesc": MessageLookupByLibrary.simpleMessage(
            "Reset all notification setting"),
        "resetNoty":
            MessageLookupByLibrary.simpleMessage("Reset Notification Setting"),
        "resetPassDesc":
            MessageLookupByLibrary.simpleMessage("Reset your Password"),
        "resetTitle": MessageLookupByLibrary.simpleMessage("Reset Password"),
        "search_contact_ppl": MessageLookupByLibrary.simpleMessage("People"),
        "secrityDesc":
            MessageLookupByLibrary.simpleMessage("End-to-End encrypted"),
        "settingChat": MessageLookupByLibrary.simpleMessage("Chats"),
        "settingHelp": MessageLookupByLibrary.simpleMessage("Help"),
        "settingRate": MessageLookupByLibrary.simpleMessage("Rate App"),
        "settingShare":
            MessageLookupByLibrary.simpleMessage("Share bVidya App"),
        "setting_title": MessageLookupByLibrary.simpleMessage("Settings"),
        "settingsNoti": MessageLookupByLibrary.simpleMessage("Notifications"),
        "showNoty": MessageLookupByLibrary.simpleMessage("Show Notifications"),
        "signup_btn_send_otp": MessageLookupByLibrary.simpleMessage("Send OTP"),
        "signup_btn_submit": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "signup_confirm_password_caption":
            MessageLookupByLibrary.simpleMessage("Enter Confirm Password"),
        "signup_confirm_password_empty": MessageLookupByLibrary.simpleMessage(
            "Confirm Password can\'t be empty"),
        "signup_confirm_password_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Confirm Password"),
        "signup_confirm_password_invalid":
            MessageLookupByLibrary.simpleMessage("Confirm Password Mismatch"),
        "signup_email_caption":
            MessageLookupByLibrary.simpleMessage("Email Address"),
        "signup_email_empty": MessageLookupByLibrary.simpleMessage(
            "Email address can\'t be empty"),
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
            MessageLookupByLibrary.simpleMessage("Full Name can\'t be empty"),
        "signup_fullname_hint":
            MessageLookupByLibrary.simpleMessage("Full Name"),
        "signup_header_title":
            MessageLookupByLibrary.simpleMessage("Create an Account"),
        "signup_mobile_caption":
            MessageLookupByLibrary.simpleMessage("Mobile Number"),
        "signup_mobile_empty": MessageLookupByLibrary.simpleMessage(
            "Mobile Number can\'t be empty"),
        "signup_mobile_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Mobile Number"),
        "signup_mobile_invalid":
            MessageLookupByLibrary.simpleMessage("Enter Valid Mobile Number"),
        "signup_otp_caption": MessageLookupByLibrary.simpleMessage("Enter OTP"),
        "signup_password_caption":
            MessageLookupByLibrary.simpleMessage("Enter Password"),
        "signup_password_empty":
            MessageLookupByLibrary.simpleMessage("Password can\'t be empty"),
        "signup_password_hint":
            MessageLookupByLibrary.simpleMessage("Enter Your Password"),
        "signup_password_invalid":
            MessageLookupByLibrary.simpleMessage("Invalid Password"),
        "soundDesc": MessageLookupByLibrary.simpleMessage(
            "Report an issue you are facing in app"),
        "soundTitle": MessageLookupByLibrary.simpleMessage("Sound"),
        "sp_tab_course": MessageLookupByLibrary.simpleMessage("Courses"),
        "sp_tab_followed":
            MessageLookupByLibrary.simpleMessage("Teacher Followed"),
        "submitBtn": MessageLookupByLibrary.simpleMessage("Submit"),
        "sureDlt": MessageLookupByLibrary.simpleMessage("Sure, want to delete"),
        "t_request_class_description_invalid":
            MessageLookupByLibrary.simpleMessage(
                "Class Request description must contains at least 5 characters"),
        "t_request_class_empty_description":
            MessageLookupByLibrary.simpleMessage(
                "Class Request description type can\'t be empty"),
        "t_request_class_empty_topic":
            MessageLookupByLibrary.simpleMessage("Class topic can\'t be empty"),
        "t_request_class_empty_type": MessageLookupByLibrary.simpleMessage(
            "Class request type can\'t be empty"),
        "t_request_class_topic_invalid": MessageLookupByLibrary.simpleMessage(
            "Class topic must contains at least 5 characters"),
        "t_request_class_type_hint":
            MessageLookupByLibrary.simpleMessage("Select Class type"),
        "t_schedule_caption":
            MessageLookupByLibrary.simpleMessage("Upcoming classes"),
        "t_schedule_class":
            MessageLookupByLibrary.simpleMessage("Schedule a Class"),
        "t_schedule_class_msg": MessageLookupByLibrary.simpleMessage(
            "Send Request for group or personal class"),
        "t_schedule_no_class":
            MessageLookupByLibrary.simpleMessage("No Upcoming class"),
        "t_scheduled_header":
            MessageLookupByLibrary.simpleMessage("Scheduled classes"),
        "td_amt": MessageLookupByLibrary.simpleMessage("₹ 20,456"),
        "td_courses": MessageLookupByLibrary.simpleMessage("Uploaded Courses"),
        "td_dash": MessageLookupByLibrary.simpleMessage("Dashboard"),
        "td_hrs": MessageLookupByLibrary.simpleMessage("Total Watch Time"),
        "td_revenue":
            MessageLookupByLibrary.simpleMessage("Total Revnue Generated"),
        "td_running":
            MessageLookupByLibrary.simpleMessage("Top Running Courses"),
        "td_subs": MessageLookupByLibrary.simpleMessage("Total Subscribers"),
        "td_total_subs": MessageLookupByLibrary.simpleMessage("2.6 K"),
        "td_watch_time": MessageLookupByLibrary.simpleMessage("60+ hrs"),
        "teacher_about": MessageLookupByLibrary.simpleMessage("About"),
        "teacher_all_courses":
            MessageLookupByLibrary.simpleMessage("All Courses"),
        "teacher_exp":
            MessageLookupByLibrary.simpleMessage("7 Years of Experience"),
        "teacher_exp_value": m7,
        "teacher_follow": MessageLookupByLibrary.simpleMessage("Follow"),
        "teacher_followed": MessageLookupByLibrary.simpleMessage("Followed"),
        "teacher_followers": MessageLookupByLibrary.simpleMessage("Followers"),
        "teacher_folowers_no": MessageLookupByLibrary.simpleMessage("2K"),
        "teacher_most_viewed":
            MessageLookupByLibrary.simpleMessage("Most Viewed"),
        "teacher_prep": MessageLookupByLibrary.simpleMessage("K12 & NEET"),
        "teacher_sub":
            MessageLookupByLibrary.simpleMessage("Chemistry Educator"),
        "teacher_view_all": MessageLookupByLibrary.simpleMessage("View all >"),
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
        "terms_title": MessageLookupByLibrary.simpleMessage("Terms of Use"),
        "tp_classes": MessageLookupByLibrary.simpleMessage("Class Requests"),
        "tp_dashboard": MessageLookupByLibrary.simpleMessage("My Dashboard"),
        "tp_schedule": MessageLookupByLibrary.simpleMessage("My Schedule"),
        "tpe_bio": MessageLookupByLibrary.simpleMessage("Bio"),
        "tpe_bio_hint": MessageLookupByLibrary.simpleMessage("Enter your bio"),
        "tpe_lang": MessageLookupByLibrary.simpleMessage("Language Known"),
        "tpe_lang_hint":
            MessageLookupByLibrary.simpleMessage("What language do you know?"),
        "tpe_worked": MessageLookupByLibrary.simpleMessage("Worked At"),
        "tpe_worked_hint": MessageLookupByLibrary.simpleMessage(
            "What was the name of our previous Organzation?")
      };
}
