import 'dart:convert';

import 'package:cln_common/cln_common.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api.dart';

class ManagerAPIProvider {
  static Future<void> registerClientFromSetting(
      Setting setting, AppProvider provider) async {
    try {
      LogManager.getInstance.debug(
          "Setting received: ${jsonEncode(setting.toJson())} and is valid: ${setting.isValid()}");
      if (setting.isValid()) {
        AppApi api = CLNApi(
            mode: setting.clientMode!,
            client: ClientProvider.getClient(
                mode: setting.clientMode!, opts: setting.toOpts()));
        provider.overrideDependence<AppApi>(api);
      }
    } catch (ex, stacktrace) {
      LogManager.getInstance.error("$ex");
      LogManager.getInstance.error("$stacktrace");
      await ManagerAPIProvider.clear(provider: provider);
    }
  }

  static Future<void> clear({required AppProvider provider}) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("setting");
    provider.overrideDependence(Setting());
  }
}
