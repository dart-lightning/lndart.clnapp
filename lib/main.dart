import 'package:clnapp/constants/user_setting.dart';
import 'package:clnapp/helper/settings/get_settings.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:clnapp/views/setting/setting_view.dart';
import 'package:flutter/material.dart';
import 'package:trash_themes/themes.dart';

Future<void> main() async {
  var provider = await AppProvider().init();

  /// TODO just for now we insert by hand GRPC information, but in the future
  /// we need to have a Setting UI!
  // var certificateDir = Platform.environment['CLN_CERT_PATH'];
  // if (certificateDir == null) {
  //   throw Exception("Please export the CLN_CERT_PATH for your system");
  // }
  Setting setting = Setting();
  await getSettingsInfo().then((value) => {
        setting = value,
      });
  // provider.registerLazyDependence<AppApi>(() {
  //   if(setting.connectionType==clients[0]){
  //     return CLNApi(
  //         mode: ClientMode.grpc,
  //         client: ClientProvider.getClient(mode: ClientMode.grpc, opts: {
  //           ///FIXME: make a login page and take some path as input
  //           'certificatePath': setting.path,
  //           'host': setting.host,
  //           'port': 8001,
  //         })
  //     );
  //   }
  //   else{
  //     return CLNApi(
  //       mode: ClientMode.unixSocket,
  //         ///FIXME: make a login page and take some path as input
  //       client: ClientProvider.getClient(mode: ClientMode.unixSocket, opts: {
  //         // include the path if you want use the unix socket. N.B it is broken!
  //         'path': "${setting.path}/lightning-rpc",
  //       })
  //     );
  //   }
  // });
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
