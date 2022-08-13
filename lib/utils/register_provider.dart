import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/unregister_provider.dart';
import 'package:get_it/get_it.dart';

class RegisterProvider {
  static void registerClientFromSetting(Setting setting, AppProvider provider) {
    if (setting.isValid()) {
      if (GetIt.instance.isRegistered<AppApi>()) {
        UnregisterProvider.unregisterClientFromSetting(provider);
      }
      provider.registerLazyDependence<AppApi>(() {
        return CLNApi(
            mode: setting.clientMode,
            client: ClientProvider.getClient(
                mode: setting.clientMode, opts: setting.toOpts()));
      });
    }
  }
}
