import 'package:clnapp/constants/user_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Setting> getSettingsInfo() async{
  Setting setting = Setting();
  final prefs = await SharedPreferences.getInstance();
    setting.connectionType = clients[prefs.getInt('connectionClient')!];

    setting.path = prefs.getString('selectedPath')!;

    setting.host = prefs.getString('host')!;
    setting.nickName = prefs.getString('nickName')!;

  return setting;
}