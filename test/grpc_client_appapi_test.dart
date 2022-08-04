import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';

void main() async {
  var provider = await AppProvider().init();

  var env = Platform.environment;
  var certificateDir = env['TLS_PATH'];
  if (certificateDir == null) {
    throw Exception("Please export the CLN_CERT_PATH for your system");
  }
  provider.registerLazyDependence<AppApi>(() {
    return CLNApi(
        mode: ClientMode.grpc,
        client: ClientProvider.getClient(mode: ClientMode.grpc, opts: {
          'certificatePath': certificateDir,
          'host': 'localhost',
          'port': 8001,
        }));
  });

  group('clnapp gRPC_client tests', () {
    test('API List Funds', () async {
      final fundsList = await provider.get<AppApi>().listFunds();
      expect(fundsList, isNotNull);
      expect(fundsList!.fund.isEmpty, isTrue);
    });
  });
}
