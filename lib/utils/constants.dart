// lib/utils/constants.dart
// Application-wide constants for College Club Management

class AppConstants {
  // App Identity
  static const String appName = 'College Club';
  static const String appFullName = 'College Club Management';
  static const String appSubtitle = 'Manage Your Campus Life';
  static const String appVersion = '1.0.0';
  static const String appDepartment = 'B.Tech Flutter Laboratory Project';

  // Student Profile & Login Credentials
  static const String demoRollNo = '24XZ1A1219';
  static const String demoName = 'Mahesh';
  static const String demoDepartment = 'Information Technology (IT)';
  static const String demoYear = 'B.Tech – 3rd Year';
  static const String demoEmail = 'mahesh@college.edu';
  static const String demoPassword = 'password123';

  // SharedPreferences Keys
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyUserRollNo = 'user_roll_no';
  static const String keyUserDepartment = 'user_dept';
  static const String keyUserYear = 'user_year';
  static const String keyJoinedClubs = 'joined_clubs';
  static const String keyRegisteredEvents = 'registered_events';

  // Club Categories
  static const List<String> clubCategories = [
    'All',
    'Technical',
    'Cultural',
    'Sports',
    'Photography',
    'Music',
  ];

  // Navigation Indices
  static const int navHome = 0;
  static const int navClubs = 1;
  static const int navEvents = 2;
  static const int navMyClubs = 3;
}
