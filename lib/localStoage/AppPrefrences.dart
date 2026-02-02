import 'dart:convert';

import 'package:myrex11/repository/model/banner_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefrence {
  static Future<bool> getBoolean(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
          key,
        ) ??
        false;
  }

  static Future<bool> putBoolean(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<String> getString(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<bool> putString(String key, String? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value ?? '');
  }

  static Future<bool> putInt(String key, int? value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(key, value ?? 0);
  }

  static Future<int> getInt(String key, int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt(key) ?? 0;
  }

  static Future<int> getPreviousDate(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt(key) ?? 0;
  }

  static void clearPrefrence() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<void> putStringList(String key, List<String> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, list);
  }

  static Future<List<String>?> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key);
  }

  static Future<void> putObjectList(String key, List<dynamic> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert object list → JSON string
    final jsonString = jsonEncode(list.map((e) => e.toJson()).toList());

    await prefs.setString(key, jsonString);
  }

  static Future<List<T>> getObjectList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  // Add these methods to your AppPrefrence class
  static Future<void> putContactInfo(ContactInfo contactInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('contact_title', contactInfo.title ?? '');
    await prefs.setString('contact_email', contactInfo.email_detail ?? '');
    await prefs.setString('contact_mobile', contactInfo.mobile_detail ?? '');
    await prefs.setString('contact_facebook', contactInfo.facebook ?? '');
    await prefs.setString('contact_twitter', contactInfo.twitter ?? '');
    await prefs.setString('contact_instagram', contactInfo.instagram ?? '');
    await prefs.setString('contact_telegram', contactInfo.telegram ?? '');
    await prefs.setString('contact_youtube', contactInfo.youtube ?? '');
    await prefs.setString('contact_whatsup', contactInfo.whatsup ?? '');
  }

  static Future<ContactInfo> getContactInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return ContactInfo(
      title: prefs.getString('contact_title'),
      email_detail: prefs.getString('contact_email'),
      mobile_detail: prefs.getString('contact_mobile'),
      facebook: prefs.getString('contact_facebook'),
      twitter: prefs.getString('contact_twitter'),
      instagram: prefs.getString('contact_instagram'),
      telegram: prefs.getString('contact_telegram'),
      youtube: prefs.getString('contact_youtube'),
      whatsup: prefs.getString('contact_whatsup'),
    );
  }
}
