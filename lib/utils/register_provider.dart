import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagerAPIProvider {
  static void registerClientFromSetting(Setting setting, AppProvider provider) {
    if (setting.isValid()) {
      var api = CLNApi(
          mode: setting.clientMode,
          client: ClientProvider.getClient(
              mode: setting.clientMode, opts: setting.toOpts()));
      provider.overrideDependence(api);
    }
  }

  static Future<void> clear({required AppProvider provider}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("setting");
    provider.overrideDependence(Setting());
  }
}
