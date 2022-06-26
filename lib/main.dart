import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:trash_themes/themes.dart';

Future<void> main() async {
  var provider = await AppProvider().init();

  /// TODO just for now we insert by hand GRPC information, but in the future
  /// we need to have a Setting UI!
  var certificateDir = "/media/vincent/VincentSSD/.lightning/testnet";
  provider.registerLazyDependence<AppApi>(() {
    return CLNApi(
        mode: ClientMode.grpc,
        client: ClientProvider.getClient(mode: ClientMode.grpc, opts: {
          'certificatePath': certificateDir,
          'host': 'localhost',
          'port': 8001,
          // include the path if you want use the unix socket. N.B it is broken!
          //'path': "/media/vincent/VincentSSD/.lightning/testnet/lightning-rpc"
        }));
  });
  runApp(CLNApp(provider: provider));
}

class CLNApp extends AppView {
  const CLNApp({Key? key, required AppProvider provider})
      : super(key: key, provider: provider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLN App',
      themeMode: ThemeMode.dark,
      theme: DraculaTheme().makeDarkTheme(context: context),
      debugShowCheckedModeBanner: false,
      home: HomeView(provider: provider),
    );
  }
}
