import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/unregister_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearSetting {
  static Future<Setting> clear({required AppProvider provider}) async {
    UnregisterProvider.unregisterClientFromSetting(provider);
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("setting");
    return Setting();
  }
}
