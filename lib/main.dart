import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/helper/settings/get_settings.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/register_provider.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:clnapp/views/setting/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:trash_themes/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var provider = await AppProvider().init();
  Setting setting = await getSettingsInfo(provider: provider);
  await ManagerAPIProvider.registerClientFromSetting(setting, provider);

  runApp(CLNApp(provider: provider));
}

class CLNApp extends AppView {
  const CLNApp({Key? key, required AppProvider provider})
      : super(key: key, provider: provider);

  @override
  Widget build(BuildContext context) {
    var setting = provider.get<Setting>();
    return MaterialApp(
      title: 'CLN App',
      themeMode: ThemeMode.dark,
      theme: DraculaTheme().makeDarkTheme(context: context),
      debugShowCheckedModeBanner: false,
      home: setting.isValid()
          ? HomeView(provider: provider)
          : SettingView(provider: provider),
    );
  }
}
