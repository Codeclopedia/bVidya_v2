// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to bvidya`
  String get intro_screen_1_title {
    return Intl.message(
      'Welcome to bvidya',
      name: 'intro_screen_1_title',
      desc: '',
      args: [],
    );
  }

  /// `Chat easily via bChat`
  String get intro_screen_2_title {
    return Intl.message(
      'Chat easily via bChat',
      name: 'intro_screen_2_title',
      desc: '',
      args: [],
    );
  }

  /// `Meet via bMeet`
  String get intro_screen_3_title {
    return Intl.message(
      'Meet via bMeet',
      name: 'intro_screen_3_title',
      desc: '',
      args: [],
    );
  }

  /// `Go Live via bLive`
  String get intro_screen_4_title {
    return Intl.message(
      'Go Live via bLive',
      name: 'intro_screen_4_title',
      desc: '',
      args: [],
    );
  }

  /// `Learn via bLearn`
  String get intro_screen_5_title {
    return Intl.message(
      'Learn via bLearn',
      name: 'intro_screen_5_title',
      desc: '',
      args: [],
    );
  }

  /// `Let's Explore bvidya`
  String get intro_screen_6_title {
    return Intl.message(
      'Let\'s Explore bvidya',
      name: 'intro_screen_6_title',
      desc: '',
      args: [],
    );
  }

  /// `Begin your Online Education Journey with the best Leading Application.`
  String get intro_screen_1_desc {
    return Intl.message(
      'Begin your Online Education Journey with the best Leading Application.',
      name: 'intro_screen_1_desc',
      desc: '',
      args: [],
    );
  }

  /// `Connect faster with teachers through Messenger and get Instant replies to your queries.`
  String get intro_screen_2_desc {
    return Intl.message(
      'Connect faster with teachers through Messenger and get Instant replies to your queries.',
      name: 'intro_screen_2_desc',
      desc: '',
      args: [],
    );
  }

  /// `Start Video conferencing with a group of people which even helps in recording sessions.`
  String get intro_screen_3_desc {
    return Intl.message(
      'Start Video conferencing with a group of people which even helps in recording sessions.',
      name: 'intro_screen_3_desc',
      desc: '',
      args: [],
    );
  }

  /// `A Simple process to create and record Live videos to engage with multiple audiences.`
  String get intro_screen_4_desc {
    return Intl.message(
      'A Simple process to create and record Live videos to engage with multiple audiences.',
      name: 'intro_screen_4_desc',
      desc: '',
      args: [],
    );
  }

  /// `Keep yourself updated about upcoming Webinars, new Courses, Teachers' profiles, etc.`
  String get intro_screen_5_desc {
    return Intl.message(
      'Keep yourself updated about upcoming Webinars, new Courses, Teachers\' profiles, etc.',
      name: 'intro_screen_5_desc',
      desc: '',
      args: [],
    );
  }

  /// `Are you ready to start your Online education journey on this Top-notch Application?`
  String get intro_screen_6_desc {
    return Intl.message(
      'Are you ready to start your Online education journey on this Top-notch Application?',
      name: 'intro_screen_6_desc',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login_header_title {
    return Intl.message(
      'Login',
      name: 'login_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get login_email_caption {
    return Intl.message(
      'Email Address',
      name: 'login_email_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get login_email_hint {
    return Intl.message(
      'Enter Your Email Address',
      name: 'login_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Email address can't be empty`
  String get login_email_empty {
    return Intl.message(
      'Email address can\'t be empty',
      name: 'login_email_empty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email Address`
  String get login_email_invalid {
    return Intl.message(
      'Invalid Email Address',
      name: 'login_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get login_password_caption {
    return Intl.message(
      'Password',
      name: 'login_password_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get login_password_hint {
    return Intl.message(
      'Enter Password',
      name: 'login_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password can't be empty`
  String get login_password_empty {
    return Intl.message(
      'Password can\'t be empty',
      name: 'login_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters.`
  String get login_password_invalid {
    return Intl.message(
      'Password must be at least 8 characters.',
      name: 'login_password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get login_btx_forgot_password_ {
    return Intl.message(
      'Forgot Password?',
      name: 'login_btx_forgot_password_',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get login_btn_signin {
    return Intl.message(
      'Sign In',
      name: 'login_btn_signin',
      desc: '',
      args: [],
    );
  }

  /// `Login with OTP`
  String get login_btx_login_otp {
    return Intl.message(
      'Login with OTP',
      name: 'login_btx_login_otp',
      desc: '',
      args: [],
    );
  }

  /// `Don't have any account?`
  String get login_footer_no_account {
    return Intl.message(
      'Don\'t have any account?',
      name: 'login_footer_no_account',
      desc: '',
      args: [],
    );
  }

  /// ` Sign Up `
  String get login_btx_signup {
    return Intl.message(
      ' Sign Up ',
      name: 'login_btx_signup',
      desc: '',
      args: [],
    );
  }

  /// `Login with OTP`
  String get otp_login_header_title {
    return Intl.message(
      'Login with OTP',
      name: 'otp_login_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get otp_login_mobile_caption {
    return Intl.message(
      'Mobile Number',
      name: 'otp_login_mobile_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Mobile Number`
  String get otp_login_mobile_hint {
    return Intl.message(
      'Enter Your Mobile Number',
      name: 'otp_login_mobile_hint',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number can't be empty`
  String get otp_login_mobile_empty {
    return Intl.message(
      'Mobile Number can\'t be empty',
      name: 'otp_login_mobile_empty',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Mobile Number`
  String get otp_login_mobile_invalid {
    return Intl.message(
      'Enter Valid Mobile Number',
      name: 'otp_login_mobile_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get otp_login_otp_caption {
    return Intl.message(
      'Enter OTP',
      name: 'otp_login_otp_caption',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP entered`
  String get otp_login_error_invalid {
    return Intl.message(
      'Invalid OTP entered',
      name: 'otp_login_error_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get otp_login_btn_send {
    return Intl.message(
      'Send OTP',
      name: 'otp_login_btn_send',
      desc: '',
      args: [],
    );
  }

  /// `Verify OTP`
  String get otp_login_btn_verify {
    return Intl.message(
      'Verify OTP',
      name: 'otp_login_btn_verify',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get otp_login_btn_resend {
    return Intl.message(
      'Resend OTP',
      name: 'otp_login_btn_resend',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP in 59 seconds`
  String get otp_login_txt_in_second {
    return Intl.message(
      'Resend OTP in 59 seconds',
      name: 'otp_login_txt_in_second',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP in {time} seconds`
  String otp_login_txt_in_seconds(Object time) {
    return Intl.message(
      'Resend OTP in $time seconds',
      name: 'otp_login_txt_in_seconds',
      desc: '',
      args: [time],
    );
  }

  /// `Login with Password`
  String get login_btx_login_password {
    return Intl.message(
      'Login with Password',
      name: 'login_btx_login_password',
      desc: '',
      args: [],
    );
  }

  /// `Create an Account`
  String get signup_header_title {
    return Intl.message(
      'Create an Account',
      name: 'signup_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get signup_fullname_caption {
    return Intl.message(
      'Full Name',
      name: 'signup_fullname_caption',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get signup_fullname_hint {
    return Intl.message(
      'Full Name',
      name: 'signup_fullname_hint',
      desc: '',
      args: [],
    );
  }

  /// `Full Name can't be empty`
  String get signup_fullname_empty {
    return Intl.message(
      'Full Name can\'t be empty',
      name: 'signup_fullname_empty',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get signup_email_caption {
    return Intl.message(
      'Email Address',
      name: 'signup_email_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get signup_email_hint {
    return Intl.message(
      'Enter Your Email Address',
      name: 'signup_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Email address can't be empty`
  String get signup_email_empty {
    return Intl.message(
      'Email address can\'t be empty',
      name: 'signup_email_empty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email Address`
  String get signup_email_invalid {
    return Intl.message(
      'Invalid Email Address',
      name: 'signup_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get signup_mobile_caption {
    return Intl.message(
      'Mobile Number',
      name: 'signup_mobile_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Mobile Number`
  String get signup_mobile_hint {
    return Intl.message(
      'Enter Your Mobile Number',
      name: 'signup_mobile_hint',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number can't be empty`
  String get signup_mobile_empty {
    return Intl.message(
      'Mobile Number can\'t be empty',
      name: 'signup_mobile_empty',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Mobile Number`
  String get signup_mobile_invalid {
    return Intl.message(
      'Enter Valid Mobile Number',
      name: 'signup_mobile_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Enter Password`
  String get signup_password_caption {
    return Intl.message(
      'Enter Password',
      name: 'signup_password_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Password`
  String get signup_password_hint {
    return Intl.message(
      'Enter Your Password',
      name: 'signup_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Password can't be empty`
  String get signup_password_empty {
    return Intl.message(
      'Password can\'t be empty',
      name: 'signup_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Password`
  String get signup_password_invalid {
    return Intl.message(
      'Invalid Password',
      name: 'signup_password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get signup_field_edit {
    return Intl.message(
      'Edit',
      name: 'signup_field_edit',
      desc: '',
      args: [],
    );
  }

  /// `Enter Confirm Password`
  String get signup_confirm_password_caption {
    return Intl.message(
      'Enter Confirm Password',
      name: 'signup_confirm_password_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Confirm Password`
  String get signup_confirm_password_hint {
    return Intl.message(
      'Enter Your Confirm Password',
      name: 'signup_confirm_password_hint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password can't be empty`
  String get signup_confirm_password_empty {
    return Intl.message(
      'Confirm Password can\'t be empty',
      name: 'signup_confirm_password_empty',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password Mismatch`
  String get signup_confirm_password_invalid {
    return Intl.message(
      'Confirm Password Mismatch',
      name: 'signup_confirm_password_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Accept Terms and Conditions to get started.`
  String get signup_accept_terms_msg {
    return Intl.message(
      'Accept Terms and Conditions to get started.',
      name: 'signup_accept_terms_msg',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get signup_otp_caption {
    return Intl.message(
      'Enter OTP',
      name: 'signup_otp_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter the OTP`
  String get signup_error_otp_empty {
    return Intl.message(
      'Enter the OTP',
      name: 'signup_error_otp_empty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP entered`
  String get signup_error_otp_invalid {
    return Intl.message(
      'Invalid OTP entered',
      name: 'signup_error_otp_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup_btn_submit {
    return Intl.message(
      'Sign Up',
      name: 'signup_btn_submit',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get signup_btn_send_otp {
    return Intl.message(
      'Send OTP',
      name: 'signup_btn_send_otp',
      desc: '',
      args: [],
    );
  }

  /// `Have an Account?`
  String get signup_footer_have_account_ {
    return Intl.message(
      'Have an Account?',
      name: 'signup_footer_have_account_',
      desc: '',
      args: [],
    );
  }

  /// ` Login `
  String get signup_footer_btx_login {
    return Intl.message(
      ' Login ',
      name: 'signup_footer_btx_login',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get fp_header_title {
    return Intl.message(
      'Forgot Password',
      name: 'fp_header_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email associated with your account and we'll send an email with instructions to reset your password.`
  String get fp_desc_message {
    return Intl.message(
      'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.',
      name: 'fp_desc_message',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get fp_email_caption {
    return Intl.message(
      'Email Address',
      name: 'fp_email_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get fp_email_hint {
    return Intl.message(
      'Enter Your Email Address',
      name: 'fp_email_hint',
      desc: '',
      args: [],
    );
  }

  /// `Email address can't be empty`
  String get fp_email_empty {
    return Intl.message(
      'Email address can\'t be empty',
      name: 'fp_email_empty',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email Address`
  String get fp_email_invalid {
    return Intl.message(
      'Invalid Email Address',
      name: 'fp_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get fp_btn_submit {
    return Intl.message(
      'Submit',
      name: 'fp_btn_submit',
      desc: '',
      args: [],
    );
  }

  /// `Back to Login`
  String get fp_btx_login_back {
    return Intl.message(
      'Back to Login',
      name: 'fp_btx_login_back',
      desc: '',
      args: [],
    );
  }

  /// `Setting`
  String get drawer_setting {
    return Intl.message(
      'Setting',
      name: 'drawer_setting',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get drawer_profile {
    return Intl.message(
      'Profile',
      name: 'drawer_profile',
      desc: '',
      args: [],
    );
  }

  /// `Discuss`
  String get drawer_disucss {
    return Intl.message(
      'Discuss',
      name: 'drawer_disucss',
      desc: '',
      args: [],
    );
  }

  /// `Forum`
  String get drawer_forum {
    return Intl.message(
      'Forum',
      name: 'drawer_forum',
      desc: '',
      args: [],
    );
  }

  /// `bLive`
  String get drawer_blive {
    return Intl.message(
      'bLive',
      name: 'drawer_blive',
      desc: '',
      args: [],
    );
  }

  /// `bMeet`
  String get drawer_bmeet {
    return Intl.message(
      'bMeet',
      name: 'drawer_bmeet',
      desc: '',
      args: [],
    );
  }

  /// `bLearn`
  String get drawer_blearn {
    return Intl.message(
      'bLearn',
      name: 'drawer_blearn',
      desc: '',
      args: [],
    );
  }

  /// `bChat`
  String get drawer_bchat {
    return Intl.message(
      'bChat',
      name: 'drawer_bchat',
      desc: '',
      args: [],
    );
  }

  /// `Hello,`
  String get home_welcome {
    return Intl.message(
      'Hello,',
      name: 'home_welcome',
      desc: '',
      args: [],
    );
  }

  /// `Recent Calls`
  String get home_btx_recent_calls {
    return Intl.message(
      'Recent Calls',
      name: 'home_btx_recent_calls',
      desc: '',
      args: [],
    );
  }

  /// `New Message`
  String get home_btx_new_message {
    return Intl.message(
      'New Message',
      name: 'home_btx_new_message',
      desc: '',
      args: [],
    );
  }

  /// `My Contacts`
  String get home_btx_my_contacts {
    return Intl.message(
      'My Contacts',
      name: 'home_btx_my_contacts',
      desc: '',
      args: [],
    );
  }

  /// `New Group`
  String get home_btx_new_group {
    return Intl.message(
      'New Group',
      name: 'home_btx_new_group',
      desc: '',
      args: [],
    );
  }

  /// `Groups`
  String get home_btx_groups {
    return Intl.message(
      'Groups',
      name: 'home_btx_groups',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get grp_caption_participation {
    return Intl.message(
      'Participants',
      name: 'grp_caption_participation',
      desc: '',
      args: [],
    );
  }

  /// `Add Participants`
  String get grp_txt_add_participant {
    return Intl.message(
      'Add Participants',
      name: 'grp_txt_add_participant',
      desc: '',
      args: [],
    );
  }

  /// `We understand that using technology for education can be a new and exciting experience, but it can also come with its challenges. We’ll provide the best possible support to you.`
  String get admin_chat_profile_1 {
    return Intl.message(
      'We understand that using technology for education can be a new and exciting experience, but it can also come with its challenges. We’ll provide the best possible support to you.',
      name: 'admin_chat_profile_1',
      desc: '',
      args: [],
    );
  }

  /// `If you have any concerns or suggestions, please contact us at:`
  String get admin_chat_profile_2 {
    return Intl.message(
      'If you have any concerns or suggestions, please contact us at:',
      name: 'admin_chat_profile_2',
      desc: '',
      args: [],
    );
  }

  /// `Missed call from {name} at {time}`
  String chat_missed_call(Object name, Object time) {
    return Intl.message(
      'Missed call from $name at $time',
      name: 'chat_missed_call',
      desc: '',
      args: [name, time],
    );
  }

  /// `Missed video call from {name} at {time}`
  String chat_missed_call_video(Object name, Object time) {
    return Intl.message(
      'Missed video call from $name at $time',
      name: 'chat_missed_call_video',
      desc: '',
      args: [name, time],
    );
  }

  /// `Yourself`
  String get chat_yourself {
    return Intl.message(
      'Yourself',
      name: 'chat_yourself',
      desc: '',
      args: [],
    );
  }

  /// `Write your message`
  String get chat_input_hint {
    return Intl.message(
      'Write your message',
      name: 'chat_input_hint',
      desc: '',
      args: [],
    );
  }

  /// `Send Request`
  String get contact_menu_request {
    return Intl.message(
      'Send Request',
      name: 'contact_menu_request',
      desc: '',
      args: [],
    );
  }

  /// `View Profile`
  String get contact_menu_view {
    return Intl.message(
      'View Profile',
      name: 'contact_menu_view',
      desc: '',
      args: [],
    );
  }

  /// `Delete Contact`
  String get contact_menu_delete {
    return Intl.message(
      'Delete Contact',
      name: 'contact_menu_delete',
      desc: '',
      args: [],
    );
  }

  /// `Block Contact`
  String get contact_menu_block {
    return Intl.message(
      'Block Contact',
      name: 'contact_menu_block',
      desc: '',
      args: [],
    );
  }

  /// `Unblock Contact`
  String get contact_menu_unblock {
    return Intl.message(
      'Unblock Contact',
      name: 'contact_menu_unblock',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get chat_menu_title {
    return Intl.message(
      'Options',
      name: 'chat_menu_title',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get chat_menu_copy {
    return Intl.message(
      'Copy',
      name: 'chat_menu_copy',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get chat_menu_forward {
    return Intl.message(
      'Forward',
      name: 'chat_menu_forward',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get chat_menu_reply {
    return Intl.message(
      'Reply',
      name: 'chat_menu_reply',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get chat_menu_delete {
    return Intl.message(
      'Delete',
      name: 'chat_menu_delete',
      desc: '',
      args: [],
    );
  }

  /// `Display Name`
  String get pr_name {
    return Intl.message(
      'Display Name',
      name: 'pr_name',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get pr_email {
    return Intl.message(
      'Email Address',
      name: 'pr_email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get pr_phone {
    return Intl.message(
      'Phone Number',
      name: 'pr_phone',
      desc: '',
      args: [],
    );
  }

  /// `Mute Notification`
  String get pr_mute_notification {
    return Intl.message(
      'Mute Notification',
      name: 'pr_mute_notification',
      desc: '',
      args: [],
    );
  }

  /// `Media Shared`
  String get pr_media_shared {
    return Intl.message(
      'Media Shared',
      name: 'pr_media_shared',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get pr_btx_all {
    return Intl.message(
      'View All',
      name: 'pr_btx_all',
      desc: '',
      args: [],
    );
  }

  /// `Common Groups`
  String get pr_common_groups {
    return Intl.message(
      'Common Groups',
      name: 'pr_common_groups',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get pr_btx_block {
    return Intl.message(
      'Block',
      name: 'pr_btx_block',
      desc: '',
      args: [],
    );
  }

  /// `Unblock`
  String get pr_btx_unblock {
    return Intl.message(
      'Unblock',
      name: 'pr_btx_unblock',
      desc: '',
      args: [],
    );
  }

  /// `Report Contact`
  String get pr_btx_report {
    return Intl.message(
      'Report Contact',
      name: 'pr_btx_report',
      desc: '',
      args: [],
    );
  }

  /// `People`
  String get search_contact_ppl {
    return Intl.message(
      'People',
      name: 'search_contact_ppl',
      desc: '',
      args: [],
    );
  }

  /// `Clear Chat`
  String get grp_btx_clear {
    return Intl.message(
      'Clear Chat',
      name: 'grp_btx_clear',
      desc: '',
      args: [],
    );
  }

  /// `Exit Group`
  String get grp_btx_exit {
    return Intl.message(
      'Exit Group',
      name: 'grp_btx_exit',
      desc: '',
      args: [],
    );
  }

  /// `Report Group`
  String get grp_btx_report {
    return Intl.message(
      'Report Group',
      name: 'grp_btx_report',
      desc: '',
      args: [],
    );
  }

  /// `Mark as Read`
  String get bchat_conv_read {
    return Intl.message(
      'Mark as Read',
      name: 'bchat_conv_read',
      desc: '',
      args: [],
    );
  }

  /// `Delete Conversation`
  String get bchat_conv_delete {
    return Intl.message(
      'Delete Conversation',
      name: 'bchat_conv_delete',
      desc: '',
      args: [],
    );
  }

  /// `Mute Conversation`
  String get bchat_conv_mute {
    return Intl.message(
      'Mute Conversation',
      name: 'bchat_conv_mute',
      desc: '',
      args: [],
    );
  }

  /// `Unmute Conversation`
  String get bchat_conv_unmute {
    return Intl.message(
      'Unmute Conversation',
      name: 'bchat_conv_unmute',
      desc: '',
      args: [],
    );
  }

  /// `Share Content`
  String get atc_content {
    return Intl.message(
      'Share Content',
      name: 'atc_content',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get atc_camera {
    return Intl.message(
      'Camera',
      name: 'atc_camera',
      desc: '',
      args: [],
    );
  }

  /// `Record Video`
  String get atc_record {
    return Intl.message(
      'Record Video',
      name: 'atc_record',
      desc: '',
      args: [],
    );
  }

  /// `Media`
  String get atc_media {
    return Intl.message(
      'Media',
      name: 'atc_media',
      desc: '',
      args: [],
    );
  }

  /// `Share photos and videos`
  String get atc_media_desc {
    return Intl.message(
      'Share photos and videos',
      name: 'atc_media_desc',
      desc: '',
      args: [],
    );
  }

  /// `Audio`
  String get atc_audio {
    return Intl.message(
      'Audio',
      name: 'atc_audio',
      desc: '',
      args: [],
    );
  }

  /// `Share audios`
  String get atc_audio_desc {
    return Intl.message(
      'Share audios',
      name: 'atc_audio_desc',
      desc: '',
      args: [],
    );
  }

  /// `Documents`
  String get atc_document {
    return Intl.message(
      'Documents',
      name: 'atc_document',
      desc: '',
      args: [],
    );
  }

  /// `Share your files`
  String get atc_document_desc {
    return Intl.message(
      'Share your files',
      name: 'atc_document_desc',
      desc: '',
      args: [],
    );
  }

  /// `Take a picture from Camera`
  String get im_picker_camera_desc {
    return Intl.message(
      'Take a picture from Camera',
      name: 'im_picker_camera_desc',
      desc: '',
      args: [],
    );
  }

  /// `Pick an image from Gallery`
  String get im_picker_gallery_desc {
    return Intl.message(
      'Pick an image from Gallery',
      name: 'im_picker_gallery_desc',
      desc: '',
      args: [],
    );
  }

  /// `Explore`
  String get blearn_explore {
    return Intl.message(
      'Explore',
      name: 'blearn_explore',
      desc: '',
      args: [],
    );
  }

  /// `Recommended`
  String get blearn_recommended {
    return Intl.message(
      'Recommended',
      name: 'blearn_recommended',
      desc: '',
      args: [],
    );
  }

  /// `By Us`
  String get blearn_byus {
    return Intl.message(
      'By Us',
      name: 'blearn_byus',
      desc: '',
      args: [],
    );
  }

  /// `Trending`
  String get blearn_btx_trending {
    return Intl.message(
      'Trending',
      name: 'blearn_btx_trending',
      desc: '',
      args: [],
    );
  }

  /// `Most Viewed`
  String get blearn_btx_mostviewed {
    return Intl.message(
      'Most Viewed',
      name: 'blearn_btx_mostviewed',
      desc: '',
      args: [],
    );
  }

  /// `Top Courses`
  String get blearn_btx_topcourses {
    return Intl.message(
      'Top Courses',
      name: 'blearn_btx_topcourses',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get blearn_btx_viewall {
    return Intl.message(
      'View All',
      name: 'blearn_btx_viewall',
      desc: '',
      args: [],
    );
  }

  /// `Learn From`
  String get blearn_learnfrom {
    return Intl.message(
      'Learn From',
      name: 'blearn_learnfrom',
      desc: '',
      args: [],
    );
  }

  /// `the Best`
  String get blearn_thebest {
    return Intl.message(
      'the Best',
      name: 'blearn_thebest',
      desc: '',
      args: [],
    );
  }

  /// `Complementary`
  String get blearn_complementry {
    return Intl.message(
      'Complementary',
      name: 'blearn_complementry',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get blearn_courses {
    return Intl.message(
      'Courses',
      name: 'blearn_courses',
      desc: '',
      args: [],
    );
  }

  /// `Instructors`
  String get blearn_instructors {
    return Intl.message(
      'Instructors',
      name: 'blearn_instructors',
      desc: '',
      args: [],
    );
  }

  /// `Recently`
  String get blearn_recently {
    return Intl.message(
      'Recently',
      name: 'blearn_recently',
      desc: '',
      args: [],
    );
  }

  /// `Added`
  String get blearn_added {
    return Intl.message(
      'Added',
      name: 'blearn_added',
      desc: '',
      args: [],
    );
  }

  /// `Testimonials`
  String get blearn_testimonial {
    return Intl.message(
      'Testimonials',
      name: 'blearn_testimonial',
      desc: '',
      args: [],
    );
  }

  /// `Popular`
  String get blearn_popular_title_1st_half {
    return Intl.message(
      'Popular',
      name: 'blearn_popular_title_1st_half',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get blearn_popular_title_2nd_half {
    return Intl.message(
      'Categories',
      name: 'blearn_popular_title_2nd_half',
      desc: '',
      args: [],
    );
  }

  /// `Subscribed Courses`
  String get blearn_subscribed_courses {
    return Intl.message(
      'Subscribed Courses',
      name: 'blearn_subscribed_courses',
      desc: '',
      args: [],
    );
  }

  /// `Embark on a journey of discovery through our extensive catalog of 100's of courses, and unlock a world of knowledge waiting to be explored!`
  String get blearn_search_courses {
    return Intl.message(
      'Embark on a journey of discovery through our extensive catalog of 100\'s of courses, and unlock a world of knowledge waiting to be explored!',
      name: 'blearn_search_courses',
      desc: '',
      args: [],
    );
  }

  /// `Discover the perfect guide to elevate your learning experience, with our comprehensive search tool to help you find the ideal instructor for your educational journey!`
  String get blearn_search_instructor {
    return Intl.message(
      'Discover the perfect guide to elevate your learning experience, with our comprehensive search tool to help you find the ideal instructor for your educational journey!',
      name: 'blearn_search_instructor',
      desc: '',
      args: [],
    );
  }

  /// `Course Subscribed`
  String get blearn_course_subscribed_title {
    return Intl.message(
      'Course Subscribed',
      name: 'blearn_course_subscribed_title',
      desc: '',
      args: [],
    );
  }

  /// `Congratulations, you're now subscribed to {course_name}. Explore it to your full potential and achieving your goals with the help of this online course.`
  String blearn_course_subscribed_msg(Object course_name) {
    return Intl.message(
      'Congratulations, you\'re now subscribed to $course_name. Explore it to your full potential and achieving your goals with the help of this online course.',
      name: 'blearn_course_subscribed_msg',
      desc: '',
      args: [course_name],
    );
  }

  /// `Scheduled Meetings`
  String get bmeet_txt_schedule {
    return Intl.message(
      'Scheduled Meetings',
      name: 'bmeet_txt_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Start Instant Meeting`
  String get bmmet_txt_start_title {
    return Intl.message(
      'Start Instant Meeting',
      name: 'bmmet_txt_start_title',
      desc: '',
      args: [],
    );
  }

  /// `Generate your meeting link to begin.`
  String get bmeet_txt_start_desc {
    return Intl.message(
      'Generate your meeting link to begin.',
      name: 'bmeet_txt_start_desc',
      desc: '',
      args: [],
    );
  }

  /// `Join`
  String get bmeet_btn_join {
    return Intl.message(
      'Join',
      name: 'bmeet_btn_join',
      desc: '',
      args: [],
    );
  }

  /// `Schedule`
  String get bmeet_btn_schedule {
    return Intl.message(
      'Schedule',
      name: 'bmeet_btn_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Join Meeting`
  String get bmeet_btx_join {
    return Intl.message(
      'Join Meeting',
      name: 'bmeet_btx_join',
      desc: '',
      args: [],
    );
  }

  /// `Meeting`
  String get bmeet_txt_meeting {
    return Intl.message(
      'Meeting',
      name: 'bmeet_txt_meeting',
      desc: '',
      args: [],
    );
  }

  /// `Today's Meeting`
  String get bmeet_today_meeting {
    return Intl.message(
      'Today\'s Meeting',
      name: 'bmeet_today_meeting',
      desc: '',
      args: [],
    );
  }

  /// `{date} Meeting`
  String bmeet_date_meeting(Object date) {
    return Intl.message(
      '$date Meeting',
      name: 'bmeet_date_meeting',
      desc: '',
      args: [date],
    );
  }

  /// `No scheduled Meetings.`
  String get bmeet_no_meetings {
    return Intl.message(
      'No scheduled Meetings.',
      name: 'bmeet_no_meetings',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get blearn_review_title {
    return Intl.message(
      'Review',
      name: 'blearn_review_title',
      desc: '',
      args: [],
    );
  }

  /// `You can also clink on the link received to join directly`
  String get bmeet_join_desc {
    return Intl.message(
      'You can also clink on the link received to join directly',
      name: 'bmeet_join_desc',
      desc: '',
      args: [],
    );
  }

  /// `Join Scheduled Class`
  String get scheduled_class_join_title {
    return Intl.message(
      'Join Scheduled Class',
      name: 'scheduled_class_join_title',
      desc: '',
      args: [],
    );
  }

  /// `Click on start button to join the scheduled class`
  String get scheduled_class_join_desc {
    return Intl.message(
      'Click on start button to join the scheduled class',
      name: 'scheduled_class_join_desc',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get bmeet_btn_start {
    return Intl.message(
      'Start',
      name: 'bmeet_btn_start',
      desc: '',
      args: [],
    );
  }

  /// `Start a Meeting`
  String get bmeet_start_heading {
    return Intl.message(
      'Start a Meeting',
      name: 'bmeet_start_heading',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Joining Options`
  String get bmeet_start_option {
    return Intl.message(
      'Meeting Joining Options',
      name: 'bmeet_start_option',
      desc: '',
      args: [],
    );
  }

  /// `Always mute my microphone on start`
  String get bmeet_mute_title {
    return Intl.message(
      'Always mute my microphone on start',
      name: 'bmeet_mute_title',
      desc: '',
      args: [],
    );
  }

  /// `Grant or restrict audio access`
  String get bmeet_mute_desc {
    return Intl.message(
      'Grant or restrict audio access',
      name: 'bmeet_mute_desc',
      desc: '',
      args: [],
    );
  }

  /// `Always turn off my camera on start`
  String get bmeet_videooff_title {
    return Intl.message(
      'Always turn off my camera on start',
      name: 'bmeet_videooff_title',
      desc: '',
      args: [],
    );
  }

  /// `Grant or restrict video access`
  String get bmeet_videooff_desc {
    return Intl.message(
      'Grant or restrict video access',
      name: 'bmeet_videooff_desc',
      desc: '',
      args: [],
    );
  }

  /// `Sharable Link`
  String get bmeet_sharable_caption {
    return Intl.message(
      'Sharable Link',
      name: 'bmeet_sharable_caption',
      desc: '',
      args: [],
    );
  }

  /// `Your Unique Meeting link or ID`
  String get bmeet_sharable_title {
    return Intl.message(
      'Your Unique Meeting link or ID',
      name: 'bmeet_sharable_title',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get bmeet_share {
    return Intl.message(
      'Share',
      name: 'bmeet_share',
      desc: '',
      args: [],
    );
  }

  /// `Join a Meeting`
  String get bmeet_join_heading {
    return Intl.message(
      'Join a Meeting',
      name: 'bmeet_join_heading',
      desc: '',
      args: [],
    );
  }

  /// `Meeting ID or Link`
  String get bmeet_join_caption {
    return Intl.message(
      'Meeting ID or Link',
      name: 'bmeet_join_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter Meeting ID or Link`
  String get bmeet_hint_join_id_link {
    return Intl.message(
      'Enter Meeting ID or Link',
      name: 'bmeet_hint_join_id_link',
      desc: '',
      args: [],
    );
  }

  /// `Edit meeting`
  String get bmeet_edit_heading {
    return Intl.message(
      'Edit meeting',
      name: 'bmeet_edit_heading',
      desc: '',
      args: [],
    );
  }

  /// `Schedule a Meeting`
  String get bmeet_schedule_heading {
    return Intl.message(
      'Schedule a Meeting',
      name: 'bmeet_schedule_heading',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Title`
  String get bmeet_caption_title {
    return Intl.message(
      'Meeting Title',
      name: 'bmeet_caption_title',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Subject`
  String get bmeet_caption_subject {
    return Intl.message(
      'Meeting Subject',
      name: 'bmeet_caption_subject',
      desc: '',
      args: [],
    );
  }

  /// `Set Meeting Date`
  String get bmeet_caption_date {
    return Intl.message(
      'Set Meeting Date',
      name: 'bmeet_caption_date',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get bmeet_caption_starttime {
    return Intl.message(
      'Start Time',
      name: 'bmeet_caption_starttime',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get bmeet_caption_endtime {
    return Intl.message(
      'End Time',
      name: 'bmeet_caption_endtime',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Meeting Title`
  String get bmeet_hint_title {
    return Intl.message(
      'Enter Your Meeting Title',
      name: 'bmeet_hint_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Meeting Subject`
  String get bmeet_hint_subject {
    return Intl.message(
      'Enter Your Meeting Subject',
      name: 'bmeet_hint_subject',
      desc: '',
      args: [],
    );
  }

  /// `Select Meeting Date`
  String get bmeet_hint_date {
    return Intl.message(
      'Select Meeting Date',
      name: 'bmeet_hint_date',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get bmeet_hint_start {
    return Intl.message(
      'Start Time',
      name: 'bmeet_hint_start',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get bmeet_hint_end {
    return Intl.message(
      'End Time',
      name: 'bmeet_hint_end',
      desc: '',
      args: [],
    );
  }

  /// `Meeting title can't be emplty`
  String get bmeet_empty_title {
    return Intl.message(
      'Meeting title can\'t be emplty',
      name: 'bmeet_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Meeting title must contains at least 5 characters`
  String get bmeet_invalid_title {
    return Intl.message(
      'Meeting title must contains at least 5 characters',
      name: 'bmeet_invalid_title',
      desc: '',
      args: [],
    );
  }

  /// `Meeting subject can't be emplty`
  String get bmeet_empty_subject {
    return Intl.message(
      'Meeting subject can\'t be emplty',
      name: 'bmeet_empty_subject',
      desc: '',
      args: [],
    );
  }

  /// `Meeting subject must contains at least 5 characters`
  String get bmeet_invalid_subject {
    return Intl.message(
      'Meeting subject must contains at least 5 characters',
      name: 'bmeet_invalid_subject',
      desc: '',
      args: [],
    );
  }

  /// `Enter meeting date`
  String get bmeet_empty_date {
    return Intl.message(
      'Enter meeting date',
      name: 'bmeet_empty_date',
      desc: '',
      args: [],
    );
  }

  /// `Meeting date can't be in past`
  String get bmeet_invalid_date {
    return Intl.message(
      'Meeting date can\'t be in past',
      name: 'bmeet_invalid_date',
      desc: '',
      args: [],
    );
  }

  /// `Enter start time`
  String get bmeet_empty_start {
    return Intl.message(
      'Enter start time',
      name: 'bmeet_empty_start',
      desc: '',
      args: [],
    );
  }

  /// `Meeting start time can't be in past`
  String get bmeet_invalid_start {
    return Intl.message(
      'Meeting start time can\'t be in past',
      name: 'bmeet_invalid_start',
      desc: '',
      args: [],
    );
  }

  /// `Enter end time`
  String get bmeet_empty_end {
    return Intl.message(
      'Enter end time',
      name: 'bmeet_empty_end',
      desc: '',
      args: [],
    );
  }

  /// `Meeting end time can't be before start time`
  String get bmeet_invalid_end {
    return Intl.message(
      'Meeting end time can\'t be before start time',
      name: 'bmeet_invalid_end',
      desc: '',
      args: [],
    );
  }

  /// `Schedule a Broadcast`
  String get blive_schedule_heading {
    return Intl.message(
      'Schedule a Broadcast',
      name: 'blive_schedule_heading',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled Broadcast`
  String get blive_txt_schedule {
    return Intl.message(
      'Scheduled Broadcast',
      name: 'blive_txt_schedule',
      desc: '',
      args: [],
    );
  }

  /// `BroadCast ID or Link`
  String get blive_txt_start_title {
    return Intl.message(
      'BroadCast ID or Link',
      name: 'blive_txt_start_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter Broadcast ID or Link Here.`
  String get blive_txt_start_desc {
    return Intl.message(
      'Enter Broadcast ID or Link Here.',
      name: 'blive_txt_start_desc',
      desc: '',
      args: [],
    );
  }

  /// `Enter Broadcast ID or Link.`
  String get blive_hint_link {
    return Intl.message(
      'Enter Broadcast ID or Link.',
      name: 'blive_hint_link',
      desc: '',
      args: [],
    );
  }

  /// `Today's Broadcast`
  String get blive_today_meeting {
    return Intl.message(
      'Today\'s Broadcast',
      name: 'blive_today_meeting',
      desc: '',
      args: [],
    );
  }

  /// `{date} Broadcast`
  String blive_date_meeting(Object date) {
    return Intl.message(
      '$date Broadcast',
      name: 'blive_date_meeting',
      desc: '',
      args: [date],
    );
  }

  /// `No scheduled Broadcast.`
  String get blive_no_meetings {
    return Intl.message(
      'No scheduled Broadcast.',
      name: 'blive_no_meetings',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast`
  String get blive_txt_broadcast {
    return Intl.message(
      'Broadcast',
      name: 'blive_txt_broadcast',
      desc: '',
      args: [],
    );
  }

  /// `Join Broadcast`
  String get blive_btx_join {
    return Intl.message(
      'Join Broadcast',
      name: 'blive_btx_join',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast title`
  String get blive_caption_title {
    return Intl.message(
      'Broadcast title',
      name: 'blive_caption_title',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast description`
  String get blive_caption_desc {
    return Intl.message(
      'Broadcast description',
      name: 'blive_caption_desc',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast Date`
  String get blive_caption_date {
    return Intl.message(
      'Broadcast Date',
      name: 'blive_caption_date',
      desc: '',
      args: [],
    );
  }

  /// `Select an Image`
  String get blive_caption_image {
    return Intl.message(
      'Select an Image',
      name: 'blive_caption_image',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast Time`
  String get blive_caption_starttime {
    return Intl.message(
      'Broadcast Time',
      name: 'blive_caption_starttime',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Broadcast Title`
  String get blive_hint_title {
    return Intl.message(
      'Enter Your Broadcast Title',
      name: 'blive_hint_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Broadcast Description`
  String get blive_hint_desc {
    return Intl.message(
      'Enter Your Broadcast Description',
      name: 'blive_hint_desc',
      desc: '',
      args: [],
    );
  }

  /// `Select Date`
  String get blive_hint_date {
    return Intl.message(
      'Select Date',
      name: 'blive_hint_date',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get blive_hint_time {
    return Intl.message(
      'Time',
      name: 'blive_hint_time',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast title can't be emplty`
  String get blive_empty_title {
    return Intl.message(
      'Broadcast title can\'t be emplty',
      name: 'blive_empty_title',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast title must contains at least 5 characters`
  String get blive_invalid_title {
    return Intl.message(
      'Broadcast title must contains at least 5 characters',
      name: 'blive_invalid_title',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast description can't be emplty`
  String get blive_empty_desc {
    return Intl.message(
      'Broadcast description can\'t be emplty',
      name: 'blive_empty_desc',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast description must contains at least 5 characters`
  String get blive_invalid_desc {
    return Intl.message(
      'Broadcast description must contains at least 5 characters',
      name: 'blive_invalid_desc',
      desc: '',
      args: [],
    );
  }

  /// `Enter meeting date`
  String get blive_empty_date {
    return Intl.message(
      'Enter meeting date',
      name: 'blive_empty_date',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast date can't be in past`
  String get blive_invalid_date {
    return Intl.message(
      'Broadcast date can\'t be in past',
      name: 'blive_invalid_date',
      desc: '',
      args: [],
    );
  }

  /// `Enter Broadcast time`
  String get blive_empty_time {
    return Intl.message(
      'Enter Broadcast time',
      name: 'blive_empty_time',
      desc: '',
      args: [],
    );
  }

  /// `Broadcast time can't be in past`
  String get blive_invalid_time {
    return Intl.message(
      'Broadcast time can\'t be in past',
      name: 'blive_invalid_time',
      desc: '',
      args: [],
    );
  }

  /// `Meeting ID`
  String get bmeet_call_txt_meeting_id {
    return Intl.message(
      'Meeting ID',
      name: 'bmeet_call_txt_meeting_id',
      desc: '',
      args: [],
    );
  }

  /// `Host ID`
  String get bmeet_call_txt_host_id {
    return Intl.message(
      'Host ID',
      name: 'bmeet_call_txt_host_id',
      desc: '',
      args: [],
    );
  }

  /// `Invite Link`
  String get bmeet_call_txt_invite_link {
    return Intl.message(
      'Invite Link',
      name: 'bmeet_call_txt_invite_link',
      desc: '',
      args: [],
    );
  }

  /// `Not Available`
  String get bmeet_call_txt_na {
    return Intl.message(
      'Not Available',
      name: 'bmeet_call_txt_na',
      desc: '',
      args: [],
    );
  }

  /// `Encryption`
  String get bmeet_call_txt_encryption {
    return Intl.message(
      'Encryption',
      name: 'bmeet_call_txt_encryption',
      desc: '',
      args: [],
    );
  }

  /// `Enabled`
  String get bmeet_call_txt_enable {
    return Intl.message(
      'Enabled',
      name: 'bmeet_call_txt_enable',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get bmeet_call_bxt_end {
    return Intl.message(
      'End',
      name: 'bmeet_call_bxt_end',
      desc: '',
      args: [],
    );
  }

  /// `Mute All`
  String get bmeet_call_bxt_muteall {
    return Intl.message(
      'Mute All',
      name: 'bmeet_call_bxt_muteall',
      desc: '',
      args: [],
    );
  }

  /// `Unmute All`
  String get bmeet_call_bxt_unmuteall {
    return Intl.message(
      'Unmute All',
      name: 'bmeet_call_bxt_unmuteall',
      desc: '',
      args: [],
    );
  }

  /// `Share Link`
  String get bmeet_call_bxt_sharelink {
    return Intl.message(
      'Share Link',
      name: 'bmeet_call_bxt_sharelink',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect Joiner`
  String get bmeet_call_bxt_disconnect_all {
    return Intl.message(
      'Disconnect Joiner',
      name: 'bmeet_call_bxt_disconnect_all',
      desc: '',
      args: [],
    );
  }

  /// `Record video`
  String get bmeet_call_bxt_record {
    return Intl.message(
      'Record video',
      name: 'bmeet_call_bxt_record',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get bmeet_call_bxt_cancel {
    return Intl.message(
      'Cancel',
      name: 'bmeet_call_bxt_cancel',
      desc: '',
      args: [],
    );
  }

  /// `Recording Started..`
  String get bmeet_recording_start {
    return Intl.message(
      'Recording Started..',
      name: 'bmeet_recording_start',
      desc: '',
      args: [],
    );
  }

  /// `Stop recording`
  String get bmeet_call_stop_record {
    return Intl.message(
      'Stop recording',
      name: 'bmeet_call_stop_record',
      desc: '',
      args: [],
    );
  }

  /// `This is not available yet.`
  String get bmeet_call_msg_na_yet {
    return Intl.message(
      'This is not available yet.',
      name: 'bmeet_call_msg_na_yet',
      desc: '',
      args: [],
    );
  }

  /// `Your are muted by host`
  String get bmeet_call_msg_diable_audio_host {
    return Intl.message(
      'Your are muted by host',
      name: 'bmeet_call_msg_diable_audio_host',
      desc: '',
      args: [],
    );
  }

  /// `Your camera disabled by host.`
  String get bmeet_call_msg_diable_camera_host {
    return Intl.message(
      'Your camera disabled by host.',
      name: 'bmeet_call_msg_diable_camera_host',
      desc: '',
      args: [],
    );
  }

  /// `Mute`
  String get bmeet_tool_mute {
    return Intl.message(
      'Mute',
      name: 'bmeet_tool_mute',
      desc: '',
      args: [],
    );
  }

  /// `Unmute`
  String get bmeet_tool_unmute {
    return Intl.message(
      'Unmute',
      name: 'bmeet_tool_unmute',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get bmeet_tool_video {
    return Intl.message(
      'Video',
      name: 'bmeet_tool_video',
      desc: '',
      args: [],
    );
  }

  /// `Stop Video`
  String get bmeet_tool_stop_video {
    return Intl.message(
      'Stop Video',
      name: 'bmeet_tool_stop_video',
      desc: '',
      args: [],
    );
  }

  /// `Share Screen`
  String get bmeet_tool_share_screen {
    return Intl.message(
      'Share Screen',
      name: 'bmeet_tool_share_screen',
      desc: '',
      args: [],
    );
  }

  /// `Stop Share`
  String get bmeet_tool_stop_sshare {
    return Intl.message(
      'Stop Share',
      name: 'bmeet_tool_stop_sshare',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get bmeet_tool_participants {
    return Intl.message(
      'Participants',
      name: 'bmeet_tool_participants',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get bmeet_tool_more {
    return Intl.message(
      'More',
      name: 'bmeet_tool_more',
      desc: '',
      args: [],
    );
  }

  /// `Raise Hand`
  String get bmeet_tool_raisehand {
    return Intl.message(
      'Raise Hand',
      name: 'bmeet_tool_raisehand',
      desc: '',
      args: [],
    );
  }

  /// `You`
  String get bmeet_user_you {
    return Intl.message(
      'You',
      name: 'bmeet_user_you',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get btn_remove {
    return Intl.message(
      'Remove',
      name: 'btn_remove',
      desc: '',
      args: [],
    );
  }

  /// `End`
  String get btn_end {
    return Intl.message(
      'End',
      name: 'btn_end',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get btn_continue {
    return Intl.message(
      'Continue',
      name: 'btn_continue',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get btn_ok {
    return Intl.message(
      'OK',
      name: 'btn_ok',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get btn_create {
    return Intl.message(
      'Create',
      name: 'btn_create',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get btn_update {
    return Intl.message(
      'Update',
      name: 'btn_update',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Scheduled`
  String get dg_title_meeting_scheduled {
    return Intl.message(
      'Meeting Scheduled',
      name: 'dg_title_meeting_scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Meeting has been scheduled. You can see the details in the scheduled meeting list.`
  String get dg_message_meeting_scheduled {
    return Intl.message(
      'Meeting has been scheduled. You can see the details in the scheduled meeting list.',
      name: 'dg_message_meeting_scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Live Session Scheduled`
  String get dg_title_live_scheduled {
    return Intl.message(
      'Live Session Scheduled',
      name: 'dg_title_live_scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Live session has been scheduled. You can see the details in the scheduled list.`
  String get dg_message_live_scheduled {
    return Intl.message(
      'Live session has been scheduled. You can see the details in the scheduled list.',
      name: 'dg_message_live_scheduled',
      desc: '',
      args: [],
    );
  }

  /// `Logout Account`
  String get dg_title_logout {
    return Intl.message(
      'Logout Account',
      name: 'dg_title_logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to logout your account?`
  String get dg_message_logout {
    return Intl.message(
      'Are you sure want to logout your account?',
      name: 'dg_message_logout',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get btn_yes_logout {
    return Intl.message(
      'Logout',
      name: 'btn_yes_logout',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get dg_title_DeleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'dg_title_DeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `If you click on Yes, your account will be permanently deleted. You have 30 days to prevent your account from being permanently deleted if you change your mind.`
  String get dg_message_DeleteAccount {
    return Intl.message(
      'If you click on Yes, your account will be permanently deleted. You have 30 days to prevent your account from being permanently deleted if you change your mind.',
      name: 'dg_message_DeleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get dg_confirm_deleteAccount {
    return Intl.message(
      'Delete',
      name: 'dg_confirm_deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Subscribed Courses`
  String get sp_tab_sub_course {
    return Intl.message(
      'Subscribed Courses',
      name: 'sp_tab_sub_course',
      desc: '',
      args: [],
    );
  }

  /// `Teacher Followed`
  String get sp_tab_followed {
    return Intl.message(
      'Teacher Followed',
      name: 'sp_tab_followed',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled classes`
  String get t_scheduled_header {
    return Intl.message(
      'Scheduled classes',
      name: 't_scheduled_header',
      desc: '',
      args: [],
    );
  }

  /// `Schedule a Class`
  String get t_schedule_class {
    return Intl.message(
      'Schedule a Class',
      name: 't_schedule_class',
      desc: '',
      args: [],
    );
  }

  /// `Send request for group or personal class`
  String get t_schedule_class_msg {
    return Intl.message(
      'Send request for group or personal class',
      name: 't_schedule_class_msg',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming classes`
  String get t_schedule_caption {
    return Intl.message(
      'Upcoming classes',
      name: 't_schedule_caption',
      desc: '',
      args: [],
    );
  }

  /// `No Upcoming class`
  String get t_schedule_no_class {
    return Intl.message(
      'No Upcoming class',
      name: 't_schedule_no_class',
      desc: '',
      args: [],
    );
  }

  /// `Pin Conversation`
  String get bchat_conv_pin {
    return Intl.message(
      'Pin Conversation',
      name: 'bchat_conv_pin',
      desc: '',
      args: [],
    );
  }

  /// `Unpin Conversation`
  String get bchat_conv_unpin {
    return Intl.message(
      'Unpin Conversation',
      name: 'bchat_conv_unpin',
      desc: '',
      args: [],
    );
  }

  /// `Pinned Conversation`
  String get bchat_conv_pinned {
    return Intl.message(
      'Pinned Conversation',
      name: 'bchat_conv_pinned',
      desc: '',
      args: [],
    );
  }

  /// `Unpinned Conversation`
  String get bchat_conv_unpinned {
    return Intl.message(
      'Unpinned Conversation',
      name: 'bchat_conv_unpinned',
      desc: '',
      args: [],
    );
  }

  /// `Class topic can't be empty`
  String get t_request_class_empty_topic {
    return Intl.message(
      'Class topic can\'t be empty',
      name: 't_request_class_empty_topic',
      desc: '',
      args: [],
    );
  }

  /// `Class topic must contains at least 5 characters`
  String get t_request_class_topic_invalid {
    return Intl.message(
      'Class topic must contains at least 5 characters',
      name: 't_request_class_topic_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Select Class Type`
  String get t_request_class_type_hint {
    return Intl.message(
      'Select Class Type',
      name: 't_request_class_type_hint',
      desc: '',
      args: [],
    );
  }

  /// `Class request type can't be empty`
  String get t_request_class_empty_type {
    return Intl.message(
      'Class request type can\'t be empty',
      name: 't_request_class_empty_type',
      desc: '',
      args: [],
    );
  }

  /// `Class Request description type can't be empty`
  String get t_request_class_empty_description {
    return Intl.message(
      'Class Request description type can\'t be empty',
      name: 't_request_class_empty_description',
      desc: '',
      args: [],
    );
  }

  /// `Class Request description must contains at least 5 characters`
  String get t_request_class_description_invalid {
    return Intl.message(
      'Class Request description must contains at least 5 characters',
      name: 't_request_class_description_invalid',
      desc: '',
      args: [],
    );
  }

  /// `No Requested Class`
  String get t_no_requested_class_title {
    return Intl.message(
      'No Requested Class',
      name: 't_no_requested_class_title',
      desc: '',
      args: [],
    );
  }

  /// `Request Sent`
  String get class_request_sent {
    return Intl.message(
      'Request Sent',
      name: 'class_request_sent',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get class_request_accept {
    return Intl.message(
      'Accept',
      name: 'class_request_accept',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get class_request_reject {
    return Intl.message(
      'Reject',
      name: 'class_request_reject',
      desc: '',
      args: [],
    );
  }

  /// `Ex: We will let you know the details related to the scheduled class...`
  String get class_request_accept_remark_hint {
    return Intl.message(
      'Ex: We will let you know the details related to the scheduled class...',
      name: 'class_request_accept_remark_hint',
      desc: '',
      args: [],
    );
  }

  /// `Ex: The request can't be accepted because...`
  String get class_request_reject_remark_hint {
    return Intl.message(
      'Ex: The request can\'t be accepted because...',
      name: 'class_request_reject_remark_hint',
      desc: '',
      args: [],
    );
  }

  /// `Remark can't be empty`
  String get class_request_remark_empty_hint {
    return Intl.message(
      'Remark can\'t be empty',
      name: 'class_request_remark_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `Class Scheduled on`
  String get class_scheduled_on {
    return Intl.message(
      'Class Scheduled on',
      name: 'class_scheduled_on',
      desc: '',
      args: [],
    );
  }

  /// `No Scheduled Class`
  String get s_no_schedule_class {
    return Intl.message(
      'No Scheduled Class',
      name: 's_no_schedule_class',
      desc: '',
      args: [],
    );
  }

  /// `Date & Time`
  String get dateAndtime {
    return Intl.message(
      'Date & Time',
      name: 'dateAndtime',
      desc: '',
      args: [],
    );
  }

  /// `Join Class`
  String get class_scheduled_join_title {
    return Intl.message(
      'Join Class',
      name: 'class_scheduled_join_title',
      desc: '',
      args: [],
    );
  }

  /// `Start Class`
  String get class_scheduled_start_title {
    return Intl.message(
      'Start Class',
      name: 'class_scheduled_start_title',
      desc: '',
      args: [],
    );
  }

  /// `Pay for Class`
  String get class_scheduled_pay {
    return Intl.message(
      'Pay for Class',
      name: 'class_scheduled_pay',
      desc: '',
      args: [],
    );
  }

  /// `Class Scheduled by`
  String get class_Scheduled_title {
    return Intl.message(
      'Class Scheduled by',
      name: 'class_Scheduled_title',
      desc: '',
      args: [],
    );
  }

  /// `Participants`
  String get class_participants_title {
    return Intl.message(
      'Participants',
      name: 'class_participants_title',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get profile_subscription {
    return Intl.message(
      'Subscription',
      name: 'profile_subscription',
      desc: '',
      args: [],
    );
  }

  /// `Select Subscription`
  String get Select_subscription_title {
    return Intl.message(
      'Select Subscription',
      name: 'Select_subscription_title',
      desc: '',
      args: [],
    );
  }

  /// `Add Plan`
  String get add_plan_title {
    return Intl.message(
      'Add Plan',
      name: 'add_plan_title',
      desc: '',
      args: [],
    );
  }

  /// `Credit`
  String get credits_title {
    return Intl.message(
      'Credit',
      name: 'credits_title',
      desc: '',
      args: [],
    );
  }

  /// `Active Subscription`
  String get active_plan_title {
    return Intl.message(
      'Active Subscription',
      name: 'active_plan_title',
      desc: '',
      args: [],
    );
  }

  /// `The bCoin balance shows the number of coins available for you under the plan you have choosen. You can use these coins to subscribe to 3 different courses of your choice.`
  String get credit_description {
    return Intl.message(
      'The bCoin balance shows the number of coins available for you under the plan you have choosen. You can use these coins to subscribe to 3 different courses of your choice.',
      name: 'credit_description',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong! Try again /n /n Please contact our support team if money has been deducted from your account as course payment and is not being reflected.`
  String get transaction_error {
    return Intl.message(
      'Something went wrong! Try again /n /n Please contact our support team if money has been deducted from your account as course payment and is not being reflected.',
      name: 'transaction_error',
      desc: '',
      args: [],
    );
  }

  /// `Total (Incl taxes)`
  String get total_incltax_title {
    return Intl.message(
      'Total (Incl taxes)',
      name: 'total_incltax_title',
      desc: '',
      args: [],
    );
  }

  /// `Transaction History`
  String get transaction_title {
    return Intl.message(
      'Transaction History',
      name: 'transaction_title',
      desc: '',
      args: [],
    );
  }

  /// `No Transaction History`
  String get no_transaction_title {
    return Intl.message(
      'No Transaction History',
      name: 'no_transaction_title',
      desc: '',
      args: [],
    );
  }

  /// `By Completing your purchase you agree to these`
  String get subscription_term_condition_title_part1 {
    return Intl.message(
      'By Completing your purchase you agree to these',
      name: 'subscription_term_condition_title_part1',
      desc: '',
      args: [],
    );
  }

  /// ` terms of service.`
  String get subscription_term_condition_title_part2 {
    return Intl.message(
      ' terms of service.',
      name: 'subscription_term_condition_title_part2',
      desc: '',
      args: [],
    );
  }

  /// `Get Plan`
  String get get_plan_title {
    return Intl.message(
      'Get Plan',
      name: 'get_plan_title',
      desc: '',
      args: [],
    );
  }

  /// `Remark`
  String get remark {
    return Intl.message(
      'Remark',
      name: 'remark',
      desc: '',
      args: [],
    );
  }

  /// `Delete Requested`
  String get requested_class_delete {
    return Intl.message(
      'Delete Requested',
      name: 'requested_class_delete',
      desc: '',
      args: [],
    );
  }

  /// `The class request will be deleted. Do you want to Continue?`
  String get requested_class_delete_msg {
    return Intl.message(
      'The class request will be deleted. Do you want to Continue?',
      name: 'requested_class_delete_msg',
      desc: '',
      args: [],
    );
  }

  /// `New Group`
  String get groups_create_title {
    return Intl.message(
      'New Group',
      name: 'groups_create_title',
      desc: '',
      args: [],
    );
  }

  /// `Edit Group`
  String get groups_create_edit_title {
    return Intl.message(
      'Edit Group',
      name: 'groups_create_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `Add Subject`
  String get groups_create_subject {
    return Intl.message(
      'Add Subject',
      name: 'groups_create_subject',
      desc: '',
      args: [],
    );
  }

  /// `Group Title`
  String get groups_create_caption {
    return Intl.message(
      'Group Title',
      name: 'groups_create_caption',
      desc: '',
      args: [],
    );
  }

  /// `Enter group name`
  String get groups_create_hint_name {
    return Intl.message(
      'Enter group name',
      name: 'groups_create_hint_name',
      desc: '',
      args: [],
    );
  }

  /// `No Contacts`
  String get group_empty_no_contacts {
    return Intl.message(
      'No Contacts',
      name: 'group_empty_no_contacts',
      desc: '',
      args: [],
    );
  }

  /// `Group Name can't be empty`
  String get group_error_empty {
    return Intl.message(
      'Group Name can\'t be empty',
      name: 'group_error_empty',
      desc: '',
      args: [],
    );
  }

  /// `Group Name very short`
  String get group_error_invalid {
    return Intl.message(
      'Group Name very short',
      name: 'group_error_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Error in creating group`
  String get group_error_creating {
    return Intl.message(
      'Error in creating group',
      name: 'group_error_creating',
      desc: '',
      args: [],
    );
  }

  /// `{count} Memebers`
  String grp_chat_members(Object count) {
    return Intl.message(
      '$count Memebers',
      name: 'grp_chat_members',
      desc: '',
      args: [count],
    );
  }

  /// `Replying to {name}`
  String chat_replying(Object name) {
    return Intl.message(
      'Replying to $name',
      name: 'chat_replying',
      desc: '',
      args: [name],
    );
  }

  /// `Recent`
  String get recent_call_title {
    return Intl.message(
      'Recent',
      name: 'recent_call_title',
      desc: '',
      args: [],
    );
  }

  /// `No Calls`
  String get recent_call_no_calls {
    return Intl.message(
      'No Calls',
      name: 'recent_call_no_calls',
      desc: '',
      args: [],
    );
  }

  /// `Request Class`
  String get request_class_title {
    return Intl.message(
      'Request Class',
      name: 'request_class_title',
      desc: '',
      args: [],
    );
  }

  /// `Request a class`
  String get request_class {
    return Intl.message(
      'Request a class',
      name: 'request_class',
      desc: '',
      args: [],
    );
  }

  /// `Topic`
  String get request_class_topic {
    return Intl.message(
      'Topic',
      name: 'request_class_topic',
      desc: '',
      args: [],
    );
  }

  /// `Enter Class Topic or Subject`
  String get request_class_topic_hint {
    return Intl.message(
      'Enter Class Topic or Subject',
      name: 'request_class_topic_hint',
      desc: '',
      args: [],
    );
  }

  /// `Class Type`
  String get request_class_type {
    return Intl.message(
      'Class Type',
      name: 'request_class_type',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get request_class_type_hint {
    return Intl.message(
      'Select',
      name: 'request_class_type_hint',
      desc: '',
      args: [],
    );
  }

  /// `group`
  String get request_class_group {
    return Intl.message(
      'group',
      name: 'request_class_group',
      desc: '',
      args: [],
    );
  }

  /// `private`
  String get request_class_private {
    return Intl.message(
      'private',
      name: 'request_class_private',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get request_class_description {
    return Intl.message(
      'Description',
      name: 'request_class_description',
      desc: '',
      args: [],
    );
  }

  /// `Add Description`
  String get request_class_description_hint {
    return Intl.message(
      'Add Description',
      name: 'request_class_description_hint',
      desc: '',
      args: [],
    );
  }

  /// `Request`
  String get request_class_request {
    return Intl.message(
      'Request',
      name: 'request_class_request',
      desc: '',
      args: [],
    );
  }

  /// `No Class Requests.`
  String get empty_class_request {
    return Intl.message(
      'No Class Requests.',
      name: 'empty_class_request',
      desc: '',
      args: [],
    );
  }

  /// `Schedule on`
  String get request_class_schedule_on {
    return Intl.message(
      'Schedule on',
      name: 'request_class_schedule_on',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get menu_call {
    return Intl.message(
      'Call',
      name: 'menu_call',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get menu_delete {
    return Intl.message(
      'Delete',
      name: 'menu_delete',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get Account {
    return Intl.message(
      'Account',
      name: 'Account',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get settingsNoti {
    return Intl.message(
      'Notifications',
      name: 'settingsNoti',
      desc: '',
      args: [],
    );
  }

  /// `Share bvidya App`
  String get settingShare {
    return Intl.message(
      'Share bvidya App',
      name: 'settingShare',
      desc: '',
      args: [],
    );
  }

  /// `Rate App`
  String get settingRate {
    return Intl.message(
      'Rate App',
      name: 'settingRate',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get settingChat {
    return Intl.message(
      'Chats',
      name: 'settingChat',
      desc: '',
      args: [],
    );
  }

  /// `Clear Chat`
  String get clearChat {
    return Intl.message(
      'Clear Chat',
      name: 'clearChat',
      desc: '',
      args: [],
    );
  }

  /// `Blocked Users`
  String get blockedUser {
    return Intl.message(
      'Blocked Users',
      name: 'blockedUser',
      desc: '',
      args: [],
    );
  }

  /// `Chat Backup`
  String get ChatBackup {
    return Intl.message(
      'Chat Backup',
      name: 'ChatBackup',
      desc: '',
      args: [],
    );
  }

  /// `Export Chat`
  String get ExportChat {
    return Intl.message(
      'Export Chat',
      name: 'ExportChat',
      desc: '',
      args: [],
    );
  }

  /// `Do you really want to clear the chats?`
  String get ClearChatMessage {
    return Intl.message(
      'Do you really want to clear the chats?',
      name: 'ClearChatMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Clear chats`
  String get ClearChatConfirm {
    return Intl.message(
      'Yes, Clear chats',
      name: 'ClearChatConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Do you want Backup the chat?`
  String get ChatBackupMessage {
    return Intl.message(
      'Do you want Backup the chat?',
      name: 'ChatBackupMessage',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Backup the chat`
  String get ChatBackupConfirm {
    return Intl.message(
      'Yes, Backup the chat',
      name: 'ChatBackupConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get settingHelp {
    return Intl.message(
      'Help',
      name: 'settingHelp',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password, Delete Account`
  String get passReset {
    return Intl.message(
      'Reset Password, Delete Account',
      name: 'passReset',
      desc: '',
      args: [],
    );
  }

  /// `Chat history,themes,wallpapers`
  String get chatHistory {
    return Intl.message(
      'Chat history,themes,wallpapers',
      name: 'chatHistory',
      desc: '',
      args: [],
    );
  }

  /// `Sound ,notifications & others`
  String get notiHistory {
    return Intl.message(
      'Sound ,notifications & others',
      name: 'notiHistory',
      desc: '',
      args: [],
    );
  }

  /// `Help Center, Report Problem, Privacy Policy`
  String get helpCenter {
    return Intl.message(
      'Help Center, Report Problem, Privacy Policy',
      name: 'helpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Issue description can't be empty`
  String get issueDescriptionError {
    return Intl.message(
      'Issue description can\'t be empty',
      name: 'issueDescriptionError',
      desc: '',
      args: [],
    );
  }

  /// `Select a problem type`
  String get ProblemTypeError {
    return Intl.message(
      'Select a problem type',
      name: 'ProblemTypeError',
      desc: '',
      args: [],
    );
  }

  /// `No Courses Uploaded yet`
  String get NoCourses {
    return Intl.message(
      'No Courses Uploaded yet',
      name: 'NoCourses',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Date`
  String get preferredDate {
    return Intl.message(
      'Preferred Date',
      name: 'preferredDate',
      desc: '',
      args: [],
    );
  }

  /// `Preferred Time`
  String get preferredTime {
    return Intl.message(
      'Preferred Time',
      name: 'preferredTime',
      desc: '',
      args: [],
    );
  }

  /// `Request received on`
  String get requested_date_title {
    return Intl.message(
      'Request received on',
      name: 'requested_date_title',
      desc: '',
      args: [],
    );
  }

  /// `Note: The entered Date and time will be considered as preferred Date and time. Scheduled Class Date and Time will be set according to the Instructor preferrence.`
  String get Requested_time_Note {
    return Intl.message(
      'Note: The entered Date and time will be considered as preferred Date and time. Scheduled Class Date and Time will be set according to the Instructor preferrence.',
      name: 'Requested_time_Note',
      desc: '',
      args: [],
    );
  }

  /// `NOTE: Teacher-specific features will remain unavailable till the bvidya team approves your profile. In case of any questions, you may contact our support team at Support@bvidya.com`
  String get instructor_notApproved_note {
    return Intl.message(
      'NOTE: Teacher-specific features will remain unavailable till the bvidya team approves your profile. In case of any questions, you may contact our support team at Support@bvidya.com',
      name: 'instructor_notApproved_note',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting_title {
    return Intl.message(
      'Settings',
      name: 'setting_title',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_title {
    return Intl.message(
      'Contact Us',
      name: 'contact_title',
      desc: '',
      args: [],
    );
  }

  /// `Questions? need help?`
  String get contactDesc {
    return Intl.message(
      'Questions? need help?',
      name: 'contactDesc',
      desc: '',
      args: [],
    );
  }

  /// `FAQ`
  String get faq_title {
    return Intl.message(
      'FAQ',
      name: 'faq_title',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon...`
  String get coming_soon {
    return Intl.message(
      'Coming Soon...',
      name: 'coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `Find your answers here`
  String get faqDesc {
    return Intl.message(
      'Find your answers here',
      name: 'faqDesc',
      desc: '',
      args: [],
    );
  }

  /// `Made In `
  String get made_in {
    return Intl.message(
      'Made In ',
      name: 'made_in',
      desc: '',
      args: [],
    );
  }

  /// `Bharat`
  String get bharat {
    return Intl.message(
      'Bharat',
      name: 'bharat',
      desc: '',
      args: [],
    );
  }

  /// `Report an Issue`
  String get report_title {
    return Intl.message(
      'Report an Issue',
      name: 'report_title',
      desc: '',
      args: [],
    );
  }

  /// `Report an Issue you are facing in app`
  String get reposrtDesc {
    return Intl.message(
      'Report an Issue you are facing in app',
      name: 'reposrtDesc',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_title {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_title',
      desc: '',
      args: [],
    );
  }

  /// `Our policies`
  String get privacyDesc {
    return Intl.message(
      'Our policies',
      name: 'privacyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get terms_title {
    return Intl.message(
      'Terms of Use',
      name: 'terms_title',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsDesc {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Write us your query and we'll get back to you soon!`
  String get contactQuery {
    return Intl.message(
      'Write us your query and we\'ll get back to you soon!',
      name: 'contactQuery',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email Address`
  String get emailHint {
    return Intl.message(
      'Enter Your Email Address',
      name: 'emailHint',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetTitle {
    return Intl.message(
      'Reset Password',
      name: 'resetTitle',
      desc: '',
      args: [],
    );
  }

  /// `We have received your request to reset your password. A Email with link to reset your password will be sent to your registered email address.`
  String get resetPasswordEmail {
    return Intl.message(
      'We have received your request to reset your password. A Email with link to reset your password will be sent to your registered email address.',
      name: 'resetPasswordEmail',
      desc: '',
      args: [],
    );
  }

  /// `We have received your request about you forgetting your password. A Email with link to set new your password will be sent to your registered email address.`
  String get forgetPasswordEmail {
    return Intl.message(
      'We have received your request about you forgetting your password. A Email with link to set new your password will be sent to your registered email address.',
      name: 'forgetPasswordEmail',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submitBtn {
    return Intl.message(
      'Submit',
      name: 'submitBtn',
      desc: '',
      args: [],
    );
  }

  /// `Tell us how can we help you.`
  String get contactHint {
    return Intl.message(
      'Tell us how can we help you.',
      name: 'contactHint',
      desc: '',
      args: [],
    );
  }

  /// `bLive`
  String get blive {
    return Intl.message(
      'bLive',
      name: 'blive',
      desc: '',
      args: [],
    );
  }

  /// `bChat`
  String get bchat {
    return Intl.message(
      'bChat',
      name: 'bchat',
      desc: '',
      args: [],
    );
  }

  /// `bLearn`
  String get blearn {
    return Intl.message(
      'bLearn',
      name: 'blearn',
      desc: '',
      args: [],
    );
  }

  /// `bMeet`
  String get bmeet {
    return Intl.message(
      'bMeet',
      name: 'bmeet',
      desc: '',
      args: [],
    );
  }

  /// `Show Notifications`
  String get showNoty {
    return Intl.message(
      'Show Notifications',
      name: 'showNoty',
      desc: '',
      args: [],
    );
  }

  /// `Message`
  String get noti_message {
    return Intl.message(
      'Message',
      name: 'noti_message',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get noti_call {
    return Intl.message(
      'Call',
      name: 'noti_call',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get noti_group {
    return Intl.message(
      'Group',
      name: 'noti_group',
      desc: '',
      args: [],
    );
  }

  /// `Meeting Reminder`
  String get meetingRem {
    return Intl.message(
      'Meeting Reminder',
      name: 'meetingRem',
      desc: '',
      args: [],
    );
  }

  /// `Request a class`
  String get requestclass {
    return Intl.message(
      'Request a class',
      name: 'requestclass',
      desc: '',
      args: [],
    );
  }

  /// `Conference Reminder`
  String get confRem {
    return Intl.message(
      'Conference Reminder',
      name: 'confRem',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block message notifications`
  String get messDesc {
    return Intl.message(
      'Toggle to receive or block message notifications',
      name: 'messDesc',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block call notifications`
  String get callDesc {
    return Intl.message(
      'Toggle to receive or block call notifications',
      name: 'callDesc',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block group notifications`
  String get groupDesc {
    return Intl.message(
      'Toggle to receive or block group notifications',
      name: 'groupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block meeting reminder notifications`
  String get meetingDesc {
    return Intl.message(
      'Toggle to receive or block meeting reminder notifications',
      name: 'meetingDesc',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block conference reminder notifications`
  String get confDesc {
    return Intl.message(
      'Toggle to receive or block conference reminder notifications',
      name: 'confDesc',
      desc: '',
      args: [],
    );
  }

  /// `Do Not Disturb`
  String get dndTitle {
    return Intl.message(
      'Do Not Disturb',
      name: 'dndTitle',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block bvidya\nnotifications`
  String get dndDesc {
    return Intl.message(
      'Toggle to receive or block bvidya\nnotifications',
      name: 'dndDesc',
      desc: '',
      args: [],
    );
  }

  /// `Message,groups & call tones`
  String get notyDesc {
    return Intl.message(
      'Message,groups & call tones',
      name: 'notyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sound`
  String get soundTitle {
    return Intl.message(
      'Sound',
      name: 'soundTitle',
      desc: '',
      args: [],
    );
  }

  /// `Report an issue you are facing in app`
  String get soundDesc {
    return Intl.message(
      'Report an issue you are facing in app',
      name: 'soundDesc',
      desc: '',
      args: [],
    );
  }

  /// `Class Requested by`
  String get class_requested_title {
    return Intl.message(
      'Class Requested by',
      name: 'class_requested_title',
      desc: '',
      args: [],
    );
  }

  /// `Class Requested to`
  String get class_request_title {
    return Intl.message(
      'Class Requested to',
      name: 'class_request_title',
      desc: '',
      args: [],
    );
  }

  /// `Private Class Requests`
  String get privateClassTitle {
    return Intl.message(
      'Private Class Requests',
      name: 'privateClassTitle',
      desc: '',
      args: [],
    );
  }

  /// `Toggle to receive or block private class\nrequest notifications`
  String get privateDesc {
    return Intl.message(
      'Toggle to receive or block private class\nrequest notifications',
      name: 'privateDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reset Notification Setting`
  String get resetNoty {
    return Intl.message(
      'Reset Notification Setting',
      name: 'resetNoty',
      desc: '',
      args: [],
    );
  }

  /// `Reset all notification setting`
  String get resetDesc {
    return Intl.message(
      'Reset all notification setting',
      name: 'resetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reset your password`
  String get resetPassDesc {
    return Intl.message(
      'Reset your password',
      name: 'resetPassDesc',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get accnt_security {
    return Intl.message(
      'Security',
      name: 'accnt_security',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAcc {
    return Intl.message(
      'Delete Account',
      name: 'deleteAcc',
      desc: '',
      args: [],
    );
  }

  /// `End-to-End encrypted`
  String get secrityDesc {
    return Intl.message(
      'End-to-End encrypted',
      name: 'secrityDesc',
      desc: '',
      args: [],
    );
  }

  /// `Delete your account`
  String get deleteDesc {
    return Intl.message(
      'Delete your account',
      name: 'deleteDesc',
      desc: '',
      args: [],
    );
  }

  /// `Report a Problem`
  String get reportTitle {
    return Intl.message(
      'Report a Problem',
      name: 'reportTitle',
      desc: '',
      args: [],
    );
  }

  /// `Select a feature you're experiencing a\nproblem with:`
  String get reportDesc {
    return Intl.message(
      'Select a feature you\'re experiencing a\nproblem with:',
      name: 'reportDesc',
      desc: '',
      args: [],
    );
  }

  /// `Issues Description`
  String get issues {
    return Intl.message(
      'Issues Description',
      name: 'issues',
      desc: '',
      args: [],
    );
  }

  /// `Describe your issues in detail.`
  String get issuesDesc {
    return Intl.message(
      'Describe your issues in detail.',
      name: 'issuesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete\nyour account?`
  String get dltConfirmation {
    return Intl.message(
      'Are you sure want to delete\nyour account?',
      name: 'dltConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Sure, want to delete`
  String get sureDlt {
    return Intl.message(
      'Sure, want to delete',
      name: 'sureDlt',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get dltCancel {
    return Intl.message(
      'Cancel',
      name: 'dltCancel',
      desc: '',
      args: [],
    );
  }

  /// `userid@gmail.com`
  String get profile_gmail {
    return Intl.message(
      'userid@gmail.com',
      name: 'profile_gmail',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile_title {
    return Intl.message(
      'Profile',
      name: 'profile_title',
      desc: '',
      args: [],
    );
  }

  /// `Profile Detail`
  String get profile_detail {
    return Intl.message(
      'Profile Detail',
      name: 'profile_detail',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get profile_logout {
    return Intl.message(
      'Logout',
      name: 'profile_logout',
      desc: '',
      args: [],
    );
  }

  /// `Invite a Friend`
  String get profile_invite {
    return Intl.message(
      'Invite a Friend',
      name: 'profile_invite',
      desc: '',
      args: [],
    );
  }

  /// `Become An Instructor`
  String get profile_instr {
    return Intl.message(
      'Become An Instructor',
      name: 'profile_instr',
      desc: '',
      args: [],
    );
  }

  /// `My Learning`
  String get profile_learning {
    return Intl.message(
      'My Learning',
      name: 'profile_learning',
      desc: '',
      args: [],
    );
  }

  /// `Bhavya Malik`
  String get teachers_username {
    return Intl.message(
      'Bhavya Malik',
      name: 'teachers_username',
      desc: '',
      args: [],
    );
  }

  /// `2k Followers`
  String get teachers_followers {
    return Intl.message(
      '2k Followers',
      name: 'teachers_followers',
      desc: '',
      args: [],
    );
  }

  /// `6 hours left`
  String get course_timer {
    return Intl.message(
      '6 hours left',
      name: 'course_timer',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get course_header {
    return Intl.message(
      'Courses',
      name: 'course_header',
      desc: '',
      args: [],
    );
  }

  /// `Teachers Followed`
  String get teachers_header {
    return Intl.message(
      'Teachers Followed',
      name: 'teachers_header',
      desc: '',
      args: [],
    );
  }

  /// `Stock Market Trading: \nThe Complete Technical \nCourses`
  String get course_title {
    return Intl.message(
      'Stock Market Trading: \nThe Complete Technical \nCourses',
      name: 'course_title',
      desc: '',
      args: [],
    );
  }

  /// `Continue Learning`
  String get course_conti {
    return Intl.message(
      'Continue Learning',
      name: 'course_conti',
      desc: '',
      args: [],
    );
  }

  /// `80%`
  String get course_percent {
    return Intl.message(
      '80%',
      name: 'course_percent',
      desc: '',
      args: [],
    );
  }

  /// `Chemistry Educator`
  String get teacher_sub {
    return Intl.message(
      'Chemistry Educator',
      name: 'teacher_sub',
      desc: '',
      args: [],
    );
  }

  /// `K12 & NEET`
  String get teacher_prep {
    return Intl.message(
      'K12 & NEET',
      name: 'teacher_prep',
      desc: '',
      args: [],
    );
  }

  /// `7 Years of Experience`
  String get teacher_exp {
    return Intl.message(
      '7 Years of Experience',
      name: 'teacher_exp',
      desc: '',
      args: [],
    );
  }

  /// `{year} Years of Experience`
  String teacher_exp_value(Object year) {
    return Intl.message(
      '$year Years of Experience',
      name: 'teacher_exp_value',
      desc: '',
      args: [year],
    );
  }

  /// `Follow`
  String get teacher_follow {
    return Intl.message(
      'Follow',
      name: 'teacher_follow',
      desc: '',
      args: [],
    );
  }

  /// `Followed`
  String get teacher_followed {
    return Intl.message(
      'Followed',
      name: 'teacher_followed',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get teacher_about {
    return Intl.message(
      'About',
      name: 'teacher_about',
      desc: '',
      args: [],
    );
  }

  /// `2K`
  String get teacher_folowers_no {
    return Intl.message(
      '2K',
      name: 'teacher_folowers_no',
      desc: '',
      args: [],
    );
  }

  /// `Followers`
  String get teacher_followers {
    return Intl.message(
      'Followers',
      name: 'teacher_followers',
      desc: '',
      args: [],
    );
  }

  /// `57 Hours`
  String get teacher_watch_time {
    return Intl.message(
      '57 Hours',
      name: 'teacher_watch_time',
      desc: '',
      args: [],
    );
  }

  /// `Watch Time`
  String get teacher_watch {
    return Intl.message(
      'Watch Time',
      name: 'teacher_watch',
      desc: '',
      args: [],
    );
  }

  /// `All Courses`
  String get teacher_all_courses {
    return Intl.message(
      'All Courses',
      name: 'teacher_all_courses',
      desc: '',
      args: [],
    );
  }

  /// `View all >`
  String get teacher_view_all {
    return Intl.message(
      'View all >',
      name: 'teacher_view_all',
      desc: '',
      args: [],
    );
  }

  /// `Most Viewed`
  String get teacher_most_viewed {
    return Intl.message(
      'Most Viewed',
      name: 'teacher_most_viewed',
      desc: '',
      args: [],
    );
  }

  /// `Instructor Details`
  String get course_instructor_detail {
    return Intl.message(
      'Instructor Details',
      name: 'course_instructor_detail',
      desc: '',
      args: [],
    );
  }

  /// `Worked at BHARAT CHEMISTRY\nCLASSES`
  String get course_work {
    return Intl.message(
      'Worked at BHARAT CHEMISTRY\nCLASSES',
      name: 'course_work',
      desc: '',
      args: [],
    );
  }

  /// `Lives in Karnal,Haryana,India`
  String get course_loca {
    return Intl.message(
      'Lives in Karnal,Haryana,India',
      name: 'course_loca',
      desc: '',
      args: [],
    );
  }

  /// `bVidya Educator since\n6th July, 2018`
  String get course_calender {
    return Intl.message(
      'bVidya Educator since\n6th July, 2018',
      name: 'course_calender',
      desc: '',
      args: [],
    );
  }

  /// `Knows Hinglish, Hindi and\nEnglish`
  String get course_lang {
    return Intl.message(
      'Knows Hinglish, Hindi and\nEnglish',
      name: 'course_lang',
      desc: '',
      args: [],
    );
  }

  /// `Profile Detail`
  String get prof_edit_title {
    return Intl.message(
      'Profile Detail',
      name: 'prof_edit_title',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get prof_edit_name {
    return Intl.message(
      'Name',
      name: 'prof_edit_name',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get prof_edit_no {
    return Intl.message(
      'Phone Number',
      name: 'prof_edit_no',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get prof_edit_age {
    return Intl.message(
      'Age',
      name: 'prof_edit_age',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get prof_edit_address {
    return Intl.message(
      'Address',
      name: 'prof_edit_address',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get prof_edit_email {
    return Intl.message(
      'Email Address',
      name: 'prof_edit_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Name`
  String get prof_hint_name {
    return Intl.message(
      'Enter Your Name',
      name: 'prof_hint_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Phone Number`
  String get prof_hint_no {
    return Intl.message(
      'Enter Your Phone Number',
      name: 'prof_hint_no',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your EmailId`
  String get prof_hint_email {
    return Intl.message(
      'Enter Your EmailId',
      name: 'prof_hint_email',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Address`
  String get prof_hint_add {
    return Intl.message(
      'Enter Your Address',
      name: 'prof_hint_add',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Age`
  String get prof_hint_age {
    return Intl.message(
      'Enter Your Age',
      name: 'prof_hint_age',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get prof_save_btn {
    return Intl.message(
      'Save',
      name: 'prof_save_btn',
      desc: '',
      args: [],
    );
  }

  /// `Friend Requests`
  String get requests {
    return Intl.message(
      'Friend Requests',
      name: 'requests',
      desc: '',
      args: [],
    );
  }

  /// `Request Sent`
  String get request_sent {
    return Intl.message(
      'Request Sent',
      name: 'request_sent',
      desc: '',
      args: [],
    );
  }

  /// `No Requests.`
  String get no_request {
    return Intl.message(
      'No Requests.',
      name: 'no_request',
      desc: '',
      args: [],
    );
  }

  /// `Request Received`
  String get request_recv {
    return Intl.message(
      'Request Received',
      name: 'request_recv',
      desc: '',
      args: [],
    );
  }

  /// `My Dashboard`
  String get tp_dashboard {
    return Intl.message(
      'My Dashboard',
      name: 'tp_dashboard',
      desc: '',
      args: [],
    );
  }

  /// `My Schedule`
  String get tp_schedule {
    return Intl.message(
      'My Schedule',
      name: 'tp_schedule',
      desc: '',
      args: [],
    );
  }

  /// `Class Requests`
  String get tp_classes {
    return Intl.message(
      'Class Requests',
      name: 'tp_classes',
      desc: '',
      args: [],
    );
  }

  /// `Language Known`
  String get tpe_lang {
    return Intl.message(
      'Language Known',
      name: 'tpe_lang',
      desc: '',
      args: [],
    );
  }

  /// `Bio`
  String get tpe_bio {
    return Intl.message(
      'Bio',
      name: 'tpe_bio',
      desc: '',
      args: [],
    );
  }

  /// `Worked At`
  String get tpe_worked {
    return Intl.message(
      'Worked At',
      name: 'tpe_worked',
      desc: '',
      args: [],
    );
  }

  /// `Occupation`
  String get tpe_occupation {
    return Intl.message(
      'Occupation',
      name: 'tpe_occupation',
      desc: '',
      args: [],
    );
  }

  /// `Enter your bio`
  String get tpe_bio_hint {
    return Intl.message(
      'Enter your bio',
      name: 'tpe_bio_hint',
      desc: '',
      args: [],
    );
  }

  /// `What was the name of our previous Organzation?`
  String get tpe_worked_hint {
    return Intl.message(
      'What was the name of our previous Organzation?',
      name: 'tpe_worked_hint',
      desc: '',
      args: [],
    );
  }

  /// `What language do you know?`
  String get tpe_lang_hint {
    return Intl.message(
      'What language do you know?',
      name: 'tpe_lang_hint',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get tp_courses {
    return Intl.message(
      'Courses',
      name: 'tp_courses',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get td_dash {
    return Intl.message(
      'Dashboard',
      name: 'td_dash',
      desc: '',
      args: [],
    );
  }

  /// `Total Revenue Generated`
  String get td_revenue {
    return Intl.message(
      'Total Revenue Generated',
      name: 'td_revenue',
      desc: '',
      args: [],
    );
  }

  /// `₹ 20,456`
  String get td_amt {
    return Intl.message(
      '₹ 20,456',
      name: 'td_amt',
      desc: '',
      args: [],
    );
  }

  /// `Total Subscribers`
  String get td_subs {
    return Intl.message(
      'Total Subscribers',
      name: 'td_subs',
      desc: '',
      args: [],
    );
  }

  /// `Total Watch Time`
  String get td_hrs {
    return Intl.message(
      'Total Watch Time',
      name: 'td_hrs',
      desc: '',
      args: [],
    );
  }

  /// `2.6 K`
  String get td_total_subs {
    return Intl.message(
      '2.6 K',
      name: 'td_total_subs',
      desc: '',
      args: [],
    );
  }

  /// `60+ hrs`
  String get td_watch_time {
    return Intl.message(
      '60+ hrs',
      name: 'td_watch_time',
      desc: '',
      args: [],
    );
  }

  /// `Uploaded Courses`
  String get td_courses {
    return Intl.message(
      'Uploaded Courses',
      name: 'td_courses',
      desc: '',
      args: [],
    );
  }

  /// `Top Running Courses`
  String get td_running {
    return Intl.message(
      'Top Running Courses',
      name: 'td_running',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong! Try again.`
  String get error {
    return Intl.message(
      'Something went wrong! Try again.',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `There was an error Connecting. Please check your connection and try again`
  String get internet_error {
    return Intl.message(
      'There was an error Connecting. Please check your connection and try again',
      name: 'internet_error',
      desc: '',
      args: [],
    );
  }

  /// `Refreshing...`
  String get refresh {
    return Intl.message(
      'Refreshing...',
      name: 'refresh',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
