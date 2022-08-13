import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/cln_client.dart';
import 'package:clnapp/utils/app_provider.dart';
import 'dart:io' show Platform;

import 'package:flutter_test/flutter_test.dart';

void main() async {
  var provider = await AppProvider().init();

  var env = Platform.environment;
  var lightningRPC = env['RPC_PATH'];
  if (lightningRPC == null) {
    throw Exception("Please export the RPC_PATH for your system");
  }
  provider.registerLazyDependence<AppApi>(() {
    return CLNApi(
        mode: ClientMode.unixSocket,
        client: ClientProvider.getClient(
            testing: true,
            mode: ClientMode.unixSocket,
            opts: {
              'path': lightningRPC,
            }));
  });

  group('clnapp unix_client tests', () {
    test('API Get Info', () async {
      final getInfo = await provider.get<AppApi>().getInfo();
      expect(getInfo, isNotNull);
      expect(getInfo.alias, "clighting4j-node");
    });

    test('API List Funds', () async {
      final fundsList = await provider.get<AppApi>().listFunds();
      expect(fundsList, isNotNull);
      expect(fundsList!.fund, isNotNull);
      expect(fundsList.channelSats, isNotNull);
      expect(fundsList.fundChannels, isNotNull);
    });

    test('API List Invoices', () async {
      final invoiceList = await provider.get<AppApi>().listInvoices();
      expect(invoiceList, isNotNull);
      expect(invoiceList.invoice, isNotNull);
    });

    test('API List Transactions', () async {
      final transactionList = await provider.get<AppApi>().listTransaction();
      expect(transactionList, isNotNull);
      expect(transactionList.transactions, isNotNull);
    });
  });
}
