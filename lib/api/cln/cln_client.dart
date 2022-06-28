import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/request/get_info_request.dart';
import 'package:clnapp/api/cln/request/list_transaction_request.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_transaction.dart';
import 'package:clnapp/utils/app_provider.dart';

class CLNApi extends AppApi {
  ClientMode mode;
  LightningClient client;
  AppProvider provider;

  CLNApi({required this.mode, required this.client, required this.provider});

  @override
  Future<AppGetInfo> getInfo(provider) async {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params = CLNGetInfoRequest(grpcRequest: GetinfoRequest());
        break;
      case ClientMode.unixSocket:
        params = CLNGetInfoRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return await client.call<CLNGetInfoRequest, AppGetInfo>(
        method: "getinfo",
        params: params,
        onDecode: (jsonResponse) =>
            AppGetInfo.fromJSON(jsonResponse as Map<String, dynamic>));
  }

  @override
  Future<AppListTransactions> listTransaction(provider) {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params =
            CLNListTransactionRequest(grpcRequest: ListtransactionsRequest());
        break;
      case ClientMode.unixSocket:
        params = CLNListTransactionRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return client.call<CLNListTransactionRequest, AppListTransactions>(
        method: "listtransactions",
        params: params,
        onDecode: (jsonResponse) =>
            AppListTransactions.fromJSON(jsonResponse as Map<String, dynamic>));
  }
}
