import 'package:cln_common/cln_common.dart';

class AppListFunds {
  List<AppFund> fund;

  AppListFunds({this.fund = const []});

  factory AppListFunds.fromJSON(Map<String, dynamic> json) {
    var funds = json["outputs"] as List;
    if (funds.isNotEmpty) {
      var appFunds = funds.map((fund) => AppFund.fromJSON(fund)).toList();
      return AppListFunds(fund: appFunds);
    } else {
      return AppListFunds();
    }
  }
}

class AppFund {
  /// Transaction identifier
  final String txId;

  /// The quantity of Bitcoin in millisatoshi
  final int amount;

  /// If the transaction is confirmed on the blockchain
  final String confirmed;

  /// If the transaction is reserved for another
  final bool reserved;

  AppFund(
      {required this.txId,
      required this.amount,
      required this.confirmed,
      required this.reserved});

  factory AppFund.fromJSON(Map<String, dynamic> json) {
    LogManager.getInstance.debug("$json");
    // FIXME: the propriety with in the JSON should follow the convention like the cln docs convention?
    return AppFund(
        txId: json["txid"],
        amount: int.parse(json["amountMsat"]["msat"].toString()),
        confirmed: json["status"],
        reserved: json["reserved"] ?? false);
  }
}
