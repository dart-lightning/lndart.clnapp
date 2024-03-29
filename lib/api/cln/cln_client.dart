import 'dart:convert';
import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/api/api.dart';
import 'package:clnapp/api/client_provider.dart';
import 'package:clnapp/api/cln/request/bkpr_listincome_request.dart';
import 'package:clnapp/api/cln/request/decodeinvoice_request.dart';
import 'package:clnapp/api/cln/request/generateinvoice_request.dart';
import 'package:clnapp/api/cln/request/get_info_request.dart';
import 'package:clnapp/api/cln/request/list_funds_request.dart';
import 'package:clnapp/api/cln/request/list_transaction_request.dart';
import 'package:clnapp/api/cln/request/listpeers_request.dart';
import 'package:clnapp/api/cln/request/newaddr_request.dart';
import 'package:clnapp/api/cln/request/pay_request.dart';
import 'package:clnapp/api/cln/request/withdraw_request.dart';
import 'package:clnapp/model/app_model/bkpr_listincome.dart';
import 'package:clnapp/model/app_model/generate_invoice.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_funds.dart';
import 'package:clnapp/model/app_model/list_peers.dart';
import 'package:clnapp/model/app_model/list_transaction.dart';
import 'package:clnapp/model/app_model/newaddr.dart';
import 'package:clnapp/model/app_model/pay_invoice.dart';
import 'package:fixnum/fixnum.dart';
import 'package:clnapp/model/app_model/decode_invoice.dart';
import 'package:clnapp/model/app_model/withdraw.dart';
import 'package:clnapp/model/app_model/appinfo_with_income.dart';

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
            'amount_msat': "${msat}msat"
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
            'amount_msat': "${msat}msat"
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
  Future<AppGenerateInvoice> generateInvoice(String label, String description,
      {int? amount}) {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        var reqAmount = amount == null
            ? AmountOrAny(any: true)
            : AmountOrAny(amount: Amount(msat: Int64(amount)));
        params = CLNGenerateInvoiceRequest(
            grpcRequest: InvoiceRequest(
                label: label, description: description, amountMsat: reqAmount));
        break;
      case ClientMode.unixSocket:
        var reqAmount = amount == null ? "any" : amount.toString();
        params = CLNGenerateInvoiceRequest(unixRequest: <String, dynamic>{
          'amount_msat': reqAmount,
          'label': label,
          'description': description
        });
        break;
      case ClientMode.lnlambda:
        var reqAmount = amount == null ? "any" : amount.toString();
        params = CLNGenerateInvoiceRequest(unixRequest: <String, dynamic>{
          'amount_msat': reqAmount,
          'label': label,
          'description': description
        });
        break;
    }
    return client.call<CLNGenerateInvoiceRequest, AppGenerateInvoice>(
        method: "invoice",
        params: params,
        onDecode: (jsonResponse) => AppGenerateInvoice.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppDecodeInvoice> decodeInvoice(String invoice) {
    dynamic params;
    switch (mode) {
      ///FIXME: Add grpc request
      case ClientMode.grpc:
        throw Exception("Unsupported client");
      case ClientMode.unixSocket:
        params = CLNDecodeInvoiceRequest(unixRequest: <String, dynamic>{
          'string': invoice,
        });
        break;
      case ClientMode.lnlambda:
        params = CLNDecodeInvoiceRequest(unixRequest: <String, dynamic>{
          'string': invoice,
        });
        break;
    }
    return client.call<CLNDecodeInvoiceRequest, AppDecodeInvoice>(
        method: "decode",
        params: params,
        onDecode: (jsonResponse) => AppDecodeInvoice.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppListPeers> listPeers(String id) {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        List<int> idInBytes = utf8.encode(id);
        params =
            CLNListPeersRequest(grpcRequest: ListpeersRequest(id: idInBytes));
        break;
      case ClientMode.unixSocket:
        params = CLNListPeersRequest(unixRequest: <String, dynamic>{
          'id': id,
        });
        break;
      case ClientMode.lnlambda:
        params = CLNListPeersRequest(unixRequest: <String, dynamic>{
          'id': id,
        });
        break;
    }
    return client.call<CLNListPeersRequest, AppListPeers>(
        method: "listpeers",
        params: params,
        onDecode: (jsonResponse) => AppListPeers.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppNewAddr> newAddr() {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        params = CLNNewAddrRequest(grpcRequest: NewaddrRequest());
        break;
      case ClientMode.unixSocket:
        params = CLNNewAddrRequest(unixRequest: <String, dynamic>{});
        break;
      case ClientMode.lnlambda:
        params = CLNNewAddrRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return client.call<CLNNewAddrRequest, AppNewAddr>(
        method: "newaddr",
        params: params,
        onDecode: (jsonResponse) => AppNewAddr.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppWithdraw> withdraw(
      {required String destination, required int mSatoshi}) {
    dynamic params;
    var msats = Int64(mSatoshi);
    switch (mode) {
      case ClientMode.grpc:
        params = CLNWithdrawRequest(
            grpcRequest: WithdrawRequest(
                destination: destination,
                satoshi: AmountOrAll(amount: Amount(msat: msats), all: false)));
        break;
      case ClientMode.unixSocket:
        params = CLNWithdrawRequest(unixRequest: <String, dynamic>{
          "destination": destination,
          "satoshi": "${mSatoshi}msats"
        });
        break;
      case ClientMode.lnlambda:
        params = CLNWithdrawRequest(unixRequest: <String, dynamic>{
          "destination": destination,
          "satoshi": "${mSatoshi}msats"
        });
        break;
    }
    return client.call<CLNWithdrawRequest, AppWithdraw>(
        method: "withdraw",
        params: params,
        onDecode: (jsonResponse) => AppWithdraw.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppListIncome> listincome() {
    dynamic params;
    switch (mode) {
      case ClientMode.grpc:
        throw const FormatException("Not available for this client");
      case ClientMode.unixSocket:
        params = CLNListIncomeRequest(unixRequest: <String, dynamic>{});
        break;
      case ClientMode.lnlambda:
        params = CLNListIncomeRequest(unixRequest: <String, dynamic>{});
        break;
    }
    return client.call<CLNListIncomeRequest, AppListIncome>(
        method: "bkpr-listincome",
        params: params,
        onDecode: (jsonResponse) => AppListIncome.fromJSON(
            jsonResponse as Map<String, dynamic>,
            snackCase: !mode.withCamelCase()));
  }

  @override
  Future<AppInfoWithIncome> getInfoWithIncome() async {
    AppGetInfo info = await getInfo();
    var listIncome = await listincome();
    return AppInfoWithIncome(listIncome, info);
  }
}
