// lib/services/storage_service.dart
// Local persistence using SharedPreferences

import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (call once at app startup)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // ─── Auth ────────────────────────────────────────────────────────────────────

  static Future<void> setLoggedIn(bool value) async {
    await _instance.setBool(AppConstants.keyIsLoggedIn, value);
  }

  static bool isLoggedIn() {
    return _prefs?.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  static Future<void> setUserEmail(String email) async {
    await _instance.setString(AppConstants.keyUserEmail, email);
  }

  static String getUserEmail() {
    return _prefs?.getString(AppConstants.keyUserEmail) ?? '';
  }

  static Future<void> setUserName(String name) async {
    await _instance.setString(AppConstants.keyUserName, name);
  }

  static String getUserName() {
    return _prefs?.getString(AppConstants.keyUserName) ?? '';
  }

  static Future<void> setUserRollNo(String rollNo) async {
    await _instance.setString(AppConstants.keyUserRollNo, rollNo);
  }

  static String getUserRollNo() {
    return _prefs?.getString(AppConstants.keyUserRollNo) ?? '';
  }

  static Future<void> setUserDepartment(String dept) async {
    await _instance.setString(AppConstants.keyUserDepartment, dept);
  }

  static String getUserDepartment() {
    return _prefs?.getString(AppConstants.keyUserDepartment) ?? AppConstants.demoDepartment;
  }

  static Future<void> setUserYear(String year) async {
    await _instance.setString(AppConstants.keyUserYear, year);
  }

  static String getUserYear() {
    return _prefs?.getString(AppConstants.keyUserYear) ?? AppConstants.demoYear;
  }

  static Future<void> clearSession() async {
    await _instance.remove(AppConstants.keyIsLoggedIn);
    await _instance.remove(AppConstants.keyUserEmail);
    await _instance.remove(AppConstants.keyUserName);
    await _instance.remove(AppConstants.keyUserRollNo);
    await _instance.remove(AppConstants.keyUserDepartment);
    await _instance.remove(AppConstants.keyUserYear);
    // Note: We keep joined clubs and registered events so data persists
    // If a full reset is needed, call clearAll()
  }

  static Future<void> clearAll() async {
    await _instance.clear();
  }

  // ─── Club Membership ─────────────────────────────────────────────────────────

  static Future<void> saveJoinedClubs(List<String> clubIds) async {
    await _instance.setStringList(AppConstants.keyJoinedClubs, clubIds);
  }

  static List<String> getJoinedClubs() {
    return _prefs?.getStringList(AppConstants.keyJoinedClubs) ?? [];
  }

  static Future<void> joinClub(String clubId) async {
    final joined = getJoinedClubs();
    if (!joined.contains(clubId)) {
      joined.add(clubId);
      await saveJoinedClubs(joined);
    }
  }

  static Future<void> leaveClub(String clubId) async {
    final joined = getJoinedClubs();
    joined.remove(clubId);
    await saveJoinedClubs(joined);
  }

  static bool hasJoinedClub(String clubId) {
    return getJoinedClubs().contains(clubId);
  }

  // ─── Event Registration ───────────────────────────────────────────────────────

  static Future<void> saveRegisteredEvents(List<String> eventIds) async {
    await _instance.setStringList(AppConstants.keyRegisteredEvents, eventIds);
  }

  static List<String> getRegisteredEvents() {
    return _prefs?.getStringList(AppConstants.keyRegisteredEvents) ?? [];
  }

  static Future<void> registerEvent(String eventId) async {
    final registered = getRegisteredEvents();
    if (!registered.contains(eventId)) {
      registered.add(eventId);
      await saveRegisteredEvents(registered);
    }
  }

  static bool hasRegisteredEvent(String eventId) {
    return getRegisteredEvents().contains(eventId);
  }
}
