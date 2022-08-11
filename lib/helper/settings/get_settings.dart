import 'dart:convert';

import 'package:clnapp/model/user_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Setting> getSettingsInfo() async {
  final prefs = await SharedPreferences.getInstance();
  var settingJson = prefs.getString("setting");
  if (settingJson == null) {
    return Setting();
  }
  Map<String, dynamic> rawJson = json.decode(settingJson);
  return Setting.fromJson(rawJson);
}
