import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/request/get_info_request.dart';
import 'package:clnapp/api/cln/request/list_funds_request.dart';
import 'package:clnapp/api/cln/request/list_invoices_request.dart';
import 'package:clnapp/api/cln/request/list_transaction_request.dart';
import 'package:clnapp/api/cln/request/listpays_request.dart';
import 'package:clnapp/api/cln/request/pay_request.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_funds.dart';
import 'package:clnapp/model/app_model/list_invoices.dart';
import 'package:clnapp/model/app_model/list_pays.dart';
import 'package:clnapp/model/app_model/list_transaction.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:fixnum/fixnum.dart';

class CLNApi extends AppApi {
  ClientMode mode;
  LightningClient client;

  CLNApi({required this.mode, required this.client});

  @override
  Future<AppGetInfo> getInfo() async {
    dynamic getInfoParams;
    switch (mode) {
      case ClientMode.grpc:
        getInfoParams = CLNGetInfoRequest(grpcRequest: GetinfoRequest());
        break;
      case ClientMode.unixSocket:
        getInfoParams = CLNGetInfoRequest(unixRequest: <String, dynamic>{});
        break;
      case ClientMode.lnlambda:
        getInfoParams = CLNGetInfoRequest(unixRequest: <String, dynamic>{});
        break;
    }
    var appInfo = await client.call<CLNGetInfoRequest, AppGetInfo>(
        method: "getinfo",
        params: getInfoParams,
        onDecode: (jsonResponse) => AppGetInfo.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
    var listFunds = await this.listFunds();
    appInfo.totOffChainMsat = listFunds?.totOffChainMsat ?? 0;
    return appInfo;
  }

  @override
  Future<AppListTransactions> listTransaction() {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params =
            CLNListTransactionRequest(grpcRequest: ListtransactionsRequest());
        break;
      case ClientMode.unixSocket:
        params = CLNListTransactionRequest(unixRequest: <String, dynamic>{});
        break;
      case ClientMode.lnlambda:
        params = CLNListTransactionRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return client.call<CLNListTransactionRequest, AppListTransactions>(
        method: "listtransactions",
        params: params,
        onDecode: (jsonResponse) => AppListTransactions.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppListFunds?> listFunds() {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params = CLNListFundsRequest(grpcRequest: ListfundsRequest());
        break;
      case ClientMode.unixSocket:
        params = CLNListFundsRequest(unixRequest: <String, dynamic>{});
        break;
      case ClientMode.lnlambda:
        params = CLNListFundsRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return client.call<CLNListFundsRequest, AppListFunds?>(
        method: "listfunds",
        params: params,
        onDecode: (jsonResponse) {
          LogManager.getInstance.debug("Grpc list funds call $jsonResponse");
          return AppListFunds.fromJSON(jsonResponse as Map<String, dynamic>,
              snackCase: !mode.withCamelCase(), isObject: mode.hashMsatAsObj());
        });
  }

  @override
  Future<AppListInvoices> listInvoices() {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params = CLNListInvoicesRequest(grpcRequest: ListinvoicesRequest());
        break;
      case ClientMode.unixSocket:
        params = CLNListInvoicesRequest(unixRequest: <String, dynamic>{});
        break;
      case ClientMode.lnlambda:
        params = CLNListInvoicesRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return client.call<CLNListInvoicesRequest, AppListInvoices>(
        method: "listinvoices",
        params: params,
        onDecode: (jsonResponse) => AppListInvoices.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase(),
            isObject: mode.hashMsatAsObj()));
  }

  @override
  Future<AppPayInvoice> payInvoice({required String invoice, int? msat}) async {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        if (msat == null) {
          params = CLNPayRequest(grpcRequest: PayRequest(bolt11: invoice));
        } else {
          Amount? amount = Amount();
          amount.msat = Int64(msat);
          params = CLNPayRequest(
              grpcRequest: PayRequest(bolt11: invoice, amountMsat: amount));
        }
        break;
      case ClientMode.unixSocket:
        if (msat != null) {
          params = CLNPayRequest(unixRequest: <String, dynamic>{
            'bolt11': invoice,
            'msatoshi': "${msat}msat"
          });
        } else {
          params = CLNPayRequest(unixRequest: <String, dynamic>{
            'bolt11': invoice,
          });
        }
        break;
      case ClientMode.lnlambda:
        if (msat != null) {
          params = CLNPayRequest(unixRequest: <String, dynamic>{
            'bolt11': invoice,
            'msatoshi': "${msat}msat"
          });
        } else {
          params = CLNPayRequest(unixRequest: <String, dynamic>{
            'bolt11': invoice,
          });
        }
        break;
    }
    return client.call<CLNPayRequest, AppPayInvoice>(
        method: "pay",
        params: params,
        onDecode: (jsonResponse) => AppPayInvoice.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: mode == ClientMode.unixSocket));
  }

  @override
  Future<AppListPays> listPays() {
    /// Defining the map for the pays pays which are completed
    Map<String, String> map = {"status": "complete"};
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params = CLNListPaysRequest(
            grpcRequest: ListpaysRequest(
                status: ListpaysRequest_ListpaysStatus.COMPLETE));
        break;
      case ClientMode.unixSocket:
        params = CLNListPaysRequest(unixRequest: map);
        break;
      case ClientMode.lnlambda:
        params = CLNListPaysRequest(unixRequest: map);
        break;
    }
    return client.call<CLNListPaysRequest, AppListPays>(
        method: "listpays",
        params: params,
        onDecode: (jsonResponse) => AppListPays.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }
}
