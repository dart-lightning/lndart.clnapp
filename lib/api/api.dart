import 'package:cln_common/cln_common.dart';
import 'package:cln_grpc/cln_grpc.dart';
import 'package:clnapp/model/app_model/get_info.dart';
import 'package:clnapp/model/app_model/list_transaction.dart';
import 'package:clnapp/utils/app_provider.dart';

/// App API implementation, the class contains all the information
/// to make a call to core lightning and return the correct type
/// of useful of the UI.
///
/// author: https://github.com/vincenzopalazzo

/// This is an abstract class of the API interface
/// useful to implement different type use case,
/// like a MockAPI that can be used
/// to develop demo app, or UI testing
abstract class AppApi {
  /// Return all the information of the node
  /// throw a cln getinfo call
  Future<AppGetInfo> getInfo(AppProvider provider) async {
    var nodeInfo = await provider
        .get<GRPCClient>()
        .call<GetInfoProxy, GetinfoResponse>(
            method: "getinfo", params: GetInfoProxy.build());
    AppGetInfo getInfo =
        AppGetInfo(nodeId: nodeInfo.id.toString(), alias: nodeInfo.alias);
    return getInfo;
  }

  /// Return the list of transaction from lightning node.
  Future<AppListTransactions> listTransaction(AppProvider provider) async {
    var transactionList = await provider
        .get<GRPCClient>()
        .call<ListTransactionProxy, ListtransactionsResponse>(
            method: "listtransactions", params: ListTransactionProxy.build());
    List<AppTransaction> transList = [];
    for (int i = 0; i < transactionList.transactions.length; i++) {
      AppTransaction transaction = AppTransaction(
          transactionList.transactions[i].inputs[0].txid.toString());
      transList.add(transaction);
    }
    AppListTransactions listTransactions =
        AppListTransactions(transactions: transList);
    return listTransactions;
  }
}

class ListTransactionProxy extends Serializable {
  ListtransactionsRequest proxy;

  ListTransactionProxy(this.proxy);

  factory ListTransactionProxy.build() =>
      ListTransactionProxy(ListtransactionsRequest());

  @override
  Map<String, dynamic> toJSON() => proxy.writeToJsonMap();

  @override
  T as<T>() => proxy as T;
}

class GetInfoProxy extends Serializable {
  GetinfoRequest proxy;

  GetInfoProxy(this.proxy);

  factory GetInfoProxy.build() => GetInfoProxy(GetinfoRequest());

  @override
  Map<String, dynamic> toJSON() => proxy.writeToJsonMap();

  @override
  T as<T>() => proxy as T;
}
