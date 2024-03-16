import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/helper/settings/get_settings.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/utils/register_provider.dart';
import 'package:clnapp/views/splash_screen/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:trash_themes/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var provider = await AppProvider().init();
  Setting setting = await getSettingsInfo(provider: provider);
  await ManagerAPIProvider.registerClientFromSetting(setting, provider);

  runApp(CLNApp(provider: provider, setting: setting));
}

class CLNApp extends StatelessWidget {
  final AppProvider provider;
  final Setting setting;

  const CLNApp({Key? key, required this.provider, required this.setting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLN App',
      themeMode: ThemeMode.dark,
      theme: DraculaTheme().makeDarkTheme(context: context),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(provider: provider, setting: setting),
    );
  }
}
