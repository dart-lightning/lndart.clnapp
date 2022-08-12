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
  var provider = await AppProvider().init();

  //FIXME: put the setting inside the APIProvider
  Setting setting = Setting();

  await getSettingsInfo().then((value) => {
        setting = value,
      });

  RegisterProvider().registerClientFromSetting(setting, provider);

  runApp(CLNApp(provider: provider, setting: setting));
}

class CLNApp extends AppView {
  const CLNApp(
      {Key? key, required AppProvider provider, required Setting setting})
      : super(key: key, provider: provider, setting: setting);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLN App',
      themeMode: ThemeMode.dark,
      theme: DraculaTheme().makeDarkTheme(context: context),
      debugShowCheckedModeBanner: false,
      home: setting.path != "No path found"
          ? HomeView(provider: provider)
          : SettingView(provider: provider),
    );
  }
}
