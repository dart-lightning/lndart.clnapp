import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/cln_provider.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'package:clnapp/views/app_view.dart';
import 'package:clnapp/views/home/home_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  var provider = await AppProvider().init();

  /// TODO just for now we insert by hand GRPC information, but in the future
  /// we need to have a Setting UI!
  var certificateDir = "/media/vincent/VincentSSD/.lightning/testnet";
  provider.registerLazyDependence<GRPCClient>(
      () => CLNProvider.getClient(mode: ClientMode.grpc, opts: {
            'certificatePath': certificateDir,
            'host': 'localhost',
            'port': 8001,
          }));
  runApp(CLNApp(provider: provider));
}

class CLNApp extends AppView {
  const CLNApp({Key? key, required AppProvider provider})
      : super(key: key, provider: provider);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CLN App',
      debugShowCheckedModeBanner: false,
      home: HomeView(provider: provider),
    );
  }
}
