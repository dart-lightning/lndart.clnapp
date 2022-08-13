import 'dart:convert';

import 'package:cln_common/cln_common.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Setting> getSettingsInfo({required AppProvider provider}) async {
  final prefs = await SharedPreferences.getInstance();
  var settingJson = prefs.getString("setting");
  if (settingJson == null) {
    return provider.get<Setting>();
  }
  LogManager.getInstance.debug("Setting string: $settingJson");
  Map<String, dynamic> rawJson = json.decode(settingJson);
  var setting = Setting.fromJson(rawJson);
  provider.overrideDependence(setting);
  return setting;
}
