import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/model/user_setting.dart';
import 'package:clnapp/helper/settings/get_settings.dart';
import 'package:clnapp/utils/app_provider.dart';
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

  // FIXME: add a method isValid() inside the setting to check if all the configuration are
  // correct, otheriwise throws an error to disply to the user
  if (setting.path != "No path found" || setting.clientMode == clients[2]) {
    provider.registerLazyDependence<AppApi>(() {
      if (setting.clientMode == clients[0]) {
        return CLNApi(
            mode: ClientMode.grpc,
            client: ClientProvider.getClient(mode: ClientMode.grpc, opts: {
              ///FIXME: make a login page and take some path as input
              'certificatePath': setting.path,
              'host': setting.host,
              'port': 8001,
            }));
      } else if (setting.clientMode == clients[1]) {
        return CLNApi(
            mode: ClientMode.unixSocket,

            ///FIXME: make a login page and take some path as input
            client:
                ClientProvider.getClient(mode: ClientMode.unixSocket, opts: {
              // include the path if you want use the unix socket. N.B it is broken!
              'path': "${setting.path}/lightning-rpc",
            }));
      } else {
        return CLNApi(
            mode: ClientMode.lnlambda,
            client: ClientProvider.getClient(mode: ClientMode.lnlambda, opts: {
              'node_id': setting.nodeId,
              'host': setting.host,
              'lambda_server': setting.lambdaServer,
              'rune': setting.rune,
            }));
      }
    });
  }
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
