import 'package:clnapp/api/api.dart';
import 'package:clnapp/utils/app_provider.dart';

class UnregisterProvider {
  static void unregisterClientFromSetting(AppProvider provider) {
    provider.unregisterDependence<AppApi>();
  }
}
